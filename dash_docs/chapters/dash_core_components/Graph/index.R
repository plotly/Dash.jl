library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
examples <- list(
  graph = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Graph/examples/graphexample.R'),
  graphproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Graph/examples/graphproptable.R')
)

layout <- htmlDiv(list(
htmlH1('Graph Reference'),
dccMarkdown("
Custimize the [Plotly.js config options](https://plotly.com/javascript/configuration-options/) of your graph using
the `config` property. The example below uses the `showSendToCloud` and `plotlyServerURL` options include a
save button in the modebar of the graph which exports the figure to URL specified by `plotlyServerURL`.
"),

examples$graph$source,
examples$graph$layout,

examples$graphproptable$layout,

dccMarkdown("
[Back to the Table of Contents](/)
            ")



))
