shinyServer(function(session, input, output) 
    {
    callModule(lmPage1, "page1")
    
    observeEvent(input$submitAnswers,
                 {
                     runjs("checkAnswers();")    
                 })
    })
