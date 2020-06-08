#' Adds the ui for the question(s)
#' @param labels The id of the question(s)
#' @return The question(s) HTML
addQuestions <- function(labels)
  {
  questions <- list()
  
  for (l in 1:length(labels))
    {
    sql <- "SELECT q.id AS qid, q.question, q.type, 
            a.id AS ansid, a.text AS anstext, a.correct AS anscorrect
            FROM question AS q
            LEFT JOIN answer AS a ON a.question_id = q.id 
            WHERE q.label = ?label"
    
    query <- sqlInterpolate(app.env$DB.conn, sql, label = labels[l])
    res <- dbGetQuery(app.env$DB.conn, query)
    
    if (nrow(res)) # We found the question
      {
      if (res$type[1] == "mcq")
        {
        answers <- setNames(paste0("ans_",res$ansid), res$anstext)
        questions[[l]] <- tagList(div(id = paste0("question_mcq_", res$qid[1]),
                                      div(res$question[1]), 
                                      tag("input", list(type = "hidden",
                                                        id = paste0("ca_",res$qid[1]),
                                                        value = paste0(res$ansid[res$anscorrect==1], 
                                                                       collapse = ","))),
                                      awesomeCheckboxGroup(inputId = paste0("answers_", res$qid[1]), 
                                                           label = "Choose one or more answers",
                                                           choices = answers)))
        }
      else if (res$type[1] == "mcq-single")
        {
        questions[[l]] <- tagList(div(id = paste0("question_mcqs_", res$qid[1]),
                                      div(res$question[1]), 
                                      tag("input", list(type = "hidden", 
                                                        id = paste0("ca_",res$qid[1]),
                                                        value = paste0(res$ansid[res$anscorrect], 
                                                                       collapse = ","))),
                                      radioButtons(inputId = paste0("answers_", res$qid[1]), 
                                                   label = "Choose one answer",
                                                   choiceValues = res$ansid,
                                                   choiceNames = res$anstext,
                                                   selected = character(0))))
        } 
      }
    }
  
  # Add the submit button
  questions[[length(questions)+1]] <- actionBttn("submitAnswers", "Submit answers", 
                                                 icon = icon("arrow-alt-circle-right"), 
                                                 style = "material-flat", 
                                                 size = "sm", color = "success")
  
  # Return the questions UI 
  questions
  }