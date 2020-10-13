library(dashBio)
library(readr)

app <- Dash$new()


data = read_file("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta")

app$layout(htmlDiv(list(
  dashbioAlignmentChart(
    data = data,
    showconservation = FALSE,
    showgap = FALSE,
    colorscale = "purine"
  )
)))

app$run_server()
