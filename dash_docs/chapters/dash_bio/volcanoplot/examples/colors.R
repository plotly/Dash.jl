
library(dash)
library(dashBio)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv',
  stringsAsFactors = FALSE
)

app$layout(
    dccGraph(
      id = 'my-dashbio-volcanoplot-color1',
      figure = dashbioVolcano(
        dataframe = df,
        effect_size_line_color = '#AB63FA',
        genomewideline_color = '#EF553B',
        highlight_color = '#119DFF',
        col = '#2A3F5F'
      )
    )
)

app$run_server()
