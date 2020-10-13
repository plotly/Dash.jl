app <- Dash$new()

app$layout(htmlDiv(list(
  dccTabs(id="tabs", children=list(
    dccTab(label='Tab one', children=list(
      htmlDiv(list(
        dccGraph(
          id='example-graph',
          figure=list(
            'data'= list(
              list('x'= c(1, 2, 3), 'y'= c(4, 1, 2),
                'type'= 'bar', 'name'= 'SF'),
              list('x'= c(1, 2, 3), 'y'= c(2, 4, 5),
                'type'= 'bar', 'name'= 'Montréal')
              )
          )
        )
        ))
      )),
    dccTab(label='Tab two', children=list(
      dccGraph(
        id='example-graph-1',
        figure=list(
          'data'= list(
            list('x'= c(1, 2, 3), 'y'= c(1, 4, 1),
              'type'= 'bar', 'name'= 'SF'),
            list('x'= c(1, 2, 3), 'y'= c(1, 2, 3),
              'type'= 'bar', 'name'= 'Montréal')
            )
        )
      )
      )),
    dccTab(label='Tab three', children=list(
      dccGraph(
        id='example-graph-2',
        figure=list(
          'data'= list(
            list('x'= list(1, 2, 3), 'y'= list(2, 4, 3),
              'type'= 'bar', 'name'= 'SF'),
            list('x'= list(1, 2, 3), 'y'= list(5, 4, 3),
              'type'= 'bar', 'name'= 'Montréal')
            )
        )
      )
      ))
    ))
  )))

app$run_server()
