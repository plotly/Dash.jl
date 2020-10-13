library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)
library(data.table)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

layout <- htmlDiv(list(
  htmlH1("Cytoscape Reference"),

  htmlH2("Cytoscape Properties"),
  dccMarkdown("
  The full list of Cytoscape properties and their settings can be viewed by entering `help('cytoCytoscape')`
  in the console. Likewise, an equivalent list for Python users can be found
  [here](https://dash.plotly.com/cytoscape/reference).
  "),
  utils$generate_table(rbindlist(utils$props_to_list('cytoCytoscape'), fill = TRUE)),
  # EDIT: Complete this table! Currently incomplete.

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
