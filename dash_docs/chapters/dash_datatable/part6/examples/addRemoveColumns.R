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
            id = 'editing-columns-name',
            placeholder = 'Enter a column name...',
            value = '',
            style = list('padding' = 10)
          ),
          htmlButton('Add Column', 
                     id = 'editing-columns-button', 
                     n_clicks=0)
        ),
        style = list(height = 50)
      ),
      dashDataTable(
        id = 'editing-columns',
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
        editable = TRUE
      ),
      dccGraph(id = 'editing-columns-graph')
    )
  )
)

app$callback(
  output = list(id = 'editing-columns', property = 'columns'),
  params = list(input(id = 'editing-columns-button', property = 'n_clicks'),
                state(id = 'editing-columns-name', property = 'value'),
                state(id = 'editing-columns', property = 'columns')),
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
  output = list(id = 'editing-columns-graph', property = 'figure'),
  params = list(input(id = 'editing-columns', property = 'data'),
                input(id = 'editing-columns', property = 'columns')),
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
                                num <- unlist(row[column[['id']]])
                                if(is.null(num)) num <- NA
                                num
                              })
                     })
        )
      )
    )
  }
)

app$run_server()
