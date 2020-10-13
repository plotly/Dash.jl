library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)

app <- Dash$new()

params <- c('Weight', 'Torque', 'Width', 'Height',
            'Efficiency', 'Power', 'Displacement')

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'table-editing-simple',
        columns = c(
          list(
            list(
              id = 'Model',
              name = 'Model'
            )
          ),
          lapply(params,
                 function(colName){
                   list(
                     id = colName,
                     name = colName
                   )
                 })
        ),
        data = lapply(1:4,
                      function(i) {
                        setNames(
                          as.list(
                            c(
                              i, rep(0, length(params))
                            )
                          ),
                          c('Model', params)
                        )
                      }

        ),
        editable = TRUE
      ),
      dccGraph(id = 'table-editing-simple-output')
    )
  )
)

app$callback(
  output = list(id = 'table-editing-simple-output', property = 'figure'),
  params = list(input(id = 'table-editing-simple', property = 'data'),
                input(id = 'table-editing-simple', property = 'columns')),

  function(rows, columns) {

    df <- do.call(rbind, rows)
    list(
      data = list(list(
        type = 'parcoords',
        dimensions = lapply(columns,
                            function(column) {
                              list(
                                range = if(column[["name"]] == "Model") c(1,4) else c(-1,1),
                                label = column[['name']],
                                values = unlist(df[, column[['id']]])
                              )
                            })
      ))
    )
  }
)

app$run_server()
