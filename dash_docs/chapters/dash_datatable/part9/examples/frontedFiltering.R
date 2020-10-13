library(dash)
library(dashHtmlComponents)
library(dashTable)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'datatable-filtering-fe',
        columns = lapply(colnames(df), 
                         function(colName){
                           list(
                             id = colName,
                             name = colName,
                             deletable = TRUE
                           )
                         }),
        data = df_to_list(df),
        filter_action="native"
      ),
      htmlDiv(id = 'datatable-filter-container')
    )
  )
)

app$callback(
  output = list(id = 'datatable-filter-container', property = 'children'),
  params = list(input(id = 'datatable-filtering-fe', property = 'data')),
  function(rows) {
    dff <- if(is.null(unlist(rows))) df else as.data.frame(do.call(rbind, rows))
    
    htmlDiv()
  }
)

app$run_server()
