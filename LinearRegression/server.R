shinyServer(function(session, input, output) 
    {
    callModule(lmPage1, "page1")
    
    observeEvent(input$submitAnswers,
                 {
                 runjs("checkAnswers();")    
                 })
    
    observeEvent(input$`page1-gotoNextPage`,
                 {
                 runjs("$('#pageContent').html('')")
                 insertUI(selector = "#pageContent", 
                          where = "afterBegin",
                          ui = lmPage2UI("page2"))
                 
                 callModule(lmPage2, "page2")
                 })
    })
