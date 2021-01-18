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
                          uiOutput(ns("page1_content")),
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
  output$page1_content <- renderText(getAppString("linear_regression_intro"))
  
  output$page1_dataPlot <- renderPlot({
    ggplot(app.env$linreg.data, aes(Predictor, Outcome)) +
      geom_point(size = 2.5) +
      xlab("Variable A") +
      ylab("Variable B") +
      theme(text = element_text(size = 12, family = "Roboto Slab"))
    }) # End renderPlot
  
  observeEvent(input$startQuestions,
               {
               runjs("showElement('page1-startQuestions', false);")
               runjs("blurElement('page1-page1_content', 5);")        
               })
  }
  
lmPage2UI <- function(id)
  {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width = 12,
             box(width = 12, title = "Finding the best fitting line", status = "success", solidHeader = T,
                 fluidRow(
                   column(width = 6,
                          uiOutput(ns("page2_content"))
                          # actionBttn(ns("startQuestions"), "Answer questions", 
                          #            icon = icon("question-circle"),
                          #            style = "material-flat", size = "sm", color = "success"),
                          # conditionalPanel("input['page2-startQuestions'] > 0",
                          #                  addQuestions(c("lin_reg_type", "lin_predictor"))),
                          # hidden(actionBttn(ns("gotoNextPage"), "Next page", 
                          #                   icon = icon("arrow-right"),
                          #                   style = "material-flat", size = "sm", color = "success")),
                          # hidden(actionBttn(ns("retry"), "Try again!", 
                          #                   icon = icon("question-circle"),
                          #                   style = "material-flat", size = "sm", color = "primary"))
                   ),
                   column(width = 6, 
                          plotOutput(ns("page2_dataPlot")),
                          sliderInput(ns("slope"), "Slope", min = 0, max = 10, 
                                 value = 2, step = 0.1)
                          )
                   ) # end FluidRow
                 )
             )
      ) # end fluidRow
    ) # end tagList
  }

lmPage2 <- function(input, output, session)
    {
    output$page2_content <- renderText(getAppString("linear_regression_bestline"))
    output$page2_dataPlot <- renderPlot({
                            ggplot(app.env$linreg.data, aes(Predictor, Outcome)) +
                              geom_point(size = 2.5) +
                              xlab("Variable A") +
                              ylab("Variable B") +
                              # We need coord_cartesian in order to plot all of the annotations
                              # https://stackoverflow.com/questions/25685185/
                              coord_cartesian(ylim = c(-100, 100)) + 
                              geom_abline(slope = input$slope, intercept = 0) +
                              annotate("segment", x = app.env$linreg.data$Predictor,
                                       xend = app.env$linreg.data$Predictor,
                                       y = app.env$linreg.data$Outcome,
                                       yend = app.env$linreg.data$Predictor * input$slope,
                                       col = "red") +
                              theme(text = element_text(size = 12, family = "Roboto Slab"))
                            })

    observeEvent(input$startQuestions,
               {
               runjs("showElement('page2-startQuestions', false);")
               runjs("blurElement('page2-page1_content', 5);")        
               })
    }