
app <- Dash$new()

library(readr)
library(dashBio)

fasta_str = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


app$layout(htmlDiv(list(
  dashbioSequenceViewer(
    id = 'my-default-sequence-viewer',
    sequence = fasta_str
  ),

  htmlDiv(id = 'sequence-viewer-default-output')
)))


app$callback(
  output(id = "sequence-viewer-default-output", property = "children"),
  params = list(
    input(id = 'my-default-sequence-viewer', property = "mouseSelection")
  ),

  update_output <- function(value) {
    if ((length(value) == 0)| is.null(value[[1]])) {
      return("There is no mouse selection.")
    }
    else{
      return(sprintf("The mouse selection is %s", value$selection))
    }
  }
)

app$run_server()
