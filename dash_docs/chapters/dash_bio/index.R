#Source assets
utils <- new.env()
source('dash_docs/utils.R', local=utils)

# Load Necessary Packages
library('dash')
library('dashCoreComponents')
library('dashHtmlComponents')
library('dashBio')
library('dashTable')
library('dashDaq')
library('readr')
library('heatmaply')
library('data.table')
library('jsonlite')
library('rjson')

# Necessary Functions:

titleLink <- function(componentName) {
  return(htmlH2(
    dccLink(
      componentName,
      href=paste('/dash-bio/', tolower(componentName), sep='')
    )
  ))
}

referenceLink <- function(componentName) {
  return(dccLink(
    'More examples & reference',
    href=paste('/dash-bio/', tolower(componentName), sep='')
  ))
}

# Header and Introduction

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Dash Bio'),


  dccMarkdown('
  Dash is a web application framework that provides pure R and Python abstraction
  around HTML, CSS, and JavaScript.

  Dash Bio is a suite of bioinformatics components that make it simpler to
  analyze and visualize bioinformatics data and interact with them in a Dash
  application.

  The source can be found on GitHub at [plotly/dash-bio](https://github.com/plotly/dash-bio).
  These docs are using Dash Bio version 1.0.0.

  To install, run the following commands below in your R console:
  '),

  dccMarkdown('
```r
>remotes::install_github("plotly/dash-bio")
>library(dashBio)
```
              ')
))


# Individual Components and Examples

alignmentChart <- htmlDiv(list(
  htmlDiv(titleLink('AlignmentChart')),
  htmlP('An alignment chart that intuitively graphs complex, genome-scale, sequence alignments.'),

  htmlDiv(id = 'alignment-container', children = list()),
  daqToggleSwitch(
    id= 'alignment-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('AlignmentChart'))
))


circos <- htmlDiv(list(
  htmlDiv(titleLink('Circos')),
  htmlP('A circular ideogram with arcs representing links between genes.'),
  htmlDiv(id = 'circos-container', children = list()),
  daqToggleSwitch(
    id= 'circos-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Circos'))
))




clustergram <- htmlDiv(list(
  htmlDiv(titleLink('Clustergram')),
  htmlP('A heatmap with dendrograms to display clustering of data such as gene expression data.'),
  htmlDiv(id = 'clustergram-container', children = list()),
  daqToggleSwitch(
    id= 'clustergram-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Clustergram'))
))


ideogram <- htmlDiv(list(
  htmlDiv(titleLink('Ideogram')),
  htmlP('A visual representation and analysis tool for chromosome bands.'),
  htmlDiv(id = 'ideogram-container', children = list()),
  daqToggleSwitch(
    id= 'ideogram-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Ideogram'))
))


manhattanPlot <- htmlDiv(list(
  htmlDiv(titleLink('ManhattanPlot')),
  htmlP('A plot that can be used to display the results of genomic studies sorted out by chromosome.
        Perfect for Genome Wide Association Studies (GWAS)'),
  htmlDiv(id = 'manhattan-container', children = list()),
  daqToggleSwitch(
    id= 'manhattan-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('ManhattanPlot'))
))


molecule2dviewer <- htmlDiv(list(
  htmlDiv(titleLink('Molecule2dViewer')),
  htmlP('A 2D rendering of molecular structures.'),
  htmlDiv(id = 'molecule2d-container', children = list()),
  daqToggleSwitch(
    id= 'molecule2d-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Molecule2dViewer'))
))




molecule3dviewer <- htmlDiv(list(
  htmlDiv(titleLink('Molecule3dViewer')),
  htmlP('A 3D visualization of biomolecular structures.'),
  htmlDiv(id = 'molecule3d-container', children = list()),
  daqToggleSwitch(
    id= 'molecule3d-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Molecule3dViewer'))
))



