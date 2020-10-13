library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlDiv(
        list(
          dccInput(
            id = 'adding-rows-name',
            placeholder = 'Enter a column name...',
            value = '',
            style = list('padding' = 10)
          ),
          htmlButton('Add Column', 
                     id = 'adding-rows-button', 
                     n_clicks=0)
        ),
        style = list(height = 50)
      ),
      dashDataTable(
        id = 'adding-rows-table',
        columns = lapply(1:4, 
                         function(i){
                           list(
                             name = paste('Column', i),
                             id = paste0('column-', i),
                             deletable = TRUE,
                             editable_name = TRUE
                           )
                         }),
        data = lapply(1:5,
                      function(i) {
                        setNames(
                          as.list(
                            ((1:4) - 1) * 5 + i - 1
                          ),
                          paste0('column-', 1:4)
                        )
                      }),
        editable = TRUE,
        row_deletable = TRUE
      ),
      htmlButton('Add Row', id='editing-rows-button', n_clicks=0),
      dccGraph(id = 'adding-rows-graph')
    )
  )
)

app$callback(
  output = list(id = 'adding-rows-table', property = 'data'),
  params = list(input(id = 'editing-rows-button', property = 'n_clicks'),
                state(id = 'adding-rows-table', property = 'data'),
                state(id = 'adding-rows-table', property = 'columns')),
  function(n_clicks, rows, columns) {
    
    if(n_clicks > 0) {
      column_names <- sapply(columns,
                             function(column){
                               column[['id']]
                             })

      rows <- c(rows, 
                list(
                  setNames(as.list(rep('', length(column_names))), column_names)
                )
      )
    }
    rows
  }
)

app$callback(
  output = list(id = 'adding-rows-table', property = 'columns'),
  params = list(input(id = 'adding-rows-button', property = 'n_clicks'),
                state(id = 'adding-rows-name', property = 'value'),
                state(id = 'adding-rows-table', property = 'columns')),
  function(n_clicks, value, existing_columns) {
    
    if(n_clicks > 0) {
      
      existing_columns <- c(
        existing_columns, 
        list(
          list(
            id = value, 
            name = value, 
            editable_name = TRUE,
            deletable = TRUE
          )
        )
      )
    }
    existing_columns
  }
)

app$callback(
  output = list(id = 'adding-rows-graph', property = 'figure'),
  params = list(input(id = 'adding-rows-table', property = 'data'),
                input(id = 'adding-rows-table', property = 'columns')),
  function(rows, columns) {
    
    list(
      data = list(
        list(
          type = 'heatmap',
          x = sapply(columns, function(column) column[['name']]),
          z = lapply(rows,
                     function(row) {
                       
                       sapply(columns, 
                              function(column) {
                                if(is.null(row)) NA else {
                                  num <- unlist(row[column[['id']]])
                                  if(is.null(num)) num <- NA
                                  num
                                }
                              })
                     })
        )
      )
    )
  }
)

app$run_server()
