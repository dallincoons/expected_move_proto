ui <- fluidPage(
  
  theme = shinytheme("paper"),
  
  # Application title
  titlePanel("Expected Moves"),
  
  tabsetPanel(
    
    tabPanel("Weekly Move", fluid = TRUE,
             div(
               span(textOutput('sd_message'), style="font-size:1.3em"), 
               style = "margin-top:2em;"
             ),
             
             plotOutput("expectedMove")
    ),
    tabPanel("Breached Stats", fluid = TRUE,
             sidebarLayout(
               fluid = TRUE,
               sidebarPanel(
                 textInput("start_date", "Start Date", "YYYY-MM-DD"),
                 textInput("end_date", "End Date", "YYYY-MM-DD")
               ),
               
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