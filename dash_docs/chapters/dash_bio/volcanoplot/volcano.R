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
  default = utils$LoadExampleCode('dash_docs/chapters/dash_bio/volcanoplot/examples/default.R'),
  colors = utils$LoadExampleCode('dash_docs/chapters/dash_bio/volcanoplot/examples/colors.R'),
  # colorsPseudo = utils$LoadExampleCode('volcanoplot/examples/colorsPseudo.R'),
  pointSizesLineWidths = utils$LoadExampleCode('dash_docs/chapters/dash_bio/volcanoplot/examples/pointSizesLineWidths.R'),
  # pointSizesLineWidthsPseudo = utils$LoadExampleCode('volcanoplot/examples/pointSizesLineWidthsPseudo.R'),
  table = utils$LoadExampleCode('dash_docs/chapters/dash_bio/volcanoplot/examples/table.R')
)

layout <- htmlDiv(
  list(
    htmlH1("VolcanoPlot Examples and Reference"),
    dccMarkdown("
See Volcano Plot in action
[here](https://dash-gallery.plotly.host/dash-volcano-plot/).
    "),

    htmlH2("Default Volcano Plot"),
    dccMarkdown("
An example of a default volcano plot component without any extra properties.
    "),
    examples$default$source,
    examples$default$layout,

    htmlH2("Colors"),
    dccMarkdown("
Choose the colors of the scatter plot points, the highlighted points,
the genome-wide line, and the effect size lines.
    "),
    examples$colorsPseudo$source,
    examples$colors$layout,

    htmlH2("Point Sizes And Line Widths"),
    dccMarkdown("
Change the size of the points on the scatter plot
and the widths of the effect lines and genome-wide line.
    "),
    examples$pointSizesLineWidthsPseudo$source,
    examples$pointSizesLineWidths$layout,

    htmlH2("VolcanoPlot Properties"),
    examples$table$layout,

    htmlHr(),
    dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
