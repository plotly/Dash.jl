library(dash)
library(dashHtmlComponents)
library(dashTable)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

df <- cbind(' index' = 1:dim(df)[1], df)

app <- Dash$new()

page_size <- 5

app$layout(
  dashDataTable(
    id = 'table-paging-and-sorting',
    columns = lapply(sort(colnames(df)), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName,
                         deletable = TRUE
                       )
                     }),
    page_current = 0,
    page_size = page_size,
    page_action = 'custom',
    sort_action = 'custom',
    sort_mode = 'single',
    sort_by = list()
  )
)

app$callback(
  output = list(id = 'table-paging-and-sorting', property = 'data'),
  params = list(input(id = 'table-paging-and-sorting', property = 'page_current'),
                input(id = 'table-paging-and-sorting', property = 'page_size'),
                input(id = 'table-paging-and-sorting', property = 'sort_by')),
  function(page_current, page_size, sort_by) {
    
    subdf <- if(length(sort_by) != 0) {
      
      column_id <- sort_by[[1]][['column_id']]
      decreasing <- sort_by[[1]][['direction']] == "desc"
      # sort by column
      df[order(df[, column_id], decreasing = decreasing), ]
    } else df
    
    start_id <- (page_current * page_size + 1)
    end_id <- ((page_current + 1) * page_size)
    subdf[start_id:end_id, ]
  }
)

app$run_server()
