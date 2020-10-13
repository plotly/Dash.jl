library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  checklistproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Checklist/examples/checklistproptable.R')
)

layout = htmlDiv(list(
  htmlH3('Checklist Properties'),
  examples$checklistproptable$layout,
  
  dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
