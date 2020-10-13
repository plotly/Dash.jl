library(dashBio)
library(readr)

app <- Dash$new()


data = read_file("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta")

app$layout(htmlDiv(list(
  dashbioAlignmentChart(
    id = "my-alignment-viewer",
    data = data
    ),

    htmlDiv(id = "alignment-viewer-output")
)))

app$callback(
  output(id = "alignment-viewer-output", property = "children"),
  params = list(
    input(id = "my-alignment-viewer", property = "eventDatum")
  ),

  update_output <- function(value) {
    if (!exists("value")) {
      return("No data.")
    }
    else {
      return(str(value))
    }
  }
)

app$run_server()
