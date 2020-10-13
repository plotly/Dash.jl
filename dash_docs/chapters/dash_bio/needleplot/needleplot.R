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
  defaultNeedle=utils$LoadExampleCode('dash_docs/chapters/dash_bio/needleplot/examples/defaultNeedle.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# NeedlePlot Examples and Reference'),
  dccMarkdown('
  See Needleplot in action [here](https://dash-gallery.plotly.host/dash-needle-plot/).
  ')
))

# Individual Components and Examples

defaultNeedle <- htmlDiv(list(
  dccMarkdown('## Default NeedlePlot'),
  htmlP('An example of a default NeedlePlot component without any extra properties.'),
  htmlDiv(list(
    examples$defaultNeedle$source_code,
    examples$defaultNeedle$layout))
))

needleStyle <- htmlDiv(list(
  dccMarkdown('## Needle Style'),
  htmlP('Change the appearance of the needles.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json")

dashbioNeedlePlot(
  mutationData = data,
  needleStyle = list(
    "stemColor" = "#FF8888",
    "stemThickness" = 2,
    "stemConstHeight" = TRUE,
    "headSize" = 10,
    "headColor" = list("#FFDD00", "#000000")
  )
)
  '
  )
))

domainStyle <- htmlDiv(list(
  dccMarkdown('## Domain Style'),
  htmlP('Change the appearance of the domain.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json")

dashbioNeedlePlot(
  mutationData = data,
  domainStyle = list(
    "displayMinorDomains" = TRUE,
    "domainColor" = list("#FFDD00", "#00FFDD", "#0F0F0F", "#D3D3D3")
  )
)
  '
  )
))

needleProps <- props_to_list("dashbioNeedlePlot")
needlePropsDF <- rbindlist(needleProps, fill = TRUE)
needlePropsTable <- generate_table(needlePropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultNeedle,
    needleStyle,
    domainStyle,
    dccMarkdown('## NeedlePlot Properties'),
    needlePropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)


