library(jsonlite)
library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashBio)


app <- Dash$new()


data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")


app$layout(htmlDiv(list(
  dashbioOncoPrint(
    data = data,
    id = "my-dashbio-default-oncoprint"
  ),

  htmlDiv(id = 'oncoprint-default-output')
)))

app$callback(
  output(id = "oncoprint-default-output", property = "children"),
  params = list(
    input(id = 'my-dashbio-default-oncoprint', property = "eventDatum")
  ),

  update_output <- function(event_data) {
    if (is.null(event_data)) {
      return("There is no event data. Hover over or click on a part of the graph to generate event data.")
    }

    else {
      return(htmlDiv(
        sprintf("Event Data: %s", event_data)
      ))
    }

  }
)

app$run_server()
