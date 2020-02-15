pacman::p_load(shinythemes, lubridate)

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
       
       div(
         span(textOutput('breached_sd_message'), style="font-size:1.3em"), 
         style = "margin-top:2em;"
       ),
       
       br(),
       
       plotOutput("expectedMove")
    ),
    
    tabPanel("Breached Stats", fluid = TRUE,
             sidebarLayout(
               fluid = TRUE,
               sidebarPanel(
                 textInput("start_date", "Start Date", today() - months(4)),
                 textInput("end_date", "End Date", lubridate::today()),
                 br(),
                 textInput("margin_of_error", "Margin of Error %", .2)
               ),
               
               mainPanel(
                 fluidRow(
                   column(8,
                        span(
                          textOutput('streaks')
                          , style="font-size:1.6em"
                        )
                   )
                 ),
                 br(),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("closed_inside")
                            , style = "font-size:1.5em"
                          )
                   )
                   
                 ),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("closed_outside")
                            , style = "font-size:1.5em"
                          )
                   )
                 ),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("never_breached")
                            , style = "font-size:1.5em"
                          )
                   )
                 ),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("temporarily_breached")
                            , style = "font-size:1.5em"
                          )
                   )
                 )
               )
             ),
             
             fluidPage(
               fluidRow(
                 plotOutput("streaksChart")
               )
             )
    )
  )
)