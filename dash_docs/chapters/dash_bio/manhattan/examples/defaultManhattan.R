library(dashBio)
library(data.table)

app <- Dash$new()

data = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/manhattan_data.csv",
                  header = TRUE, sep = ",")

genMark <- function(n){
  l <- list(sprintf('%s', n))
  names(l) <- 'label'
  return(l)
}

genMarks <- function(min, max, by){
  s <- seq(from=min, to=max, by)
  l <- lapply(s, genMark)
  names(l) <- s
  return(l)
}

app$layout(htmlDiv(list(
  'Threshold Value',

  dccSlider(
    id = 'default-manhattanplot-input',
    min = 1,
    max = 10,
    step = 1,
    value = 6,
    marks = genMarks(1,10,1)
  ),

  htmlBr(),

  htmlDiv(
    dccGraph(
      id = 'my-default-manhattanplot',
      figure = dashbioManhattan(
        dataframe = data
      )
    )
  )
)))

app$callback(
  output(id = "my-default-manhattanplot", property = "figure"),
  params = list(
    input(id = 'default-manhattanplot-input', property = 'value')),

    update_manhattanplot <- function(threshold){
      return(
        dashbioManhattan(
          dataframe = data,
          genomewideline_value = threshold
        )
      )
    }
  )

app$run_server()
