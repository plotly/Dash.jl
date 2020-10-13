library(dash)
library(dashHtmlComponents)
library(dashTable)
library(dplyr)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

page_size <- 5

app$layout(
  dashDataTable(
    id = 'table-filtering',
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
    
    filter_action = 'custom',
    filter_query = ''
  )
)

app$callback(
  output = list(id = 'table-filtering', property = 'data'),
  params = list(input(id = 'table-filtering', property = "page_current"),
                input(id = 'table-filtering', property = "page_size"),
                input(id = 'table-filtering', property = "filter_query")),
  function(page_current, page_size, filters) {
    
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
    
    start_id <- (page_current * page_size + 1)
    end_id <- ((page_current + 1) * page_size)
    subdf[start_id:end_id, ]
  }
)

app$run_server()
