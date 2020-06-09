library(pool)
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(ggplot2)
library(stringr)
library(shinyjs)

source("uiUtils.R")
source("pageModules.R")

# An environment to store app-wide variables
app.env <- new.env()
# The DB connection
# See https://shiny.rstudio.com/articles/pool-basics.html for more
# info on using the pool package
app.env$DB.conn <- dbPool(
  drv = RSQLite::SQLite(),
  dbname = "linearRegression.db") # This stores app info, such as text strings

# Close DB connection when stopping app
onStop(function() 
  {
  poolClose(app.env$DB.conn)
  })

#' Get a string from the DB
#' @param label The string label
#' @return The string (processed with glossary terms)
getAppString <- function(label)
  {
  sql <- "SELECT text FROM app_string WHERE label=?label"
  query <- sqlInterpolate(app.env$DB.conn, sql, label = label)
  res <- dbGetQuery(app.env$DB.conn, query)
  
  res <- processString(res)
  
  res
  }

#' Process an app string to substitute glossary term with <abbr>
#' @param str The string to process
#' @return The processed string
processString <- function(str)
  {
  # Glossary terms are in the form of [[term label,text]]
  # We want to convert them to <abbr title='definition of term'>text</abbr>
  # Where definition of term is pulled from the glossary table of the DB
  
  # Find each token [[xxx,yyy]]
  tokens <- unlist(str_extract_all(str, "\\[\\[([^\\]]+)\\]\\]"))
  # Get rid of the [[]] by using substr, and split by ,
  tokens <- strsplit(substr(tokens, 3, nchar(tokens)-2), ",")
  # Convert into a matrix
  tokens <- do.call("rbind", tokens)
  # Get token start and end
  tokens.pos <- str_locate_all(str, "\\[\\[([^\\]]+)\\]\\]")
    
  # Query the terms
  sql <- "SELECT term, description FROM glossary WHERE term IN ( ?terms )"
  # Little trick to use IN with sqlInterpolate
  query <- sqlInterpolate(app.env$DB.conn, sql, terms = paste(tokens[,1], collapse = "','"))
  query <- gsub("''", "'", query)
  
  res <- dbGetQuery(app.env$DB.conn, query)
  
  # Important! This needs to go from right to left (i.e. nrow(tokens):1) 
  # otherwise the indices won't match
  for (t in nrow(tokens):1) 
    {
    # Get the bits before and after the token
    pre.token <- substr(str, 1, tokens.pos[[1]][t, 1]-1)
    post.token <- substr(str, tokens.pos[[1]][t, 2]+1, nchar(str))
    # Add the <abbr> tag in between!
    title <- res$description[res$term == tokens[t,1]]
    str <- paste0(pre.token, "<abbr title='", title, "'>", tokens[t,2], "</abbr>", post.token)
    }
  
  # Return the processed string
  str
  }