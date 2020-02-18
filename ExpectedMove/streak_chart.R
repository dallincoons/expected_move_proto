pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

unbreached_color <- '#0CBCFF'
breached_color <- '#0CBCFF'

red<-'#FF491D'
green<-'#0BFF01'
orange<-'#f28705'
gray<-'#78727A'

streaksChart <- function(startDate, endDate, margin_of_error = .002) {
  
  expectedmoves <- expected_moves(margin_of_error) %>% 
    filter(week_start >= startDate, week_end <= endDate)

  breached_moves <- expectedmoves %>%
    filter(breached == 1)

  unbreached_moves <- expectedmoves %>%
    filter(breached == 0)

expected_move_rectangles <- unbreached_moves %>% select(week_start, expected_high, expected_low)
unexpected_move_rectangles <- breached_moves %>% select(week_start, expected_high, expected_low)

ggplot() +
  theme_minimal() +
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
  ) +
  geom_candlestick(data = unbreached_moves,
     aes(x = week_start, open = open,
         high = high, low = low,
         close = close, color_up = 'black',
         color_down = 'black', fill_up = green,
         fill_down = red, inherit.aes = FALSE)) +
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
  ) +
  geom_candlestick(
    data = breached_moves,
    aes(x = week_start, open = open,
        high = high, low = low,
        close = close, color_up = 'black',
        color_down = 'black', fill_up = green,
        fill_down = red, inherit.aes = FALSE
    )
  )
}

streaksChart('2019-09-01', '2020-01-01', .002)

# x <- c("2020-01-01","2020-01-02","2020-01-03","2020-01-04","20109-01-05")
# y <- c(2,3,5,8,9)
# 
# xmin <- c(2,5)
# xmax <- c(3,6)
# ymin <- c(4,6)
# ymax <- c(6,8)

# boxes <- data.frame(x = xmin, x2 = xmax, y = ymin, y2 = ymax)

# ggplot(data = data.frame(x,y), 
#        aes(x=x, y=y)) +
#   geom_point() +
#   geom_rect(data = boxes, aes(xmin = x, xmax = x2, ymin = y, ymax = y2), fill = "orange")
  # geom_rect(xmin = 2, xmax = 4, ymin = 4, ymax = 6, fill = "orange")
