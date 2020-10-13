library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

all_options = list(
  'America' = list('New York City', 'San Francisco', 'Cincinnati'),
  'Canada' = list('Montr\U{00E9}al', 'Toronto', 'Ottawa')
)

app$layout(
  htmlDiv(
    list(
      dccRadioItems(
        id = 'countries-dropdown',
        options = list(list(label = 'America', value = 'America'),
                       list(label = 'Canada', value = 'Canada')),
        value = 'America'
      ),
      htmlHr(),
      dccRadioItems(id='cities-dropdown'),
      htmlHr(),
      htmlDiv(id='display-selected-values')
    )
  )
)

app$callback(
  output=list(id='cities-dropdown', property='options'),
  params=list(input(id='countries-dropdown', property='value')),
  function(selected_country){

    data_selected <- all_options[[selected_country]]

    lapply(data_selected,
           function(dat) {
             list('label' = dat,
                  'value' = dat)
           })
})

app$callback(
  output=list(id='cities-dropdown', property='value'),
  params=list(input(id='cities-dropdown', property='options')),
  function(option) NULL
)

app$callback(
  output=list(id='display-selected-values', property='children'),
  params=list(input(id='countries-dropdown', property='value'),
              input(id='cities-dropdown', property='value')),
  function(selected_country, selected_city) {
    sprintf("\"%s\ is a city in \"%s\"", selected_city, selected_country)
})

app$run_server()
