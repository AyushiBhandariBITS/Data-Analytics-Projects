library(shiny)
library(shinydashboard)
library(DT)
library(data.table)
library(ggplot2)

rfm <- fread("rfm_clusters.csv")

ui <- dashboardPage(
  dashboardHeader(title = "Customer Segmentation Dashboard"),
  dashboardSidebar(
    selectInput("cluster", "Select Cluster", choices = c("All", unique(rfm$Cluster)), selected = "All")
  ),
  dashboardBody(
    fluidRow(
      box(title = "RFM Table", width = 12,
          DTOutput("rfm_table"))
    ),
    fluidRow(
      box(title = "Monetary Distribution", width = 6,
          plotOutput("monetary_plot")),
      box(title = "Recency vs Frequency", width = 6,
          plotOutput("rf_plot"))
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    if (input$cluster == "All") return(rfm)
    else return(rfm[Cluster == input$cluster])
  })
  
  output$rfm_table <- renderDT({
    datatable(filtered_data())
  })
  
  output$monetary_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Monetary, fill = Cluster)) +
      geom_histogram(bins = 30) +
      theme_minimal()
  })
  
  output$rf_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Frequency, y = Recency, color = Cluster)) +
      geom_point(alpha = 0.6) +
      theme_minimal()
  })
}

shinyApp(ui, server)
