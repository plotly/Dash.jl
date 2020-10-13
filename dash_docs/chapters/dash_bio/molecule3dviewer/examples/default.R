
library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashBio)
library(jsonlite)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js")
styles_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js")


app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dashbioMolecule3dViewer(
        id = 'my-dashbio-molecule3d-default',
        styles = styles_data,
        modelData = model_data,
        selectionType = 'Chain',
      ),
      "Selection data",
      htmlHr(),
      htmlDiv(id = 'molecule3d-output')
    )
  )
)

app$callback(
  output = list(id = 'molecule3d-output', property = 'children'),
  params = list(input(id = 'my-dashbio-molecule3d-default', property = 'selectedAtomIds')),

  show_selected_atoms <- function(atom_ids) {
    if (is.null(atom_ids[[1]]) | length(atom_ids) < 1 ) {
      return("No atom has been selected. Click somewhere on the molecular structure to select an atom.")
    }
    else {
      return(sprintf("Element or atom ID: %s", as.character(paste(unlist(atom_ids$name), collapse=' - '))))
    }
  }
)

app$run_server()
