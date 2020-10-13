library(dash)
library(dashHtmlComponents)
library(dashTable)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

page_size <- 5

app$layout(
  dashDataTable(
    id = 'table-multicol-sorting',
    columns = lapply(sort(colnames(df)), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    page_current = 0,
    page_size = page_size,
    page_action = 'custom',
    sort_action = 'custom',
    sort_mode = 'multi',
    sort_by = list()
  )
)

app$callback(
  output = list(id = 'table-multicol-sorting', property = 'data'),
  params = list(input(id = 'table-multicol-sorting', property = 'page_current'),
                input(id = 'table-multicol-sorting', property = 'page_size'),
                input(id = 'table-multicol-sorting', property = 'sort_by')),
  function(page_current, page_size, sort_by) {
   
    subdf <- if(length(sort_by) != 0) {
      
      index <- lapply(sort_by, 
                      function(sort){
                        if(sort[['direction']] == "asc") {
                          df[, sort[['column_id']]]
                        } else {
                          -xtfrm(df[, sort[['column_id']]])
                        }
                      })
      
      
      # sort by multi columns
      df[do.call(order, index), ]
    } else df
    
    start_id <- (page_current * page_size + 1)
    end_id <- ((page_current + 1) * page_size)
    subdf[start_id:end_id, ]
  }
)

app$run_server()
