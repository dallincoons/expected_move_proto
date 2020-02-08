pacman::p_load(tidyverse, lubridate)

expected_moves <- function() {
  
  expected_moves <- read_csv('./expected_moves.csv') %>% 
    mutate(week_start = mdy(week_start)) %>% 
    mutate(week_end = mdy(week_end)) %>% 
    arrange(desc(week_start))
  
  expected_moves <- expected_moves %>% 
    mutate(breached = case_when(
      (close <= expected_low) | (close >= expected_high) ~ TRUE,
      TRUE ~ FALSE
    ),
    t_breached = case_when(
      (low <= expected_low & close >= expected_low) | 
        (high >= expected_high & high <= expected_high) ~ TRUE,
      TRUE ~ FALSE
    )
    )
  
  return(expected_moves)
}

