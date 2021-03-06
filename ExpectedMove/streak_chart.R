pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

unbreached_color <- '#0CBCFF'
breached_color <- '#0CBCFF'

red<-'#FF491D'
green<-'#0BFF01'
orange<-'#f28705'
gray<-'#78727A'

streaksChart <- function(startDate, endDate) {
  
  expectedmoves <- get_expected_moves(margin_of_error) %>% 
    filter(week_start >= startDate, week_start <= endDate)

  breached_moves <- expectedmoves %>%
    filter(breached == 1)

  unbreached_moves <- expectedmoves %>%
    filter(breached == 0)

expected_move_rectangles <- unbreached_moves %>% select(week_start, expected_high, expected_low)
unexpected_move_rectangles <- breached_moves %>% select(week_start, expected_high, expected_low)

s_plot <- ggplot() +
  theme_minimal() +
  theme(axis.title.x=element_blank())

if (nrow(unbreached_moves) > 0) {
s_plot <- s_plot + geom_candlestick(data = unbreached_moves,
   aes(x = week_start, open = open,
       high = high, low = low,
       close = close, color_up = 'black',
       color_down = 'black', fill_up = green,
       fill_down = red, inherit.aes = FALSE
   )
  )
}

if (nrow(breached_moves) > 0) {
s_plot <- s_plot + geom_candlestick(
    data = breached_moves,
    aes(x = week_start, open = open,
        high = high, low = low,
        close = close, color_up = 'black',
        color_down = 'black', fill_up = green,
        fill_down = red, inherit.aes = FALSE
    )
  )
}

  if (nrow(expected_move_rectangles) > 0) {
    s_plot <- s_plot +
      geom_rect(
        data = expected_move_rectangles,
        aes(
          xmin = week_start - 3,
          xmax = week_start + 3,
          ymin = expected_low,
          ymax = expected_high),
        inherit.aes=FALSE,
        fill = gray,
        alpha = .3
      )
  }

  if (nrow(unexpected_move_rectangles) > 0) {
    print(nrow(unexpected_move_rectangles))
    s_plot <- s_plot +
      geom_rect(
        data = unexpected_move_rectangles,
        aes(
          xmin = week_start - 3,
          xmax = week_start + 3,
          ymin = expected_low,
          ymax = expected_high),
        inherit.aes=FALSE,
        fill = orange,
        alpha = .3,
      )
  }

  s_plot
}
