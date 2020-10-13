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
    multi = TRUE,
    id="my-dropdown"
  ),
  htmlDiv(id="output-container")
)))

app$run_server()
