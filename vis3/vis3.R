library(shiny)
library(highcharter)
library(plotly)
library(dplyr)
library(lubridate)
library(shinyjs)
library(tools)

setwd("/Users/kristy/Desktop/KUL/Y2/Data Visualisation/DEAD-main/data")


# Load and preprocess data
data <- read.csv("vis3data_interactive.csv")
data <- data[, -1] # Remove index column
data$OrderDate <- as.Date(data$OrderDate)
data$MonthYear <- format(data$OrderDate, "%Y-%m")

# Define server logic
server <- function(input, output) {
  
  # Filter data based on selected date range
  filtered_data <- reactive({
    req(input$date_range) # Require date range to be selected
    
    start_date <- as.Date(input$date_range[1])
    end_date <- as.Date(input$date_range[2])
    
    data %>%
      filter(OrderDate >= start_date, OrderDate <= end_date)
  })
  
  # Aggregate revenue by month and year for each product type
  monthly_aggregated <- reactive({
    req(filtered_data()) # Require filtered data to be available
    
    filtered_data() %>%
      group_by(Type, MonthYear) %>%
      summarise(Revenue = sum(Revenue))
  })
  
  # Render Highcharter plot for revenue plot
  output$revenue_plot <- renderHighchart({
    hchart(
      monthly_aggregated(),
      "line",
      hcaes(x = MonthYear, y = Revenue, group = Type)
    ) %>%
      hc_plotOptions(series = list(
        events = list(
          click = JS("function(event) { Shiny.onInputChange('click_id', event.point.series.name); }")
        )
      )) %>% 
      hc_xAxis(title = list(text = "Time")) %>%
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
      selected_data <- filtered_data() %>%
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
        hc_xAxis(title = list(text = "Time")) %>%
        hc_plotOptions(series = list(
          marker = list(enabled = FALSE) # Remove shape markers for all lines
        )) %>%
        hc_title(text = paste("Top 10 Products in", clicked_series)) # Add title for the chart
      
      return(breakdown_chart)
    }
  })
}

# Define UI
ui <- fluidPage(
  titlePanel("Revenue Visualization"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "Select Date Range:", start = min(data$OrderDate), end = max(data$OrderDate)),
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
