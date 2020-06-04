dashboardPage(
    skin = "green",
    dashboardHeader(title = "Linear regression - Introduction", titleWidth = 400),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        tags$head
            (
            # Roboto Slab font
            tags$link(rel = "stylesheet", type = "text/css",
                      href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@200;400;700&display=swap"),
            # Our CSS
            tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
            # Our JS scripts
            #tags$script(src="scripts.js")
            ),
            
        fluidRow(
            column(width = 12,
                   box(width = 12, title = "Introduction", status = "success", solidHeader = T,
                       column(width = 6,
                              uiOutput("page1_intro")),
                       column(width = 6,
                              plotOutput("page1_dataPlot"))))
            ) # end fluidRow
        ) # end dashboardBody
    ) # end dashboardPage
