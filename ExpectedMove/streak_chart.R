pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

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
        close = close, color_up = 'green', 
        color_down = 'green', fill_up = 'green',
        fill_down = 'green'
    )
  )} +
  {if(breached_moves %>% nrow() > 0) geom_candlestick(
    data = breached_moves %>% filter(week_start >= startDate, week_end <= endDate),
    aes(x = week_start, open = open, 
        high = high, low = low, 
        close = close, color_up = 'red', 
        color_down = 'red', fill_up = 'red',
        fill_down = 'red'
    )
  )}
}
