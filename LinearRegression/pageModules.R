##### This is the module for page 1 #####
# See https://shiny.rstudio.com/articles/modules.html for important info on how 
# modules work
lmPage1UI <- function(id)
  {
  ns <- NS(id)
  
  tagList(
    fluidRow(
        column(width = 12,
               box(width = 12, title = "Introduction", status = "success", solidHeader = T,
                   column(width = 6,
                          uiOutput(ns("page1_intro")),
                          actionBttn(ns("startQuestions"), "Answer questions", 
                                     icon = icon("question-circle"),
                                     style = "material-flat", size = "sm", color = "success"),
                          conditionalPanel("input['page1-startQuestions'] > 0",
                                           addQuestions(c("lin_reg_type", "lin_predictor"))),
                          hidden(actionBttn(ns("gotoNextPage"), "Next page", 
                                            icon = icon("arrow-right"),
                                            style = "material-flat", size = "sm", color = "success")),
                          hidden(actionBttn(ns("retry"), "Try again!", 
                                            icon = icon("question-circle"),
                                            style = "material-flat", size = "sm", color = "primary"))
                   ),
                   column(width = 6,
                          plotOutput(ns("page1_dataPlot")))))
      ) # end fluidRow
    ) # end tagList
  }

lmPage1 <- function(input, output, session)
  {
  output$page1_intro <- renderText(getAppString("linear_regression_intro"))
  
  output$page1_dataPlot <- renderPlot({
    example_data <- data.frame(Predictor = runif(30, -30, 50))
    example_data$Outcome = 2 * example_data$Predictor + 5 + rnorm(30, 0, 10)
    
    ggplot(example_data, aes(Predictor, Outcome)) +
      geom_point(size = 2.5) +
      xlab("Variable A") +
      ylab("Variable B") +
      theme(text = element_text(size = 12, family = "Roboto Slab"))
    }) # End renderPlot
  
  observeEvent(input$startQuestions,
               {
               runjs("showElement('page1-startQuestions', false);")
               runjs("blurElement('page1-page1_intro', 5);")        
               })
  }
  
lmPage2 <- function(input, output, session)
  {
  
  }