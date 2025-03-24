library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)

lol_champion_df <- read.csv(file.path("data", "140325_LoL_champion_data.csv"))

server <- function(input, output, session) {
  
  observe({
    updateCheckboxGroupInput(session, "selected_rangetype", 
                             choices = unique(lol_champion_df$rangetype),
                             selected = unique(lol_champion_df$rangetype))
  })
  
  output$plot <- renderPlotly({
    p <- NULL
    
    if (input$plot_type == "Difficulty Distribution") {
      p <- ggplot(lol_champion_df, aes(x = difficulty)) +
        geom_bar(fill = "blue", color = "black") +
        theme_minimal() +
        labs(title = "Difficulty Distribution", x = "Difficulty", y = "Count")
      
    } else if (input$plot_type == "Num Champions by Role") {
      p <- ggplot(lol_champion_df, aes(x = role)) +
        geom_bar(fill = "violet", color = "black") +
        theme_minimal() +
        coord_flip() +
        labs(title = "Num Champions by Role", x = "Role", y = "Count")
      
    } else if (input$plot_type == "Champion Role Breakdown by Range Type") {
      filtered_df <- lol_champion_df %>%
        filter(rangetype %in% input$selected_rangetype)
      
      p <- ggplot(filtered_df, aes(x = role, fill = rangetype)) +
        geom_bar(position = "fill") +
        theme_minimal() +
        coord_flip() +
        labs(title = "Champion Role Breakdown by Range Type", x = "Role", y = "Proportion", fill = "Range Type")
      
    } else if (input$plot_type == "Champion Style Scores by Hero Type") {
      p <- ggplot(lol_champion_df, aes(x = herotype, y = style, fill = herotype)) +
        geom_boxplot() +
        theme_minimal() +
        labs(title = "Champion Style Scores by Hero Type", x = "Hero Type", y = "Style Score")
    }
    
    ggplotly(p)
  })
  
  output$data_table <- renderDT({
    datatable(lol_champion_df, options = list(pageLength = 10, scrollX = TRUE))
  })
}

