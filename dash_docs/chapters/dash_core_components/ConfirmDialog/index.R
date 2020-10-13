library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  confirmdialogue = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/ConfirmDialog/examples/confirm.R'),
  confirmdialogueproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/ConfirmDialog/examples/confirmdialogproptable.R')
)

layout <- htmlDiv(list(
  
  
htmlH1('ConfirmDialog component'),
dccMarkdown("
ConfirmDialog is used to display the browser's native 'confirm' modal,
with an optional message and two buttons ('OK' and 'Cancel').
This ConfirmDialog can be used in conjunction with buttons when the user
is performing an action that should require an extra step of verification."),
  
  examples$confirmdialogue$source,
  examples$confirmdialogue$layout,

  examples$confirmdialogueproptable$layout
  
))
