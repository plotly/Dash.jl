library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  textarea = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Textarea/examples/textareaproptable.R')
)

layout = htmlDiv(list(
  htmlH3('Textarea Properties'),
  examples$textarea$layout,
  
  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
