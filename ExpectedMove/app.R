pacman::p_load(shiny)

library(shiny)
# library(shinythemes)

source('proximity_chart_generator.r', local = T)
source('ui.R')
source('server.R')

shiny::shinyApp(ui = ui, server = server)

shiny::runApp()
