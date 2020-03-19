pacman::p_load(shiny)

source('./expected_moves.R')

expected_moves <- expected_moves()

current_week <<- expected_moves %>% head(1)
last_week <<- expected_moves %>% head(2)[-1,]

source('./current_week_EM_chart.R', local = F)

source('ui.R', local = F)
source('server.R', local = F)


shiny::shinyApp(ui = ui, server = server)

shiny::runApp()
