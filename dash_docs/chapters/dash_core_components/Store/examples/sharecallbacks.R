library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

#You can download the dataset at 
#https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv
#and put the csv in your assets folder!

df <- read.csv(
  file = "datasets/gapminderDataFiveYear.csv",
  stringsAsFactor=FALSE,
  check.names=FALSE
)

countries = as.list(unique(df$country))

app$layout(htmlDiv(list(
  dccStore(id='memory-output'),
  dccDropdown(id='memory-countries', options=lapply(countries, function(x){list('value' = x, 'label' = x)}), 
              multi=TRUE, 
              value=list('Canada', 'United States')),
  dccDropdown(id='memory-field', options=list(
    list('value'= 'lifeExp', 'label'= 'Life expectancy'),
    list('value'= 'gdpPercap', 'label'= 'GDP per capita')
  ), value='lifeExp'),
  htmlDiv(list(
    dccGraph(id='memory-graph'),
    dashDataTable(
      id='memory-table',
      columns= lapply(colnames(df), function(x){list('name' = x, 'id' = x)})
    )
  ))
)))

app$callback(
  output = list(id="memory-output", property = 'data'),
  params = list(input(id = "memory-countries", property = 'value')),
  function(countries_selected){
    if(length(countries_selected) < 1){
      return(df_to_list(df))
    }
    filtered = df[which(df$country %in% countries_selected), ]
    return(df_to_list(filtered))
  })

app$callback(
  output = list(id="memory-table", property = 'data'),
  params = list(input(id = "memory-output", property = 'data')),
  function(data){
    if(is.null(data) == TRUE){
      return()
    }
    return(data)
  })

app$callback(
  output = list(id="memory-graph", property = 'figure'),
  params = list(input(id = "memory-output", property = 'data'),
                input(id = "memory-field", property = 'value')),
  function(data, field){
    data = data.frame(matrix(unlist(data), nrow=length(data), byrow=T))
    colnames(data)[1:ncol(data)] = c('country', 'year','pop','continent','lifeExp', 'gdpPercap')
    if(is.null(data) == TRUE){
      return()
    }
    aggregation = list()
    data <- split(data, f = data$country)
    for (row in 1:length(data)) {
      aggregation[[row]] <- list(
        x = unlist(data[[row]][[field]]),
        y = unlist(data[[row]]['year']),
        text = data[[row]]['country'],
        mode = 'lines+markers',
        name = as.character(unique(data[[row]]['country'])$country)
      )
    }
    
    return(list(
      'data' = aggregation))
  })

app$run_server()



