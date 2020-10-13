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
  defaultSequence=utils$LoadExampleCode('dash_docs/chapters/dash_bio/sequenceviewer/examples/defaultSequence.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Sequence Viewer Examples and Reference'),
  dccMarkdown('
  See Sequence Viewer in action [here](https://dash-gallery.plotly.host/dash-sequence-viewer/).
  ')
))

# Individual Components and Examples

defaultSequenceViewer <- htmlDiv(list(
  dccMarkdown('## Default Sequence Viewer'),
  htmlP('An example of a default SequenceViewer component without any extra properties.'),
  htmlDiv(list(
    examples$defaultSequence$source_code,
    examples$defaultSequence$layout))
))

sequenceLine <- htmlDiv(list(
  dccMarkdown('## Line Length and Line Numbers'),
  htmlP('Change the characters per line, and toggle the display of line numbers.'),
  utils$LoadAndDisplayComponent(
    '

library(dashBio)

fasta_str = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
  id = "sequence-viewer-lines",
  sequence = fasta_str,
  showLineNumbers = FALSE,
  charsPerLine = 20
)
  '
  )
))

subsequence <- htmlDiv(list(
  dccMarkdown('## Subsequence Selection'),
  htmlP('Highlight a part of the sequence with a defined color.'),
  utils$LoadAndDisplayComponent(
    '

library(dashBio)

fasta_str = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
  id = "sequence-viewer-subsequence",
  sequence = fasta_str,
  selection = list(10, 20, "green")
)
  '
  )
))

toolbar <- htmlDiv(list(
  dccMarkdown('## Toolbar'),
  htmlP('Display a toolbar to change the line length from the component itself.'),
  utils$LoadAndDisplayComponent(
    '

library(dashBio)

fasta_str = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
  id = "sequence-viewer-toolbar",
  sequence = fasta_str,
  toolbar = TRUE
)
  '
  )
))

titleandbadge <- htmlDiv(list(
  dccMarkdown('## Title and Badge'),
  htmlP('Show a title or a badge with the nucleotide or amino acid count of the protein.'),
  utils$LoadAndDisplayComponent(
    '

library(dashBio)

fasta_str = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED
LQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"


dashbioSequenceViewer(
  id = "sequence-viewer-title",
  sequence = fasta_str,
  title = "Insulin",
  badge = FALSE
)
  '
  )
))

sequenceProps <- props_to_list("dashbioSequenceViewer")
sequencePropsDF <- rbindlist(sequenceProps, fill = TRUE)
sequencePropsTable <- generate_table(sequencePropsDF)

# Main docs layout

layout <- htmlDiv(list(

  dashbio_intro,
  defaultSequenceViewer,
  sequenceLine,
  subsequence,
  toolbar,
  titleandbadge,
  dccMarkdown('## SequenceViewer Properties'),
  sequencePropsTable,
  htmlHr(),
  dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
