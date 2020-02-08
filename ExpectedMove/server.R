source('proximity_chart_generator.r', local = T)

pacman::p_load(tidyverse)

server <- function(input, output) {
  
  output$expectedMove <- renderPlot({
    ggplot() +
      xlim(0,10) +
      ylim(getChartLowerBound(current_week), getChartUpperBound(current_week)) +
      geom_hline(yintercept=current_week$expected_high, color="black") +
      geom_hline(yintercept=current_week$expected_low, color="black") +
      geom_hline(yintercept=current_week$close, color='red') +
      ylab("SPY stock price") +
      xlab("") +
      theme_minimal() +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank())
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
    
    streaksChart(input$streak_start_date, input$streak_end_date)
  })
}