library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(plotly)
library(jsonlite)

app <- Dash$new()

df = read.csv("datasets/gapminderDataFiveYear.csv")

available_countries = unique(df$country)

app$layout(htmlDiv(list(
  dccGraph(
    id='clientside-graph'
  ),
  dccStore(
    id='clientside-figure-store',
    data = list(
      list(
        'x' = df[df$country == 'Canada', "year"],
        'y' = df[df$country == 'Canada', "pop"]
      )
    )
  ),
  'Indicator',
  dccDropdown(
    id='clientside-graph-indicator',
    options = list(
      list('label' = 'Population', 'value' = 'pop'),
      list('label' = 'Life Expectancy', 'value' = 'lifeExp'),
      list('label' = 'GDP per Capita', 'value' = 'gdpPercap')
    ),
    value='pop'
  ),
  'Country',
  dccDropdown(
    id='clientside-graph-country',
    options=lapply(available_countries, function(x) {
      return(list('label' = x, 'value' = x))
    }),
    value = 'Canada'
  ),
  'Graph Scale',
  dccRadioItems(
    id='clientside-graph-scale',
    options=list(
      list('label' = 'Linear', 'value' = 'linear'),
      list('label' = 'Log', 'value' = 'log')
    ),
    value = 'linear'
  ),
  htmlHr(),
  htmlDetails(
    list(
      htmlSummary('Contents of figure storage'),
      dccMarkdown(
        id='clientside-figure-json'
        )
    )
  )
)))

app$callback(
  output('clientside-figure-store', 'data'),
  params = list(
    input('clientside-graph-indicator', 'value'),
    input('clientside-graph-country', 'value')
  ),
  function(indicator, selected_country) {
    dff = df[df$country == selected_country,]
    return(list(list(
      'x' = dff[, "year"],
      'y' = dff[, indicator],
      'mode' = 'markers'
    )))
  }
)

# Clientside callback that interacts with dccStore
app$callback(
  output('clientside-graph', 'figure'),
  params = list(
    input('clientside-figure-store', 'data'),
    input('clientside-graph-scale', 'value')
  ),
  clientsideFunction(
    namespace = 'clientside_examples',
    function_name = 'update_graph'
  )
)

app$callback(
  output('clientside-figure-json', 'children'),
  params = list(
    input('clientside-figure-store', 'data')
  ),
  function(input_data) {
    return(jsonlite::prettify(dash:::to_JSON(input_data)))
  }
)

app$run_server()
