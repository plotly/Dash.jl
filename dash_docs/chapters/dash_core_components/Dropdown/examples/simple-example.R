library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccDropdown(
    options=list(
      list(label="New York City", value="NYC"),
      list(label="Montréal", value="MTL"),
      list(label="San Francisco", value="SF")
    ),
    value="MTL",
    id="my-dropdown"
  ),
  htmlDiv(id="output-container")
)))

app$callback(output('output-container', 'children'),
            params = list(input('my-dropdown', 'value')),
            function(dropdown_value) {
  sprintf("You have selected \"%s\"", dropdown_value)
})

app$run_server()
