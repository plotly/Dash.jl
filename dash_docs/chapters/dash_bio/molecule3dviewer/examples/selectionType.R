library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashBio)
library(jsonlite)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js")
styles_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js")


app <- Dash$new()

app$layout(
  dashbioMolecule3dViewer(
    id = 'my-dashbio-molecule3d',
    styles = styles_data,
    modelData = model_data,
    selectionType = 'Chain'
  )
)

app$run_server()
