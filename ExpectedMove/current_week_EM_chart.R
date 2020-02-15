pacman::p_load(tidyverse, tidyquant)

showCurrentWeekEMChart <- function() {

spy <- read_csv('./daily_prices/SPY.csv')

expected_moves <- expected_moves()

current_week <- expected_moves %>% head(1)

spy %>% 
  filter(Date >= current_week$week_start) %>%
  ggplot() +
    theme_minimal() +
    geom_candlestick(aes(x = Date, open = Open, close = Close, high = High, low = Low, color_up = 'green', 
                       color_down = 'red', fill_up = 'green',
                       fill_down = 'red')) +
    geom_hline(yintercept = current_week$expected_high) +
    geom_hline(yintercept = current_week$expected_low)
}
