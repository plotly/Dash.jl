library(dash)
library(dashHtmlComponents)
library(dashTable)
library(jsonlite)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'editing-prune-data',
        columns = lapply(1:4,
                         function(i){
                           list(
                             name = paste("Column", i),
                             id = paste0('column-', i)
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
      htmlDiv(id='editing-prune-data-output')
    )
  )
)

app$callback(
  output = list(id = 'editing-prune-data-output', property = 'children'),
  params = list(input(id = 'editing-prune-data', property = 'data')),
  function(rows) {
    
    pruned_rows <- rows
    which_is_missing <- which(sapply(seq(length(rows)), function(i) "" %in% rows[[i]]))
    
    if(length(which_is_missing) > 0) {
      pruned_rows[which_is_missing] <- NULL
    }

    rows <- do.call(rbind, rows)
    pruned_rows <- do.call(rbind, pruned_rows)

    htmlDiv(
      list(
        htmlDiv('Raw Data'),
        htmlPre(jsonlite::toJSON(rows, pretty = TRUE)),
        htmlHr(),
        htmlDiv('Pruned Data'),
        htmlPre(jsonlite::toJSON(pruned_rows, pretty = TRUE))
      )
    )
  }
)

app$run_server()
