library(dash)
library(dashTable)

df <- data.frame(
  Date = c("2015-01-01", "2015-10-24", "2016-05-10", "2017-01-10", "2018-05-10", "2018-08-15"),
  Region = c("Montreal", "Toronto", "New York City", "Miami", "San Francisco", "London"),
  Temperature = c(1, -20, 3.512, 4, 10423, -441.2),
  Humidity = 10:60,
  pressure = c(2, 10924, 3912, -10, 3591.2, 15)
)

