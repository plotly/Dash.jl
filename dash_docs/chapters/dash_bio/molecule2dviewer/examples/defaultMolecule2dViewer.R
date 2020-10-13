
library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashBio)
library(jsonlite)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json")


app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dashbioMolecule2dViewer(
        id = 'my-dashbio-molecule2d',
        modelData = model_data
      ),
      htmlHr(),
      htmlDiv(id = 'molecule2d-default-output')
    )
  )
)

app$callback(
  output(id = "molecule2d-default-output", property = "children"),
  params = list(
    input(id = "my-dashbio-molecule2d", property = "selectedAtomIds")
  ),

  update_selected_atoms <- function(ids){
    if (is.null(ids[[1]]) | length(ids) < 1 ) {
      return("No atom has been selected. Select atoms by clicking on them.")
    }
    else {
      return(sprintf("    Selected atom ID: %s", as.character(paste(unlist(ids), collapse=' - '))))
    }
  }
)

app$run_server()
