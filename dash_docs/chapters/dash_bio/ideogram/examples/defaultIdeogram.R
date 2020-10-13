library(dashBio)
library(readr)

app <- Dash$new()

chromosomes <- c(as.character(seq(1:22)), "X", "Y")

listOfOptions <- lapply(chromosomes, function(x) {
  list(label = x, value = x)
})


app$layout(htmlDiv(list(
  'Select which chromosomes to display on the ideogram below:',

  dccDropdown(
    id='displayed-chromosomes',
    options = listOfOptions,
    multi=TRUE,
    value = listOfOptions
  ),

  dashbioIdeogram(
    id='default-ideogram'
  ),

  htmlDiv(id='ideogram-rotated')
)))

app$callback(
  output = list(id = 'default-ideogram', property = 'chromosomes'),
  params = list(input(id = 'displayed-chromosomes', property = 'value')),

  update_ideogram <- function(value) {
    return(value)
  }
)



app$callback(
  output(id = "ideogram-rotated", property = "children"),
  params = list(
    input(id = "default-ideogram", property = "rotated")
  ),

  update_ideogram_rotated <- function(rot) {
    if (rot == TRUE) {
      return("You have selected a chromosome.")
    }
    else {
      return("You have not selected a chromosome.")
    }
  }
)

app$run_server()
