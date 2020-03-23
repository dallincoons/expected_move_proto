pacman::p_load(tidyquant, tidyverse, lubridate)

source('./expected_moves.R')

spy <- read_csv('./daily_prices/SPY.csv') %>% 
  mutate(n = 0)

expected_moves <- get_expected_moves(margin_of_error) %>% 
  mutate(n = row_number()) 

# spy %>% 
#   mutate(week = paste(week(Date), '.', year(Date), sep="")) %>% View()

for (spy_record_num in 1:nrow(spy)) {
  Date = spy[spy_record_num, "Date"]$Date
  week <- expected_moves %>% filter(week_start <= Date, week_end >= Date) %>% first()
  spy[spy_record_num, "n"]$n <- week$n
}

spy <- inner_join(spy, expected_moves, by='n')


spy <- spy %>% 
  mutate(weekday = wday(Date, week_start = 1))

spy %>% 
  filter(weekday == 1 && Close < expected_high) 
  
