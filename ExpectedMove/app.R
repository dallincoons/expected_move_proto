pacman::p_load(shiny)

margin_of_error <<- 0.002

source('./expected_moves.R')

expected_moves <- get_expected_moves()

current_week <<- expected_moves %>% head(1)
last_week <<- expected_moves %>% head(2)[-1,]

source('./current_week_EM_chart.R', local = F)

source('ui.R', local = F)
source('server.R', local = F)


shiny::shinyApp(ui = ui, server = server)

shiny::runApp()
