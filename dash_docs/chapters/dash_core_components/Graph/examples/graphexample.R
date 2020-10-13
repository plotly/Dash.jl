app <- Dash$new()


app$layout(htmlDiv(list(
  dccDropdown(
    id='my-dropdown1',
    options=list(
      list('label'= 'New York City', 'value'= 'NYC'),
      list('label'= 'Montreal', 'value'= 'MTL'),
      list('label'= 'San Francisco', 'value'= 'SF')
    ),
    value='NYC'
  ),
  dccGraph(
    id='graph1',
    config=list(
      'showSendToCloud'= TRUE,
      'plotlyServerURL'= 'https=//plotly.com'
    )
  )
)))


app$callback(
  output = list(id='graph1', property='figure'),
  params = list(input(id='my-dropdown1', property='value')),
  function(value) {
    y_list = list(
      'NYC'= list(4,2,3),
      'MTL'= list(1, 2, 4),
      'SF'= list(5, 3, 6)
    )
    return(list(
      'data' = list(
        list(
          'type'= 'scatter',
          'y'= c(unlist(y_list[value]))
        )),
      'layout'= list(
        'title'= value
      )
    ))

  }
)

app$run_server()
