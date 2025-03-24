library(shiny)
library(plotly)
library(DT)

ui <- fluidPage(
  titlePanel("League of Legends Champion Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("plot_type", "Choose a Plot:", 
                  choices = c("Difficulty Distribution", 
                              "Num Champions by Role",
                              "Champion Role Breakdown by Range Type",
                              "Champion Style Scores by Hero Type")),
      
      # Filtering options for range type when applicable
      conditionalPanel(
        condition = "input.plot_type == 'Champion Role Breakdown by Range Type'",
        checkboxGroupInput("selected_rangetype", "Filter by Range Type:", 
                           choices = NULL,  # This will be updated dynamically
                           selected = NULL)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plots", plotlyOutput("plot")), 
        tabPanel("Data Table", DTOutput("data_table"))
      )
    )
  )
)
