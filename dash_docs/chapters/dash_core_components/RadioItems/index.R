library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  radioitemsproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/RadioItems/examples/radioitemsproptable.R')
)

layout = htmlDiv(list(
  htmlH3('Radio Items Properties'),
  examples$radioitemsproptable$layout,
  
  htmlHr(),
  dccMarkdown("
              [Back to the Table of Contents](/)
              ")
))
