library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

app$layout(
  dashDataTable(
    id = 'computed-table1',
    columns = list(
      list(name = 'Input Data', id = 'input_data'),
      list(name = 'Input Squared', id = 'output_data')
    ),
    data = df_to_list(data.frame('input_data' = 1:10)),
    editable = TRUE
  )
)

app$callback(
  output = list(id = 'computed-table1', property = 'data'),
  params = list(input(id = 'computed-table1', property = 'data_timestamp'),
                state(id = 'computed-table1', property = 'data')),
  function(timestamp, rows) {

    lapply(rows,
           function(row){
             row[['output_data']] <- if(row[['input_data']] == '') NA else as.numeric(row[['input_data']])^2
             row
           })
  }
)

app$run_server()
