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
  defaultMolecule2dViewer=utils$LoadExampleCode('dash_docs/chapters/dash_bio/molecule2dviewer/examples/defaultMolecule2dViewer.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Molecule2dViewer Examples and Reference'),
  dccMarkdown('
  See Molecule2dViewer in action [here](https://dash-gallery.plotly.host/dash-molecule-2d-viewer/).
  ')
))

# Individual Components and Examples

defaultMolecule2dViewer <- htmlDiv(list(
  dccMarkdown('## Default Molecule2dViewer'),
  htmlP('An example of a default Molecule2DViewer component without any extra properties.'),
  htmlDiv(list(
    examples$defaultMolecule2dViewer$source_code,
    examples$defaultMolecule2dViewer$layout))
))

selectedAtom <- htmlDiv(list(
  dccMarkdown('## Selected Atom IDs'),
  htmlP('Highlight specific atoms in the molecule.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json")

dashbioMolecule2dViewer(
        modelData = model_data,
        selectedAtomIds = list(seq(1:10))
      )
  '
  )
))

modelData <- htmlDiv(list(
  dccMarkdown('## Model Data'),
  htmlP('Change the bonds and atoms in the molecule.'),
  utils$LoadAndDisplayComponent(
    '
library(dashBio)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json")

for (node in model_data$nodes) {
    node$atom <- "N"
}

for (link in model_data$links) {
    link$distance <- 50.0
    link$strength <- 0.5
}

dashbioMolecule2dViewer(
        modelData = model_data,
        selectedAtomIds = list(seq(1:10))
      )
  '
  )
))

molecule2dviewerProps <- props_to_list("dashbioMolecule2dViewer")
molecule2dviewerPropsDF <- rbindlist(molecule2dviewerProps, fill = TRUE)
molecule2dviewerPropsTable <- generate_table(molecule2dviewerPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultMolecule2dViewer,
    selectedAtom,
    modelData,
    dccMarkdown('## Molecule2dViewer Properties'),
    molecule2dviewerPropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
