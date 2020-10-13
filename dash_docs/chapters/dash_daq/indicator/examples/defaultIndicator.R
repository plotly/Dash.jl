library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqIndicator(id = 'my-indicator',
               label = 'Default'),
  
  htmlButton('On/Off',
             id = 'my-indicator-button',
             n_clicks = 0)
)))
  
app$callback(
  output(id = "my-indicator", property = "value"),
  params = list(input(id = "my-indicator-button", property = "n_clicks")),
  
  update_output <- function(value) {
    if (value %% 2 == 0) {
      value = TRUE
    } else {
      value = FALSE
    }
    return(value)
  }
)

app$run_server()
