pacman::p_load(shiny, shinythemes)

library(shiny)
library(shinythemes)

source('./proximity_chart_generator.r', local = T)
source('ui.R')

shinyApp(ui = ui, server = server)

