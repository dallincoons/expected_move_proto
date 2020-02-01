server <- function(input, output) {
  
  output$expectedMove <- renderPlot({
    ggplot() +
      xlim(0,10) +
      ylim(getChartLowerBound(current_week), getChartUpperBound(current_week)) +
      geom_hline(yintercept=current_week$expected_high, color="black") +
      geom_hline(yintercept=current_week$expected_low, color="black") +
      geom_hline(yintercept=current_week$close, color='red') +
      ylab("") +
      xlab(getMessage()) +
      theme_minimal() +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank())
  })
  
  output$breaches <- renderText({ 
    breaches <- get_breached_count(as.character(input$start_date), input$end_date)
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    paste("Closed inside: ", breaches[1], " Closed outside: ", breaches[2])
  })
  
  output$temporary_breaches <- renderText({ 
    temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
    paste("Never Breached: ", temp_breaches[1], "Temporarily Breached: ", temp_breaches[2])
  })
  
  output$sd_message <- renderText({getClosedSDMessage()})
  output$breached_sd_message <- renderText({getBreachedSDExpectedMoveMessage()})
}