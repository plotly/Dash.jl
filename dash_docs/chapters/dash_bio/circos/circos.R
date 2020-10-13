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
  defaultCircos=utils$LoadExampleCode('dash_docs/chapters/dash_bio/circos/examples/defaultCircos.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Circos Examples and Reference'),

  dccMarkdown('
  See Circos in action [here](https://dash-gallery.plotly.host/dash-circos/).
  ')
))

# Individual Components and Examples

defaultCircos <- htmlDiv(list(
  dccMarkdown('## Default Circos Chart'),
  htmlP('An example of a default alignment chart component without any extra properties.'),
  htmlDiv(list(
    examples$defaultCircos$source_code,
    examples$defaultCircos$layout))
))

inner_outer_radii <- htmlDiv(list(
  dccMarkdown('## Inner and Outer Radii'),
  htmlP('Change the inner and outer radii of your Circos graph.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)
library(readr)
library(jsonlite)

data <- "https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/circos_graph_data.json"

circos_graph_data = read_json(data)

dashbioCircos(
  id = "circos_radii_example",
  layout = circos_graph_data[["GRCh37"]],
  tracks = list(list(
    "type" = "CHORDS",
    "data" = circos_graph_data[["chords"]]
  )),

  config = list(
    "innerRadius" = 40,
    "outerRadius" = 200
  )

)
  '
  )
))

circos_props <- props_to_list("dashbioCircos")
circosPropsDF <- rbindlist(circos_props, fill = TRUE)
circos_props_table <- generate_table(circosPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultCircos,
    inner_outer_radii,
    dccMarkdown('## Circos Properties'),
    circos_props_table,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
