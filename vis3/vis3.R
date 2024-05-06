library(shiny)
library(highcharter)
library(plotly)
library(dplyr)
library(lubridate)
library(shinyjs)


setwd("/Users/kristy/Desktop/KUL/Y2/Data Visualisation/DEAD-main/data")


# Define server logic
server <- function(input, output) {
  # Load and preprocess data
  data <- read.csv("vis3data_interactive.csv")
  data <- data[, -1] # Remove index column
  data$OrderDate <- as.Date(data$OrderDate)
  data$MonthYear <- format(data$OrderDate, "%Y-%m")
  
  # Aggregate revenue by month and year for each product type
  monthly_aggregated <- data %>%
    group_by(Type, MonthYear) %>%
    summarise(Revenue = sum(Revenue))
  
  # Render Highcharter plot for revenue plot
  output$revenue_plot <- renderHighchart({
    hchart(
      monthly_aggregated,
      "line",
      hcaes(x = MonthYear, y = Revenue, group = Type)
    ) %>%
      hc_plotOptions(series = list(
        events = list(
          click = JS("function(event) { Shiny.onInputChange('click_id', event.point.series.name); }")
        )
      )) %>% 
      hc_plotOptions(series = list(
        marker = list(enabled = FALSE) # Remove shape markers for all lines
      )) %>%
      hc_title(text = "Revenue by Product Type") # Add title for the chart
  })
  
  # Render Highcharter plot for breakdown chart
  output$breakdown_plot <- renderHighchart({
    # Check if a series is clicked
    clicked_series <- input$click_id
    
    if (!is.null(clicked_series)) {
      # Filter the data to include only the selected series
      selected_data <- data %>%
        filter(Type == clicked_series) %>%
        group_by(Products, MonthYear) %>%
        summarise(Revenue = sum(Revenue))
      
      # Identify the top 10 products with the highest revenue
      top_products <- selected_data %>%
        group_by(Products) %>%
        summarise(Total_Revenue = sum(Revenue)) %>%
        arrange(desc(Total_Revenue)) %>%
        top_n(10)
      
      # Filter the data to include only the top 10 products
      top10_products <- selected_data %>%
        filter(Products %in% top_products$Products)
      
      # Create the breakdown chart
      breakdown_chart <- hchart(
        top10_products,
        "line",
        hcaes(x = MonthYear, y = Revenue, group = Products)
      ) %>%
        hc_plotOptions(series = list(
          marker = list(enabled = FALSE) # Remove shape markers for all lines
        )) %>%
        hc_title(text = paste("Breakdown Chart for", clicked_series)) # Add title for the chart
      
      return(breakdown_chart)
    }
  })
}

# Define UI
ui <- fluidPage(
  titlePanel("Revenue Visualization"),
  sidebarLayout(
    sidebarPanel(
      # You can add inputs or controls here if needed
    ),
    mainPanel(
      highchartOutput("revenue_plot"),
      highchartOutput("breakdown_plot")
    )
  )
)

# Run the application
shinyApp(ui = ui, server = server)
