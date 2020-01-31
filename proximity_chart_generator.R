pacman::p_load(tidyverse)

expected_moves <- read_csv('./expected_moves.csv') %>% arrange(desc(week_start))

expected_moves <- expected_moves %>% 
  mutate(breached = case_when(
    (close <= expected_low) | (close >= expected_high) ~ TRUE,
    TRUE ~ FALSE
  ),
  t_breached = case_when(
    (low <= expected_low) | (high >= expected_high) ~ TRUE,
    TRUE ~ FALSE
  )
)

current_week <- expected_moves %>% head(1)
expected_move_total_width = current_week$expected_high-current_week$expected_low
exptected_move_deviation = expected_move_total_width / 2

isOutsideExpectedMove <- function() {
  return(current_week$low < current_week$expected_low | current_week$high > current_week$expected_high)
}

getChartLowerBound <- function(current_week) {
  if (current_week$low < current_week$expected_low) {
    return(current_week$low - (current_week$expected_high-current_week$expected_low)*.05)
  }
  
  return(current_week$expected_low - (current_week$expected_high-current_week$expected_low)*.05)
}

getChartUpperBound <- function(current_week) {
  if (current_week$high > current_week$expected_high) {
    return(current_week$high + (current_week$expected_high-current_week$expected_low)*.05)
  }
  
  return(current_week$expected_high + (current_week$expected_high-current_week$expected_low)*.05)
}

getAmountOutsideExpectedMove <- function() {
  if (current_week$close < current_week$expected_low) {
    return(current_week$expected_low - current_week$close)
  }
  
  if (current_week$high > current_week$expected_high) {
    return(current_week$close - current_week$expected_high) 
  }
}

getMessage <- function() {
  if (isOutsideExpectedMove()) {
    getAmountOutsideExpectedMove()
    return(sprintf("Outside the expected move by %s deviations", getAmountOutsideExpectedMove()/expected_move_total_width))
  }
}

ggplot() +
  ggtitle(getMessage()) +
  xlim(0,10) +
  ylim(getChartLowerBound(current_week), getChartUpperBound(current_week)) +
  geom_hline(yintercept=current_week$expected_high, color="black") +
  geom_hline(yintercept=current_week$expected_low, color="black") +
  geom_hline(yintercept=current_week$close, color='red') +
  ylab("") +
  xlab(getMessage()) +
  theme_minimal() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank())

get_recent_streak <- function () {
  previous = current_week$breached
  streak_count = 1
  for (row in 2:nrow(expected_moves)) {
    breached = expected_moves[row, "breached"]
    if (breached == previous) {
      streak_count = streak_count+1
      previous = breached
      next
    }
    break
  }
  
  return(streak_count)
}

get_breached_count <- function (start_date, end_date) {
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- expected_moves %>% split(expected_moves$breached)
  
  return(sapply(split, nrow))
}

get_temporarily_breached_count <- function (start_date, end_date) {
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- expected_moves %>% split(expected_moves$t_breached)
  
  return(sapply(split, nrow))
}
