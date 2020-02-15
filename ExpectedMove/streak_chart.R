pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

unbreached_color <- '#0CBCFF'
breached_color <- '#FF9017'

streaksChart <- function(startDate, endDate, margin_of_error = .002) {
  
  expected_moves <- expected_moves(margin_of_error)
  
  breached_moves <- expected_moves %>%
    filter(breached == 1)
  
  unbreached_moves <- expected_moves %>% 
    filter(breached == 0)
  
ggplot() +
  theme_minimal() +
  {if(unbreached_moves %>% nrow() > 0)
  geom_candlestick(
    data = unbreached_moves %>% filter(week_start >= startDate, week_end <= endDate), 
    aes(x = week_start, open = open, 
        high = high, low = low, 
        close = close, color_up = unbreached_color, 
        color_down = unbreached_color, fill_up = unbreached_color,
        fill_down = unbreached_color
    )
  )} +
  {if(breached_moves %>% nrow() > 0) geom_candlestick(
    data = breached_moves %>% filter(week_start >= startDate, week_end <= endDate),
    aes(x = week_start, open = open, 
        high = high, low = low, 
        close = close, color_up = breached_color, 
        color_down = breached_color, fill_up = breached_color,
        fill_down = breached_color
    )
  )}
}
