library(dash)
library(dashHtmlComponents)

external_scripts <- list(
  list('https://www.google-analytics.com/analytics.js'),
  list(src = 'https://cdn.polyfill.io/v2/polyfill.min.js'),
  list(src = 'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.10/lodash.core.js')
)

# external CSS stylesheets
external_stylesheets <- list(
  list('https://codepen.io/chriddyp/pen/bWLwgP.css'),
  list(href = 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css')
)

app <- Dash$new(
  external_scripts = external_scripts,
  external_stylesheets = external_stylesheets
)

app$layout(htmlDiv())

app$run_server()
