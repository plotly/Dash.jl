library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)
library(dplyr)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

page_size <- 20

app$layout(
  htmlDiv(
    list(
      htmlDiv(
        list(
          dashDataTable(
            id = 'table-paging-with-graph',
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
            filter_query = '',
            
            sort_action = 'custom',
            sort_mode = 'multi',
            sort_by = list()
          )
        ),
        style = list(height = 750, overflowY = 'scroll'),
        className = 'six columns'
      ),
      htmlDiv(
        className="five columns",
        id = 'table-paging-with-graph-container'
      )
    ),
    className="row"
  )
)

app$callback(
  output = list(id = 'table-paging-with-graph', property = 'data'),
  params = list(input(id = 'table-paging-with-graph', property = 'page_current'),
                input(id = 'table-paging-with-graph', property = 'page_size'),
                input(id = 'table-paging-with-graph', property = 'sort_by'),
                input(id = 'table-paging-with-graph', property = 'filter_query')),
  function(page_current, page_size, sort_by, filters) {
    subdf <- df
    # filter
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
    
    # sort
    if(length(sort_by) != 0) {
      
      index <- lapply(sort_by, 
                      function(sort){
                        if(sort[['direction']] == "asc") {
                          subdf[, sort[['column_id']]]
                        } else {
                          -xtfrm(subdf[, sort[['column_id']]])
                        }
                      })
      
      # sort by multi columns
      subdf <- subdf[do.call(order, index), ]
    }

    start_id <- (page_current * page_size + 1)
    end_id <- ((page_current + 1) * page_size)
    subdf[start_id:end_id, ]
  }
)

app$callback(output = list(id = 'table-paging-with-graph-container', property = 'children'),
             params = list(input(id = 'table-paging-with-graph', property = 'data')),
             function(rows) {
               
               df <- do.call(rbind, rows)
               
               lapply(c('pop', 'lifeExp', 'gdpPercap'),
                      function(column) {
                       
                        dccGraph(
                          id = column,
                          figure = list(
                            data = list(
                              list(
                                x = unlist(df[, 'country']),
                                y = unlist(df[, column]),
                                type = 'bar',
                                marker = list(color = '#0074D9')
                              )
                            ),
                            layout = list(
                              xaxis = list(automargin = TRUE),
                              yaxis = list(automargin = TRUE),
                              height = 250,
                              margin = list(t = 10, l = 10, r = 10)
                            )
                          )
                        )
                      })
               
             }
)

app$run_server()
