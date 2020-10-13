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
  defaultAlignmentChart=utils$LoadExampleCode('dash_docs/chapters/dash_bio/alignment-chart/examples/defaultAlignmentChart.R'),
  colorScaleAlignmentChart=utils$LoadExampleCode('dash_docs/chapters/dash_bio/alignment-chart/examples/colorscaleAlignmentChart.R'),
  hideBarPlots=utils$LoadExampleCode('dash_docs/chapters/dash_bio/alignment-chart/examples/hideBarPlots.R'),
  tileAlignmentChart=utils$LoadExampleCode('dash_docs/chapters/dash_bio/alignment-chart/examples/tileAlignmentChart.R'),
  consensusAlignmentChart=utils$LoadExampleCode('dash_docs/chapters/dash_bio/alignment-chart/examples/consensusAlignmentChart.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# AlignmentChart Examples and Reference'),

  dccMarkdown('
  See AlignmentChart in action [here](https://dash-gallery.plotly.host/dash-alignment-chart/).
  ')
))

# Individual Components and Examples

defaultAlignment <- htmlDiv(list(
  dccMarkdown('## Default Alignment Chart'),
  htmlP('An example of a default alignment chart component without any extra properties.'),
  htmlDiv(list(
    examples$defaultAlignmentChart$source_code,
    examples$defaultAlignmentChart$layout))
))

colorscaleAlignment <-  htmlDiv(list(
  dccMarkdown('## Color Scales'),
  htmlP('The colors used for the heatmap can be changed by adjusting the colorscale property.'),
  htmlDiv(list(
    examples$colorScaleAlignmentChart$source_code,
    examples$colorScaleAlignmentChart$layout))
))

hideAlignment <-  htmlDiv(list(
  dccMarkdown('## Show/Hide Barplots'),
  htmlP('Enable or disable the secondary bar plots for gaps and conservation.'),
  htmlDiv(list(
    examples$hideBarPlots$source_code,
    examples$hideBarPlots$layout))
))

tileAlignment <-  htmlDiv(list(
  dccMarkdown('## Tile Size'),
  htmlP('Change the height and/or width of the tiles.'),
  htmlDiv(list(
    examples$tileAlignmentChart$source_code,
    examples$tileAlignmentChart$layout))
))

consensusAlignment <-  htmlDiv(list(
  dccMarkdown('## Consensus Sequence'),
  htmlP('Toggle the display of the consensus sequence at the bottom of the heatmap.'),
  htmlDiv(list(
    examples$consensusAlignmentChart$source_code,
    examples$consensusAlignmentChart$layout))
))

alignmentprops <- props_to_list("dashbioAlignmentChart")
alignmentPropsDF <- rbindlist(alignmentprops, fill = TRUE)
alignmentPropsTable <- generate_table(alignmentPropsDF)

# Main docs layout

layout <- htmlDiv(
  list(
    dashbio_intro,
    defaultAlignment,
    colorscaleAlignment,
    hideAlignment,
    tileAlignment,
    consensusAlignment,
    dccMarkdown('## AlignmentChart Properties'),
    alignmentPropsTable,
    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)

