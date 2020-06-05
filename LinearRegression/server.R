shinyServer(function(session, input, output) 
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
        runjs("showElement('startQuestions', false);")
        runjs("blurElement('page1_intro', 5);")        
        })
    
    observeEvent(input$submitAnswers,
        {
        runjs("checkAnswers();")    
        })
    })
