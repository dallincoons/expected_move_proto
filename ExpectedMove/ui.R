pacman::p_load(shinythemes, lubridate)

ui <- fluidPage(
  
  theme = shinytheme("paper"),
  
  tabsetPanel(
    
    tabPanel("Weekly Move", fluid = TRUE,
       h2(
         'Expected Move for S&P 500 (SPY)',
         style = "font-size:20px"
       ),       
       
       div(
         span(textOutput('em_level_text'))
       ),
       
       div(
         span(textOutput('sd_message'), style="font-size:1.3em"),
         style = "margin-top:2em;"
       ),

       div(
         span(textOutput('breached_sd_message'), style="font-size:1.3em")
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
                 textInput("margin_of_error", "Expected move expansion %", .2),
                 actionButton("submit_streaks", "Go")
               ),
               
               mainPanel(
                 fluidRow(
                   column(8,
                        span(
                          'Breach Expected Move Streak'
                        ),
                        span(
                          textOutput('streaks')
                          , style="font-size:1.6em; font-weight: 800; line-height: 1"
                        )
                   )
                 ),
                 br(),
                 fluidRow(
                    column(3,
                      span(
                          span('Closed Inside'),
                          span(
                            textOutput("closed_inside")
                            , style = "font-size:1.5em; font-weight: 900"
                          ),
                          style="line-height: 1"
                        )
                    ),
                    column(3,
                      span(
                        span('Closed Outside'),
                        span(
                          textOutput("closed_outside")
                          , style = "font-size:1.5em; font-weight: 900"
                        ),
                        style="line-height: 1"
                      )
                    ),
                    column(3,
                       span(
                         span('Never breached'),
                         span(
                           textOutput("never_breached")
                           , style = "font-size:1.5em; font-weight: 900"
                         ),
                         style="line-height: 1"
                       )
                    ),
                    column(3,
                       span(
                         span('Temporarily Breached'),
                         span(
                           textOutput("temporarily_breached")
                           , style = "font-size:1.5em; font-weight: 900"
                         ),
                         style="line-height: 1"
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
    ),
    
    tabPanel("Filters", fluid = TRUE,
      h2("Filters"),

      selectInput("weekday_filter", "Choose a day:",
          list("Monday" = 1, "Tuesday" = 2, "Wednesday" = 3, "Thursday" = 4, "Friday" = 5)
      ),

      selectInput("sd_direction_filter", "Direction breached EM",
          list("Up" = "up", "Down" = "down")
      ),
      
      fluidRow(
        column(3,
           span('Weeks closed inside', style="font-weight: 900"),
           span(
             textOutput("weeks_closed_inside")
             , style = "font-size:1.5em; font-weight: 900"
           )
        ),
        column(3,
               span('Weeks closed outside', style="font-weight: 900"),
               span(
                 textOutput("weeks_closed_outside")
                 , style = "font-size:1.5em; font-weight: 900"
               )
        )
      ),
      
      dataTableOutput('filter_results'),

      actionButton("run_filter", "Go", icon("rocket"))
    )
  )
)