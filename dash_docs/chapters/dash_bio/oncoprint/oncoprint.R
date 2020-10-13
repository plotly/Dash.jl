library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(jsonlite)
library(readr)
library(heatmaply)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultOnco=utils$LoadExampleCode('dash_docs/chapters/dash_bio/oncoprint/examples/defaultOnco.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# OncoPrint Examples and Reference'),
  dccMarkdown('
  See OncoPrint in action [here](https://dash-gallery.plotly.host/dash-onco-print/).
  ')
))

# Individual Components and Examples

defaultOncoPrint <- htmlDiv(list(
  dccMarkdown('## Default OncoPrint'),
  htmlP('An example of a default OncoPrint component without any extra properties.'),
  htmlDiv(list(
    examples$defaultOnco$source_code,
    examples$defaultOnco$layout))
))

oncoColors <- htmlDiv(list(
  dccMarkdown('## Colors'),
  htmlP('Change the color of specific mutations, as well as the background color.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")

dashbioOncoPrint(
  data = data,
  colorscale = list(
    "MISSENSE" = "#e763fa",
    "INFRAME"  = "#E763FA"
  ),

  backgroundcolor = "#F3F6FA"
)
  '
  )
))

oncoSize <- htmlDiv(list(
  dccMarkdown('## Size and Spacing'),
  htmlP('Change the height and width of the component and adjust the spacing between adjacent tracks.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")

dashbioOncoPrint(
  data = data,
  height = 800,
  width = 500,
  padding = 0.25
)
  '
  )
))

oncoLegend <- htmlDiv(list(
  dccMarkdown('## Legend and Overview'),
  htmlP('Show or hide the legend and/or overview heatmap.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")

dashbioOncoPrint(
  data=data,
  showlegend = FALSE,
  showoverview = FALSE
)
  '
  )
))

oncoProps <- props_to_list("dashbioOncoPrint")
oncoPropsDF <- rbindlist(oncoProps, fill = TRUE)
oncoPropsTable <- generate_table(oncoPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultOncoPrint,
    oncoColors,
    oncoSize,
    oncoLegend,
    dccMarkdown('## OncoPrint Properties'),
    oncoPropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)

