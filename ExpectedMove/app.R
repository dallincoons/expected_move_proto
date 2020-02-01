pacman::p_load(shiny, shinythemes)

library(shiny)
library(shinythemes)

source('./proximity_chart_generator.r', local = T)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = shinytheme("paper"),
   
   # Application title
   titlePanel("Expected Moves"),
  
   tabsetPanel(
     
   tabPanel("Weekly Move", fluid = TRUE,
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      fluid = TRUE,
      sidebarPanel(
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
      )
    )
   ),
   tabPanel("Breached Stats", fluid = TRUE,
            sidebarLayout(
              fluid = TRUE,
              sidebarPanel(
                textInput("start_date", "Start Date", "YYYY-MM-DD"),
                textInput("end_date", "End Date", "YYYY-MM-DD")
              ),
              
              # Show a plot of the generated distribution
              mainPanel(
                plotOutput("distPlot"),
                fluidRow(
                  column(8, offset = 3,
                         textOutput("breaches")
                  )
                ),
                br(),
                fluidRow(
                  column(8, offset = 3,
                         textOutput("temporary_breaches")
                  )
                )
              )
            )
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

