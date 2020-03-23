pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

spy <- read_csv('./daily_prices/SPY.csv') %>% 
  mutate(n = 0)

expected_moves <- get_expected_moves(margin_of_error) %>% 
  mutate(n = row_number()) 

for (spy_record_num in 1:nrow(spy)) {
  Date = spy[spy_record_num, "Date"]$Date
  week <- expected_moves %>% filter(week_start <= Date, week_end >= Date) %>% first()
  spy[spy_record_num, "n"]$n <- week$n
}

spy <- inner_join(spy, expected_moves, by='n')


spy <- spy %>% 
  mutate(weekday = wday(Date, week_start = 1))

filters <- setClass(
  "filters", 
  
  slots = c(
    weekday="numeric",
    direction_breached="character"
  ),
  
  validity = function(object) {
    return(TRUE)
  }
)

setGeneric(name="getWeekday", def=function(filters) {
  standardGeneric("getWeekday")
})

setGeneric(name="getDirectionBreached", def=function(filters) {
  standardGeneric("getDirectionBreached")
})

setMethod(f="getWeekday", signature=c("filters"), definition=function(filters) {
  return(filters@weekday)
})

setMethod(f="getDirectionBreached", signature=c("filters"), definition=function(filters) {
  return(filters@direction_breached)
})

getFilteredStats <- function(filters) {
  print(getWeekday(filters))
  print(getDirectionBreached(filters))
  
  results <- spy %>% 
    filter(weekday == getWeekday(filters))
  
  if (getDirectionBreached(filters) == 'up') {
  
    results <- results %>% 
      filter(Close > expected_high)
  }
  
  if (getDirectionBreached(filters) == 'down') {
    
    results <- results %>% 
      filter(Close < expected_low)
  }
  
  return(expected_moves %>% filter(n %in% results$n) %>% select(c(-n)))
}


unbreached_color <- '#0CBCFF'
breached_color <- '#0CBCFF'

red<-'#FF491D'
green<-'#0BFF01'
orange<-'#f28705'
gray<-'#78727A'

filterChart <- function() {
  
  expectedmoves <- get_expected_moves(margin_of_error) %>% 
    filter(week_start >= startDate, week_start <= endDate)
  
  breached_moves <- expectedmoves %>%
    filter(breached == 1)
  
  unbreached_moves <- expectedmoves %>%
    filter(breached == 0)
  
  expected_move_rectangles <- unbreached_moves %>% select(week_start, expected_high, expected_low)
  unexpected_move_rectangles <- breached_moves %>% select(week_start, expected_high, expected_low)
  
  f_plot <- ggplot() +
    theme_minimal()
  
  if (nrow(unbreached_moves) > 0) {
    f_plot <- f_plot + geom_candlestick(data = unbreached_moves,
                                        aes(x = week_start, open = open,
                                            high = high, low = low,
                                            close = close, color_up = 'black',
                                            color_down = 'black', fill_up = green,
                                            fill_down = red, inherit.aes = FALSE
                                        )
    )
  }
  
  if (nrow(breached_moves) > 0) {
    f_plot <- f_plot + geom_candlestick(
      data = breached_moves,
      aes(x = week_start, open = open,
          high = high, low = low,
          close = close, color_up = 'black',
          color_down = 'black', fill_up = green,
          fill_down = red, inherit.aes = FALSE
      )
    )
  }
  
  if (nrow(expected_move_rectangles) > 0) {
    f_plot <- f_plot +
      geom_rect(
        data = expected_move_rectangles,
        aes(
          xmin = week_start - 3,
          xmax = week_start + 3,
          ymin = expected_low,
          ymax = expected_high),
        inherit.aes=FALSE,
        fill = gray,
        alpha = .3
      )
  }
  
  if (nrow(unexpected_move_rectangles) > 0) {
    print(nrow(unexpected_move_rectangles))
    f_plot <- f_plot +
      geom_rect(
        data = unexpected_move_rectangles,
        aes(
          xmin = week_start - 3,
          xmax = week_start + 3,
          ymin = expected_low,
          ymax = expected_high),
        inherit.aes=FALSE,
        fill = orange,
        alpha = .3,
      )
  }
  
  f_plot
}
