source('proximity_chart_generator.r', local = T)
source('current_week_EM_chart.R', local = T)

pacman::p_load(tidyverse)

get_margin_of_error <- function(input) {
  return(as.numeric(input$margin_of_error) / 100)  
}

value_or_zero <- function(value) {
  return(ifelse(is.na(value), 0, value))
}

server <- function(input, output) {
  
  output$expectedMove <- renderPlot({
    showCurrentWeekEMChart()
  })
  
  output$closed_inside <- renderText({ 
    margin_of_error <- get_margin_of_error(input)
    breaches <- get_breached_count(as.character(input$start_date), input$end_date, margin_of_error)
    paste("Weeks closed inside: ", value_or_zero(breaches[1]))
  })
  
  output$closed_outside <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date, get_margin_of_error(input))
    paste("Weeks closed outside: ", value_or_zero(breaches[2]))
  })
  
  output$never_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date, get_margin_of_error(input))
    paste("Weeks never breached: ", value_or_zero(temp_breaches[1]))
  })
  
  output$temporarily_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date, get_margin_of_error(input))
    paste("Weeks temporarily breached: ", value_or_zero(temp_breaches[2]))
  })
  
  output$sd_message <- renderText({
    return(sprintf("Closed outside by %s deviations", getClosedOutsideDeviations()))
  })
  
  output$breached_sd_message <- renderText({
    return(sprintf("Breached by %s deviations", getBreachedStandardDeviation()))
  })
  
  output$streaks <- renderText({
    return(sprintf("%s for the last %s weeks", ifelse(isRecentStreakOfTypeBreach(get_margin_of_error(input)), "Breached EM", "Stayed inside EM"), getRecentStreak(get_margin_of_error(input))))
  })
  
  output$em_level_text <- renderText({
    return(sprintf(
      'The expected move this week is between %s and %s', 
      current_week$expected_low, 
      current_week$expected_high
    ))
  })
  
  output$streaksChart <- renderPlot({
    source('./streak_chart.R')
    
    streaksChart(input$start_date, input$end_date, get_margin_of_error(input))
  })
}

