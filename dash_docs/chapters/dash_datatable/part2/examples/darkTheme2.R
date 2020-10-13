library(dash)
library(dashTable)

df <- data.frame(
  Date = c("2015-01-01", "2015-10-24", "2016-05-10", "2017-01-10", "2018-05-10", "2018-08-15"),
  Region = c("Montreal", "Toronto", "New York City", "Miami", "San Francisco", "London"),
  Temperature = c(1, -20, 3.512, 4, 10423, -441.2),
  Humidity = seq(10, 60, by = 10),
  Pressure = c(2, 10924, 3912, -10, 3591.2, 15)
)

app <- Dash$new()

app$layout(
  dashDataTable(
    columns = lapply(colnames(df), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    data = df_to_list(df),
    style_as_list_view = TRUE,
    style_cell = list(
      color = 'white',
      backgroundColor = 'rgb(50, 50, 50)'
    ),
    style_header = list(
      backgroundColor = 'rgb(30, 30, 30)'
    )
  )
)

app$run_server()
