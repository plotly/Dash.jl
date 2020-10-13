library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccInput(
        id='num-multi',
        type='number',
        value=1
      ),
      htmlTable(list(
        htmlTr(list(htmlTd(list('x', htmlSup(2))), htmlTd(id='square'))),
        htmlTr(list(htmlTd(list('x', htmlSup(3))), htmlTd(id='cube'))),
        htmlTr(list(htmlTd(list('2', htmlSup('x'))), htmlTd(id='twos'))),
        htmlTr(list(htmlTd(list('3', htmlSup('x'))), htmlTd(id='threes'))),
        htmlTr(list(htmlTd(list('x', htmlSup('x'))), htmlTd(id='xx')))
      ))
    )
  )
)

app$callback(
  output = list(
    output('square', 'children'),
    output('cube', 'children'),
    output('twos', 'children'),
    output('threes', 'children'),
    output('xx', 'children')
  ),
  params = list(
    input('num-multi', 'value')
  ),
  callback_multi <- function(x) {
    return(list(x**2, x**3, 2**x, 3**x, x**x))
  }
)


app$run_server()
