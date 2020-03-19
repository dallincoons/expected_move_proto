pacman::p_load(tidyverse, lubridate)

expected_moves <- function(margin_of_error = .002) {
  
  expected_moves <- read_csv('./expected_moves.csv') %>% 
    mutate(week_start = mdy(week_start)) %>% 
    mutate(week_end = mdy(week_end)) %>% 
    arrange(desc(week_start))
  
  expected_moves <- expected_moves %>% 
    mutate(breached = case_when(
      (close <= expected_low - (expected_low * margin_of_error)) | 
      (close >= expected_high + (expected_high * margin_of_error)) ~ TRUE,
      TRUE ~ FALSE
    ),
    t_breached = case_when(
      (low <= expected_low - (expected_low * margin_of_error) & 
       close >= expected_low - (expected_low * margin_of_error)) | 
        (high >= expected_high + (expected_high * margin_of_error) & 
         close <= expected_high + (expected_high * margin_of_error)) ~ TRUE,
      TRUE ~ FALSE
    )
    )
  
  return(expected_moves)
}