needleplot <- htmlDiv(list(
  htmlDiv(titleLink('NeedlePlot')),
  htmlP('A combination of a bar chart and a scatter plot, for data that are both categorical and continuous.'),
  htmlDiv(id = 'needle-container', children = list()),
  daqToggleSwitch(
    id= 'needle-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('NeedlePlot'))
))


oncoprint <- htmlDiv(list(
  htmlDiv(titleLink('OncoPrint')),
  htmlP('A chart that can be used to visualize multiple genomic alternations with an interactive heatmap.'),
  htmlDiv(id = 'oncoprint-container', children = list()),
  daqToggleSwitch(
    id= 'oncoprint-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('OncoPrint'))
))


sequenceviewer <- htmlDiv(list(
  htmlDiv(titleLink('SequenceViewer')),
  htmlP('A sequence viewer that can highlight and display strings of amino acids sequences.'),
  htmlDiv(id = 'sequence-container', children = list()),
  daqToggleSwitch(
    id= 'sequence-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('SequenceViewer'))
))



speck <- htmlDiv(list(
  htmlDiv(titleLink('Speck')),
  htmlP('A 3D WebGL molecule viewer.'),
  htmlDiv(id = 'speck-container', children = list()),
  daqToggleSwitch(
    id= 'speck-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('Speck'))
))



volcanoplot <- htmlDiv(list(
  htmlDiv(titleLink('VolcanoPlot')),
  htmlP("A graph that can be used to identify clinically meaningful markers in genomic experiments."),
  htmlDiv(id = 'volcano-container', children = list()),
  daqToggleSwitch(
    id= 'volcano-switch',
    value = FALSE,
    color = "#AB63FA",
    label = list('Image', 'Live')
  ),
  htmlDiv(referenceLink('VolcanoPlot'))
))



# Main docs layout

mainLayout <- htmlDiv(list(
  dashbio_intro,
  htmlHr(),
  alignmentChart,
  htmlHr(),
  circos,
  htmlHr(),
  clustergram,
  htmlHr(),
  ideogram,
  htmlHr(),
  manhattanPlot,
  htmlHr(),
  molecule2dviewer,
  htmlHr(),
  molecule3dviewer,
  htmlHr(),
  needleplot,
  htmlHr(),
  oncoprint,
  htmlHr(),
  sequenceviewer,
  htmlHr(),
  speck,
  htmlHr(),
  volcanoplot
))


layout <- mainLayout


app$callback(
  output(id = 'alignment-container', property = 'children'),
  params = list(
    input(id = 'alignment-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(readr)

data = read_file("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta")

dashbioAlignmentChart(
id = "my-dashbio-alignmentchart",
data = data
)
  '
        )
      )
      )
    } else if(value == FALSE) {
      return(list(
        dccMarkdown('```r
library(dashBio)
library(readr)

data = read_file("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta")

dashbioAlignmentChart(
id = "my-dashbio-alignmentchart",
data = data
)
  ```
  ', className = "code-container"
        ),
        htmlHr(),
        htmlImg(src = "assets/images/bio/alignment.PNG",
                style = list("height" = "100%", "width" = "100%"))))
    }


  }
)

app$callback(
  output(id = 'circos-container', property = 'children'),
  params = list(
    input(id = 'circos-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(readr)
library(jsonlite)

data <- "https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/circos_graph_data.json"

circos_graph_data = read_json(data)

dashbioCircos(
id = "my-dashbio-circos",
layout = circos_graph_data[["GRCh37"]],
tracks = list(list(
  "type" = "CHORDS",
  "data" = circos_graph_data[["chords"]],
  "opacity" = 0.7,
  "color" = list("name" = "color"),
  "config" = list(
      "tooltipContent" = list(
        "source" = "source",
        "sourceID" = "id",
        "target" = "target",
        "targetID" = "id",
        "targetEnd" = "end"
      )
    )
))

)
  '
        )
      )
      )
    }


    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(readr)
library(jsonlite)

data <- "https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/circos_graph_data.json"

circos_graph_data = read_json(data)

dashbioCircos(
id = "my-dashbio-circos",
layout = circos_graph_data[["GRCh37"]],
tracks = list(list(
  "type" = "CHORDS",
  "data" = circos_graph_data[["chords"]],
  "opacity" = 0.7,
  "color" = list("name" = "color"),
  "config" = list(
      "tooltipContent" = list(
        "source" = "source",
        "sourceID" = "id",
        "target" = "target",
        "targetID" = "id",
        "targetEnd" = "end"
      )
    )
))

)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/circos.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }


  }
)

app$callback(
  output(id = 'clustergram-container', property = 'children'),
  params = list(
    input(id = 'clustergram-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(dashCoreComponents)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                  skip = 4, sep ="\t",  row.names = 1, header = TRUE)

dccGraph(figure = heatmaply(df,
        row_labels = list(row.names(data)),
        hide_labels = list("row"),
        column_labels = as.list(colnames(data)),
        color_threshold = list(
            "row" = 150,
            "col" = 700
          )
       )
    )
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(dashCoreComponents)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                  skip = 4, sep ="\t",  row.names = 1, header = TRUE)

dccGraph(figure = heatmaply(df,
        row_labels = list(row.names(data)),
        hide_labels = list("row"),
        column_labels = as.list(colnames(data)),
        color_threshold = list(
            "row" = 150,
            "col" = 700
          )
       )
    )

  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/clustergram.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'ideogram-container', property = 'children'),
  params = list(
    input(id = 'ideogram-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)

dashbioIdeogram(
id = "my-dashbio-ideogram",
chrHeight = 300
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)

dashbioIdeogram(
id = "my-dashbio-ideogram",
chrHeight = 300
)

  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/ideogram.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'manhattan-container', property = 'children'),
  params = list(
    input(id = 'manhattan-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)

data = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/manhattan_data.csv",
                     header = TRUE, sep = ",")

dccGraph(figure = dashbioManhattan(
    dataframe=data
))
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)

data = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/manhattan_data.csv",
                     header = TRUE, sep = ",")

dccGraph(figure = dashbioManhattan(
    dataframe=data
))
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/manhattan.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'molecule2d-container', property = 'children'),
  params = list(
    input(id = 'molecule2d-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(jsonlite)

model_data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json")

dashbioMolecule2dViewer(
id = "my-dashbio-molecule2dviewer",
modelData = model_data
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(jsonlite)

model_data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json")

dashbioMolecule2dViewer(
id = "my-dashbio-molecule2dviewer",
modelData = model_data
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/molecule2d.PNG", style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'molecule3d-container', property = 'children'),
  params = list(
    input(id = 'molecule3d-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(jsonlite)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js")
styles_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js")

dashbioMolecule3dViewer(
    id = "my-dashbio-molecule3dviewer",
    styles = styles_data,
    modelData = model_data,
    selectionType = "Chain"
  )
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(jsonlite)

model_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js")
styles_data <- read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js")

dashbioMolecule3dViewer(
    id = "my-dashbio-molecule3dviewer",
    styles = styles_data,
    modelData = model_data,
    selectionType = "Chain"
  )
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/molecule3d.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'needle-container', property = 'children'),
  params = list(
    input(id = 'needle-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(jsonlite)

mdata = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json")

dashbioNeedlePlot(
id = "my-dashbio-needleplot",
mutationData = mdata
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(jsonlite)

mdata = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json")

dashbioNeedlePlot(
id = "my-dashbio-needleplot",
mutationData = mdata
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/needle.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'oncoprint-container', property = 'children'),
  params = list(
    input(id = 'oncoprint-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(jsonlite)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")

dashbioOncoPrint(
id = "my-dashbio-oncoprint",
data = data
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(jsonlite)

data = read_json("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json")

dashbioOncoPrint(
id = "my-dashbio-oncoprint",
data = data
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/oncoprint.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'sequence-container', property = 'children'),
  params = list(
    input(id = 'sequence-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)

sequence ="MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFY
TPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
id = "my-dashbio-sequenceviewer",
sequence = sequence
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)

sequence ="MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFY
TPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
id = "my-dashbio-sequenceviewer",
sequence = sequence
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/sequence.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'speck-container', property = 'children'),
  params = list(
    input(id = 'speck-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(dash)

importSpeck <- function(filepath,

                        header = FALSE,

                        skip = 2) {

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


data <- importSpeck("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz")

dashbioSpeck(
  id = "my-speck",
  view = list("resolution" = 600),
  data = data
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(dash)

importSpeck <- function(filepath,
                        header = FALSE,
                        skip = 2) {
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


data <- importSpeck("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz")

dashbioSpeck(
  id = "my-speck",
  view = list("resolution" = 600),
  data = data
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/speck.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)

app$callback(
  output(id = 'volcano-container', property = 'children'),
  params = list(
    input(id = 'volcano-switch', property = 'value')
  ),

  change_img <- function(value) {
    if (value == TRUE) {
      return(list(
        utils$LoadAndDisplayComponent(
          '
library(dashBio)
library(dashCoreComponents)

data = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv",
                     header = TRUE, sep = ",")

dccGraph(figure = dashbioVolcano(
    id = "my-dashbio-volcanoplot",
    dataframe = data
  )
)
  '
        )
      )
      )
    }
    else if(value == FALSE) {
      return(
        list(
          dccMarkdown('```r
library(dashBio)
library(dashCoreComponents)

data = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv",
                     header = TRUE, sep = ",")

dccGraph(figure = dashbioVolcano(
    id = "my-dashbio-volcanoplot",
    dataframe = data
  )
)
  ```
  ', className = "code-container"
          ),
          htmlHr(),
          htmlImg(src = "assets/images/bio/volcano.PNG",
                  style = list("height" = "100%", "width" = "100%"))))
    }
  }
)
