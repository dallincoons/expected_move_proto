source('current_week_EM_chart.R', local = F)
source('current_week_EM.r', local = F)
source('filtered_stats.R', local = F)

pacman::p_load(tidyverse)

get_margin_of_error <- function(input) {
  
  if (input$margin_of_error == '') {
    return(margin_of_error / 100)
  }
  
  return(as.numeric(input$margin_of_error) / 100)  
}

value_or_zero <- function(value) {
  return(ifelse(is.na(value), 0, value))
}

populateStreaks <- function(input, output) {
  assign("margin_of_error", get_margin_of_error(input), envir = .GlobalEnv)
  
  output$streaks <- renderText({
    return(sprintf("%s for the last %s weeks", ifelse(isRecentStreakOfTypeBreach(), "Outside EM", "Inside"), getRecentStreak()))
  })
  
  output$closed_inside <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date)
    return(value_or_zero(breaches[1]))
  })
  
  output$closed_outside <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date)
    return(value_or_zero(breaches[2]))
  })
  
  output$never_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    return(value_or_zero(temp_breaches[1]))
  })
  
  output$temporarily_breached <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    return(value_or_zero(temp_breaches[2]))
  })
  
  output$streaksChart <- renderPlot({
    source('./streak_chart.R')
    
    streaksChart(input$start_date, input$end_date)
  })
}

server <- function(input, output) {
  
  output$expectedMove <- renderPlot({
    showCurrentWeekEMChart()
  })
  
  output$sd_message <- renderText({
    closedOutsideBy <- getClosedOutsideDeviations()
    
    if (closedOutsideBy < 0) {
      return("Closed inside the expected move")
    }
    
    return(sprintf("Closed outside by %s deviations", closedOutsideBy))
  })
  
  output$breached_sd_message <- renderText({
    breachedBy <- getBreachedStandardDeviation()
      
    if (breachedBy <= 0) {
      return("Never breached expected move")
    }
    
    return(sprintf("Breached by %s deviations", getBreachedStandardDeviation()))
  })
  
  output$em_level_text <- renderText({
    return(sprintf(
      'The expected move this week is between %s and %s', 
      current_week$expected_low, 
      current_week$expected_high
    ))
  })
  
  observeEvent(input$submit_streaks, {
    print('test')
    populateStreaks(input, output)
  }, ignoreInit = FALSE, ignoreNULL = FALSE)
  
  # Filters #
  
  output$filter_results <- renderDataTable(getFilteredStats(filters(
    weekday=as.numeric(input$weekday_filter),
    direction_breached=as.character(input$sd_direction_filter)
  )))
}



