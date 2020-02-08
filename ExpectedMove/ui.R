library(shinythemes, lubridate)

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
       
       plotOutput("expectedMove"),
       
       br(),
       
       div(
          span(textOutput('streaks'), style="font-size:1.3em")
       ),
        span(
          textInput("streak_start_date", "Start Date", Sys.Date() %m+% months(-4)),
          textInput("streak_end_date", "End Date", lubridate::today())
        ),
       plotOutput("streaksChart")
    ),
    tabPanel("Breached Stats", fluid = TRUE,
             sidebarLayout(
               fluid = TRUE,
               sidebarPanel(
                 textInput("start_date", "Start Date", '2019-01-01'),
                 textInput("end_date", "End Date", lubridate::today())
               ),
               
               mainPanel(
                 fluidRow(
                   column(8,
                          span(
                            textOutput("closed_inside")
                            , style = "font-size:1.5em"
                          )
                   )
                 ),
                 br(),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("closed_outside")
                            , style = "font-size:1.5em"
                          )
                   )
                 ),
                 br(),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("never_breached")
                            , style = "font-size:1.5em"
                          )
                   )
                 ),
                 br(),
                 fluidRow(
                   column(8,
                          span(
                            textOutput("temporarily_breached")
                            , style = "font-size:1.5em"
                          )
                   )
                 )
               )
             )
    )
  )
)