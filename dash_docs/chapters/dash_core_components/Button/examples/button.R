library(dash)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlDiv(dccInput(id="input-box", type="text")),
      htmlButton("Submit", id="button"),
      htmlDiv(id="output-container-button",
              children="Enter a value and press submit")
    )
  )
)

app$callback(
  output = list(id = "output-container-button", property = 'children'),
  params=list(input(id = "button", property = "n_clicks"),
              input(id = "input-box", property = "value")),
  function(n_clicks, value) {
    object_as_string <- capture.output(dput(n_clicks))
    if (is.list(n_clicks)) {
      sprintf("'n_clicks' is of length %d, with the value '%s'", length(n_clicks), object_as_string)
    } else {
      sprintf("'n_clicks' is of length %d, you have clicked the button %d time(s), and the value is '%s'", length(n_clicks), n_clicks, value)
    }
  }
)

app$run_server()
