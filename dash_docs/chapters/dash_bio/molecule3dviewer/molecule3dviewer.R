library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  default = utils$LoadExampleCode('dash_docs/chapters/dash_bio/molecule3dviewer/examples/default.R'),
  selectionType = utils$LoadExampleCode('dash_docs/chapters/dash_bio/molecule3dviewer/examples/selectionType.R'),
  # selectionTypePseudo = utils$LoadExampleCode('molecule3dviewer/examples/selectionTypePseudo.R'),
  table = utils$LoadExampleCode('dash_docs/chapters/dash_bio/molecule3dviewer/examples/table.R')
)

layout <- htmlDiv(
  list(
    htmlH1("Molecule3dViewer Examples and Reference"),
    dccMarkdown("
See Molecule 3D Viewer in action [here](https://dash-gallery.plotly.host/dash-molecule-3d-viewer/).
    "),

    htmlH2("Default Molecule 3D Viewer"),
    dccMarkdown("
An example of a default molecule 3d viewer component without any extra properties.
    "),
    examples$default$source,
    examples$default$layout,

    htmlH2("Selection Type"),
    dccMarkdown("
Choose what gets highlighted with the same color upon selection.
    "),
    examples$selectionTypePseudo$source,
    examples$selectionType$layout,

    htmlH2("Background Color/Opacity"),
    dccMarkdown("
    Change the background color and opacity of the canvas on which Mol3D is rendered.
    ```r
    dashbioMolecule3dViewer(
        id = 'my-dashbio-molecule3d',
                    styles = styles_data,
                    modelData = model_data,
                    selectionType = 'Chain',
                    backgroundColor='#FF0000',
                    backgroundOpacity=0.2
        )
    ```
    "),

    htmlH2("Molecule3dViewer Properties"),
    examples$table$layout,

    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
