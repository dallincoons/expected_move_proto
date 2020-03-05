pacman::p_load(tidyverse, lubridate)

source('./expected_moves.R')

if (!exists("margin_of_error")) {
  margin_of_error <- .002
}

getExpectedMoves <- function() {
  expected_moves <- expected_moves(margin_of_error)
}

expected_moves <- expected_moves(margin_of_error)

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
  if (current_week$low < current_week$expected_low) {
    return(trunc(abs(current_week$open - current_week$low)/(expected_move_total_width/2)*10^2)/10^2)
  }
  
  if (current_week$high > current_week$expected_high) {
    return(trunc(abs(current_week$high - current_week$open)/(expected_move_total_width/2)*10^2)/10^2)
  }
}

getClosedOutsideDeviations <- function() {
  if (closedOutsideExpectedMove()) {
    deviations = trunc(abs(current_week$open - current_week$close)/(expected_move_total_width/2)*10^2)/10^2
    return(deviations)
  }
  
  return(-1);
}

getAmountClosedOutsideExpectedMove <- function() {
  if (current_week$close < current_week$expected_low) {
    return(current_week$expected_low - current_week$close - expected_move_total_width/2)
  }
  
  if (current_week$close > current_week$expected_high) {
    return(current_week$close - current_week$expected_high - expected_move_total_width/2)
  }
  
  return(0)
}

closedOutsideExpectedMove <- function() {
  return(current_week$close < current_week$expected_low | current_week$close > current_week$expected_high)
}

amountExpectedMoveWasBreached <- function() {
  if (current_week$low < current_week$expected_low) {
    return(current_week$expected_low - current_week$low - expected_move_total_width/2)
  }
  
  if (current_week$high > current_week$expected_high) {
    return(current_week$high - current_week$expected_high + expected_move_total_width/2)
  }
  
  return(0)
}

getBreachedStandardDeviation <- function() {
  if (expectedMoveWasBreached()) {
    deviations = trunc(amountExpectedMoveWasBreached()/(expected_move_total_width/2)*10^2)/10^2
    return(deviations)
  }
  
  return("Never breached expected move")
}

expectedMoveWasBreached <- function() {
  return(current_week$low < current_week$expected_low | current_week$high > current_week$expected_high)
}

getRecentStreak <- function () {
  expected_moves <- getExpectedMoves()
  current_week <- expected_moves %>% head(1)
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
  expected_moves <- getExpectedMoves()
  current_week <- expected_moves %>% head(1)
  return(current_week$breached == 1)
}

get_breached_count <- function (start_date, end_date) {
  expected_moves <- getExpectedMoves()
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- result %>% split(expected_moves$breached)
  
  return(sapply(split, nrow))
}

get_temporarily_breached_count <- function (start_date, end_date, margin_of_error = .002) {
  expected_moves <- getExpectedMoves()
  result <- expected_moves %>% 
    filter(week_start >= start_date) %>% 
    filter(week_end <= end_date)
  
  split <- result %>% split(result$t_breached)
  
  return(sapply(split, nrow))
}
