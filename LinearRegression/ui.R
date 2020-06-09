dashboardPage(
    skin = "green",
    dashboardHeader(title = "Linear regression - Introduction", titleWidth = 400),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        useShinyjs(),
        
        tags$head
            (
            # Roboto Slab font
            singleton(tags$link(rel = "stylesheet", type = "text/css",
                      href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@200;400;700&display=swap")),
            # Our CSS
            singleton(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
            # Our JS scripts
            singleton(tags$script(src="scripts.js"))
            ),
        
        lmPage1UI("page1")
        ) # end dashboardBody
    ) # end dashboardPage