library(dash)
library(dashHtmlComponents)
library(dashTable)
library(dplyr)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

app$layout(
  dashDataTable(
    id = 'table-filtering-be',
    columns = lapply(sort(colnames(df)), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    filter_action = 'custom',
    filter_query = ''
  )
)

app$callback(
  output = list(id = 'table-filtering-be', property = 'data'),
  params = list(input(id = 'table-filtering-be', property = 'filter_query')),
  function(filters) {
    
    subdf <- df
    
    if(filters != "") {
      
      conditions <- strsplit(filters, split = "&&")[[1]]
      
      not_show <- lapply(conditions,
                         function(condition) {
                           
                           splited_condition <- strsplit(condition, split = " ")[[1]]
                           # len should be 3
                           len <- length(splited_condition)
                           
                           condition <- if('contains' %in% splited_condition) {
                             
                             splited_condition[which('contains' == splited_condition)] <- "=="
                             
                             if(!grepl("\"", splited_condition[len]) & !grepl("'", splited_condition[len])) {
                               splited_condition[len] <- paste0("'", splited_condition[len], "'")
                             }
                             
                             paste0(splited_condition, collapse = " ")
                           } else if('=' %in% splited_condition) {
                             gsub('=', '==', condition)
                           } else if ('datestartswith' %in% splited_condition) {
                             gsub('datestartswith', '>=', condition)
                           } else condition
                           
                           subdf <<- subdf %>%
                             dplyr::filter(eval(parse(text = condition)))
                         })
    }
    
    subdf
  }
)

app$run_server()
