pacman::p_load(tidyverse, lubridate)

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

current_week <- expected_moves %>% head(1)
expected_move_total_width = current_week$expected_high-current_week$expected_low
exptected_move_deviation = expected_move_total_width / 2

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

getAmountBreachedExpectedMove <- function() {
  if (current_week$close < current_week$expected_low) {
    return(current_week$expected_low - current_week$close)
  }
  
  if (current_week$high > current_week$expected_high) {
    return(current_week$close - current_week$expected_high) 
  }
}

getClosedOutsideDeviations <- function() {
  if (closedOutsideExpectedMove()) {
    deviations = trunc(getAmountClosedOutsideExpectedMove()/expected_move_total_width*10^2)/10^2
    return(deviations)
  }
  
  return("Closed inside the expected move");
}

getAmountClosedOutsideExpectedMove <- function() {
  if (current_week$close < current_week$expected_low) {
    return(current_week$expected_low - current_week$close)
  }
  
  if (current_week$close > current_week$expected_high) {
    return(current_week$close - current_week$expected_high)
  }
  
  return(0)
}

closedOutsideExpectedMove <- function() {
  return(current_week$close < current_week$expected_low | current_week$close > current_week$expected_high)
}

amountExpectedMoveWasBreached <- function() {
  if (current_week$low < current_week$expected_low) {
    return(current_week$expected_low - current_week$low)
  }
  
  if (current_week$high > current_week$expected_high) {
    return(current_week$high - current_week$expected_high)
  }
  
  return(0)
}

getBreachedStandardDeviation <- function() {
  if (expectedMoveWasBreached()) {
    deviations = trunc(amountExpectedMoveWasBreached()/expected_move_total_width*10^2)/10^2
    return(deviations)
  }
  
  return("Never breached expected move")
}

expectedMoveWasBreached <- function() {
  return(current_week$low < current_week$expected_low | current_week$high > current_week$expected_high)
}

getRecentStreak <- function () {
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

isRecentStreakOfTypeBreach <- function() {
  return(current_week$breached == 1)
}

get_breached_count <- function (start_date, end_date) {
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- result %>% split(expected_moves$breached)
  
  return(sapply(split, nrow))
}

get_temporarily_breached_count <- function (start_date, end_date) {
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- result %>% split(result$t_breached)
  
  return(sapply(split, nrow))
}
