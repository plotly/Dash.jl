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
    id = 'datatable-paging',
    columns = lapply(sort(colnames(df)), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    page_current = 0,
    page_size = page_size,
    page_action='custom'
  )
)

app$callback(
  output = list(id = 'datatable-paging', property = 'data'),
  params = list(input(id = 'datatable-paging', property = 'page_current'),
                input(id = 'datatable-paging', property = 'page_size')),
  function(page_current, page_size) {

    start_id <- (page_current * page_size + 1)
    end_id <- ((page_current + 1) * page_size)
    df[start_id:end_id, ]
  }
)

app$run_server()
