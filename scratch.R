pacman::p_load(lubridate)

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
  print(spy[row,'MarketWeek'])
}

 

em <- read_csv('./ExpectedMove/expected_moves.csv') %>% mutate(week_start = mdy(week_start)) %>% select(week_start, expected_high, expected_low)
em2 <- spy %>% 
  group_by(MarketWeek) %>% 
  summarize(open = first(Open), high = max(High), low = min(Low), close = last(Close), week_start = as.character(first(Date)), week_end = as.character(last(Date))) %>% 
  mutate(week_start = ymd(week_start))


# em2 <- read_csv('./ExpectedMove/expected_moves2.csv') %>% mutate(week_start = ymd(week_start))

inner_join(em, em2, by = "week_start") %>% 
  write_csv('ExpectedMove/expected_moves2.csv')

