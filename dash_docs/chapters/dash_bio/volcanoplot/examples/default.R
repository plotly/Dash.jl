
library(dash)
library(dashBio)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

df <- read.csv(
  file ='https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv',
  stringsAsFactors = FALSE
)

app$layout(
  htmlDiv(
    list(
      'Effect sizes',
      dccRangeSlider(
        id = 'volcanoplot-input',
        min = -3,
        max = 3,
        step = 0.05,
        marks = setNames(
          lapply(-3:3,
                 function(i){
                   list(label = as.character(i))
                 }),
          -3:3
        ),
        value = c(-0.5, 1)
      ),
      htmlBr(),
      htmlDiv(
        dccGraph(
          id = 'my-dashbio-volcanoplot',
          figure = dashbioVolcano(
            dataframe = df
          )
        )
      )
    )
  )
)

app$callback(
  output = list(id = 'my-dashbio-volcanoplot', property = 'figure'),
  params = list(input(id = 'volcanoplot-input', property = 'value')),
  function(effects) {

    dashbioVolcano(
      dataframe = df,
      genomewideline_value = 2.5,
      effect_size_line = unlist(effects)
    )
  }
)

app$run_server()
