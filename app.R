library(shiny)

ui <- fluidPage(
  titlePanel("Search and import pathways"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel"),
    mainPanel("main panel")
  )
)
server <- function (input, output) {
  
  
}

shinyApp(ui=ui, server=server)
