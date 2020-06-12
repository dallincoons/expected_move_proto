pacman::p_load(tidyverse, lubridate)

get_expected_moves <- function(EMexpansion) {
  
  spy <- read_csv('daily_prices/SPY.csv')
  
  spy <- spy %>% 
    mutate(week = week(Date)) %>% 
    mutate(weekday = wday(Date))
  
  counter <- 1
  spy[1, 'MarketWeek'] <- 1
  for (row in 2:nrow(spy)) {
    if (spy[row, 'weekday'] < spy[row - 1, 'weekday']) {
      counter <- counter + 1
    }
    
    spy[row, 'MarketWeek'] <- counter
  }
  
  em <- read_csv('./expected_moves.csv') %>% mutate(week_start = mdy(week_start)) %>% select(week_start, expected_high, expected_low)
  em2 <- spy %>% 
    group_by(MarketWeek) %>% 
    summarize(open = first(Open), high = max(High), low = min(Low), close = last(Close), week_start = as.character(first(Date)), week_end = as.character(last(Date))) %>% 
    mutate(week_start = ymd(week_start))
  
  expected_moves <- inner_join(em, em2, by = "week_start")
  
  # expected_moves <- read_csv('./expected_moves2.csv') %>% 
  #   arrange(desc(week_start))
  
  expected_moves <- expected_moves %>%
    mutate(breached = case_when(
      (close <= expected_low - (expected_low * EMexpansion)) |
      (close >= expected_high + (expected_high * EMexpansion)) ~ TRUE,
      TRUE ~ FALSE
    ),
    t_breached = case_when(
      (low <= expected_low - (expected_low * EMexpansion) &
       close >= expected_low - (expected_low * EMexpansion)) |
        (high >= expected_high + (expected_high * EMexpansion) &
         close <= expected_high + (expected_high * EMexpansion)) ~ TRUE,
      TRUE ~ FALSE
    )
    )

  return(expected_moves)
}
