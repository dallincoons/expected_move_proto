pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

streaksChart <- function(startDate, endDate) {
  
  expectedmoves <- expected_moves(margin_of_error) %>% 
    filter(week_start >= startDate, week_start <= endDate)
  
  breached_moves <- expectedmoves %>%
    filter(breached == 1)
  
  unbreached_moves <- expectedmoves %>%
    filter(breached == 0)
  
  expected_move_rectangles <- unbreached_moves %>% select(week_start, expected_high, expected_low)
  unexpected_move_rectangles <- breached_moves %>% select(week_start, expected_high, expected_low)
  
  ggplot() +
    theme_minimal() +
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
    ) +
    geom_candlestick(data = unbreached_moves,
                     aes(x = week_start, open = open,
                         high = high, low = low,
                         close = close, color_up = 'black',
                         color_down = 'black', fill_up = green,
                         fill_down = red, inherit.aes = FALSE)) +
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
    ) +
    geom_candlestick(
      data = breached_moves,
      aes(x = week_start, open = open,
          high = high, low = low,
          close = close, color_up = 'black',
          color_down = 'black', fill_up = green,
          fill_down = red, inherit.aes = FALSE
      )
    )
}