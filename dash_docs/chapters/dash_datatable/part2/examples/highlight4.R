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
    style_data_conditional = list(
      list(
        'if' = list(column_id = 'Region', 
                    filter_query = '{Region} eq "Montreal"'),
        backgroundColor = '#3D9970',
        color = 'white'
      ),
      list(
        'if' = list(column_id = 'Humidity', 
                    filter_query = '{Humidity} eq 20'),
        backgroundColor = '#3D9970',
        color = 'white'
      ),
      list(
        'if' = list(column_id = 'Temperature', 
                    filter_query = '{Temperature} > 3.9'),
        backgroundColor = '#3D9970',
        color = 'white'
      )
    )
  )
)

app$run_server()
