library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/Emissions%20Data.csv',
  stringsAsFactors = TRUE
)

df <- cbind(index = 1:dim(df)[1], df)

app$layout(
  dashDataTable(
    id = 'table-virtualization',
    data = df_to_list(df),
    columns = lapply(colnames(df),
                     function(column) {
                       list(name = column,
                            id = column)
                     }),
    editable = TRUE,
    fixed_rows = list(headers = TRUE, data = 0),
    style_cell = list(whiteSpace = 'normal'),
    style_data_conditional = list(
      list(
        'if' = list(column_id = 'index'),
        width = '50px'
      ),
      list(
        'if' = list(column_id = 'Year'),
        width = '50px'
      ),
      list(
        'if' = list(column_id = 'Country'),
        width = '100px'
      ),
      list(
        'if' = list(column_id = 'Continent'),
        width = '70px'
      ),
      list(
        'if' = list(column_id = 'Emission'),
        width = '75px'
      )
    ),
    virtualization = TRUE,
    page_action = 'none'
  )
)

app$run_server()
