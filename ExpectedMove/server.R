source('proximity_chart_generator.r', local = T)
source('current_week_EM_chart.R', local = T)

pacman::p_load(tidyverse)

server <- function(input, output) {
  
  output$expectedMove <- renderPlot({
    showCurrentWeekEMChart() 
  })
  
  output$closed_inside <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date)
    paste("Weeks closed inside: ", breaches[1])
  })
  
  output$closed_outside <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date)
    paste("Weeks closed outside: ", breaches[2])
  })
  
  output$never_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    paste("Weeks never breached: ", temp_breaches[1])
  })
  
  output$temporarily_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    paste("Weeks temporarily breached: ", temp_breaches[2])
  })
  
  output$sd_message <- renderText({
    return(sprintf("Closed outside the expected move by %s deviations", getClosedOutsideDeviations()))
  })
  
  output$breached_sd_message <- renderText({
    return(sprintf("Breached by %s deviations", getBreachedStandardDeviation()))
  })
  
  output$streaks <- renderText({
    return(sprintf("%s for the last %s weeks", ifelse(isRecentStreakOfTypeBreach(), "Breached EM", "Stayed inside EM"), getRecentStreak()))
  })
  
  output$streaksChart <- renderPlot({
    source('./streak_chart.R')
    
    streaksChart(input$start_date, input$end_date, as.numeric(input$margin_of_error) / 100)
  })
}