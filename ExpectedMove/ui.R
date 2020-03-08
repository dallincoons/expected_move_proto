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
                            , style = "font-size:1.5em"
                          ),
                          style="line-height: 1"
                        )
                    ),
                    column(3,
                      span(
                        span('Closed Outside'),
                        span(
                          textOutput("closed_outside")
                          , style = "font-size:1.5em"
                        ),
                        style="line-height: 1"
                      )
                    ),
                    column(3,
                       span(
                         span('Never breached'),
                         span(
                           textOutput("never_breached")
                           , style = "font-size:1.5em"
                         ),
                         style="line-height: 1"
                       )
                    ),
                    column(3,
                       span(
                         span('Temporarily Breached'),
                         span(
                           textOutput("temporarily_breached")
                           , style = "font-size:1.5em"
                         ),
                         style="line-height: 1"
                       )
                    ),
                 fluidRow(
                   
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
    
    # tabPanel("Filters", fluid = TRUE, 
    #   h2("Filters"),
    #   
    #   selectInput("day_filter", "Choose a day:",
    #       list("Monday" = "mon", "Tuesday" = "tue", "Wednesday" = "wed", "Thursday" = "thu", "Friday" = "fri")
    #   ),
    #   
    #   selectInput("sd_direction_filter", "Direction breached EM",
    #       list("Up" = "up", "Down" = "down")
    #   ),
    #   
    #   actionButton("filter", "Go", icon("rocket"))
    # )
  )
)