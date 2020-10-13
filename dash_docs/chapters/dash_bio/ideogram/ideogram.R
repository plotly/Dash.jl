library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(rjson)
library(readr)
library(heatmaply)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultIdeogram=utils$LoadExampleCode('dash_docs/chapters/dash_bio/ideogram/examples/defaultIdeogram.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Ideogram Examples and Reference'),


  dccMarkdown('
  See Ideogram in action [here](https://dash-gallery.plotly.host/dash-ideogram/).
  ')
))

# Individual Components and Examples

defaultIdeogram <- htmlDiv(list(
  dccMarkdown('## Default Ideogram'),
  htmlP('An example of a default ideogram component without any extra properties.'),
  htmlDiv(list(
    examples$defaultIdeogram$source_code,
    examples$defaultIdeogram$layout))
))

heightWidthIdeogram <- htmlDiv(list(
  dccMarkdown('## Height/Width'),
  htmlP('Change the size of the chromosomes in your ideogram.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

dashbioIdeogram(
    id = "ideogram-size",
    chrHeight = 800,
    chrWidth = 200
)
  '
  )
))

annotationsIdeogram <- htmlDiv(list(
  dccMarkdown('## Annotations'),
  htmlP('Display annotations that are loaded from a JSON file.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

dashbioIdeogram(
    id = "ideogram-annotations",
    chromosomes = list("X", "Y"),
    annotationsPath = "https://eweitz.github.io/ideogram/data/annotations/SRR562646.json"
)
  '
  )
))

rotationIdeogram <- htmlDiv(list(
  dccMarkdown('## Rotatability'),
  htmlP('Enable or disable rotation of the chromosome upon clicking on it.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

dashbioIdeogram(
    id = "ideogram-rotation",
    rotatable = FALSE
)
  '
  )
))

orientationIdeogram <- htmlDiv(list(
  dccMarkdown('## Orientation'),
  htmlP('Display chromosomes horizontally or vertically.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

dashbioIdeogram(
    id = "ideogram-orientation",
    rotatable = "horizontal"
)
  '
  )
))

brushIdeogram <- htmlDiv(list(
  dccMarkdown('## Brush Highlights'),
  htmlP('Highlight a region of the chromosome by adding a brush.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

dashbioIdeogram(
    id = "ideogram-brush",
    orientation = "horizontal",
    chromosomes = list("X"),
    brush = "chrX:1-10000000"
)
  '
  )
))

ideogramprops <- props_to_list("dashbioIdeogram")
ideogramPropsDF <- rbindlist(ideogramprops, fill = TRUE)
ideogramPropsTable <- generate_table(ideogramPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultIdeogram,
    heightWidthIdeogram,
    annotationsIdeogram,
    rotationIdeogram,
    orientationIdeogram,
    brushIdeogram,
    dccMarkdown('## Ideogram Properties'),
    ideogramPropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
