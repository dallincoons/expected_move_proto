library(shiny)

source('./proximity_chart_generator.r', local = T)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Expected Moves"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         # sliderInput("bins",
         #             "Number of bins:",
         #             min = 1,
         #             max = 50,
         #             value = 30),
         
         textInput("start_date", "Start Date", "YYYY-MM-DD"),
         textInput("end_date", "End Date", "YYYY-MM-DD")
      ),
      
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         textOutput("breaches"),
         textOutput("temporary_breaches")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
   # output$distPlot <- renderPlot({
   #    # generate bins based on input$bins from ui.R
   #    x    <- faithful[, 2] 
   #    bins <- seq(min(x), max(x), length.out = input$bins + 1)
   #    
   #    # draw the histogram with the specified number of bins
   #    hist(x, breaks = bins, col = 'darkgray', border = 'white')
   # })
   
   output$breaches <- renderText({ 
     breaches <- get_breached_count(as.character(input$start_date), input$end_date)
     temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
     paste("Closed inside: ", breaches[1], " Closed outside: ", breaches[2])
   })
   
   output$temporary_breaches <- renderText({ 
     temp_breaches <- get_temporarily_breached_count(input$start_date, input$end_date)
     paste("Never Breached: ", temp_breaches[1], "Temporarily Breached: ", temp_breaches[2])
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

