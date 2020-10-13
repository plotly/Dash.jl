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

importSpeck <- function(filepath, header = FALSE, skip = 2) {
  textdata <- read.table(
    text = paste0(
      readLines(filepath), collapse="\n"
    ),
    header = header,
    skip = skip,
    col.names = c("symbol", "x", "y", "z"),
    stringsAsFactors = FALSE)
  return(dashTable::df_to_list(textdata))
}

examples <- list(
  defaultSpeck=utils$LoadExampleCode('dash_docs/chapters/dash_bio/speck/examples/defaultSpeck.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Speck Examples and Reference'),
  dccMarkdown('
  See Speck in action [here](https://dash-gallery.plotly.host/dash-speck/).
  ')
))


# Individual Components and Examples

defaultSpeck <- htmlDiv(list(
  dccMarkdown('## Default Speck'),
  htmlP('An example of a default speck component without any extra properties.'),
  htmlDiv(list(
    examples$defaultSpeck$source_code,
    examples$defaultSpeck$layout))
))

speckRender <- htmlDiv(list(
  dccMarkdown('## Molecule Rendering Styles'),
  htmlP('Change the level of atom outlines, ambient occlusion, and more with the "view" parameter.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data <- importSpeck("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz")

dashbioSpeck(
  data = data,
  view = list(
    "resolution" = 400,
    "ao" = 0.1,
    "outline" = 1,
    "atomScale" = 0.25,
    "relativeAtomScale" = 0.33,
    "bonds" = TRUE
  )
)
  '
  )
))

scrollZoom <- htmlDiv(list(
  dccMarkdown('## Scroll to Zoom'),
  htmlP('Allow for the scroll wheel to control zoom for the molecule.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

data <- importSpeck("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz")

dashbioSpeck(
  data = data,
  scrollZoom  = TRUE
)
  '
  )
))

speckProps <- props_to_list("dashbioSpeck")
speckPropsDF <- rbindlist(speckProps, fill = TRUE)
speckPropsTable <- generate_table(speckPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultSpeck,
    speckRender,
    scrollZoom,
    dccMarkdown('## Speck Properties'),
    speckPropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)

