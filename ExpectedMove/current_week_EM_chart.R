pacman::p_load(tidyverse, tidyquant)

red <- '#FF491D'
green <- '#0BFF01'

showCurrentWeekEMChart <- function() {
  
spy <- read_csv('./daily_prices/SPY.csv')

spy %>%
  filter(Date >= current_week$week_start) %>%
  ggplot() +
    theme_minimal() +
    geom_candlestick(aes(x = Date, open = Open, close = Close, high = High, low = Low, color_up = 'black',
                       color_down = 'black', fill_up = green,
                       fill_down = red)) +
    geom_hline(yintercept = current_week$expected_high) +
    geom_hline(yintercept = current_week$expected_low) +
    geom_hline(yintercept = last_week$close, color = 'red') +
    ylab("Stock price for SPY")
}