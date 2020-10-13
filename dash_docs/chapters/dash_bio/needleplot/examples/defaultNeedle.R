
library(jsonlite)
library(dashBio)
library(data.table)

app <- Dash$new()

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json")


app$layout(htmlDiv(list(
  'Show or hide range slider',

  dccDropdown(
    id = 'needleplot-rangeslider',
    options = list(
      list('label' = 'Show', 'value' = TRUE),
      list('label' = 'Hide', 'value' = FALSE)
    ),
    clearable = FALSE,
    multi = FALSE,
    value = TRUE
  ),

  dashbioNeedlePlot(
    id = 'default-dashbio-needleplot',
    mutationData = data
  )
)))

app$callback(
  output(id = "default-dashbio-needleplot", property = "rangeSlider"),
  params = list(
    input(id = 'needleplot-rangeslider', property = 'value')),

  update_needleplot <- function(show_rangeslider){
    return(show_rangeslider)
  }
)

app$run_server()
