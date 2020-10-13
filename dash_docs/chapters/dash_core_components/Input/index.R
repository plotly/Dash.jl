library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  keypress = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Input/examples/valuekeypress.R'),
  blur = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Input/examples/blur.R'),
  inputproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Input/examples/inputproptable.R')
)

layout <- htmlDiv(list(
  
  htmlH1('Dash Core Components'),
  htmlHr(),
  
  htmlH3('Update Value on Keypress'),
  
  examples$keypress$source,
  examples$keypress$layout,
  htmlH3('Update Value on Enter/Blur'),
  
  dccMarkdown("
`dccInput` has properties `n_submit`, which updates when the enter button is pressed, and `n_blur`
 , which updates when the component loses focus (e.g. tab is pressed or the user clicks outside of the input field).
              "),
  
  examples$blur$source,
  examples$blur$layout,
  
  htmlH3('Input Properties'),
  examples$inputproptable$layout,
  
  htmlHr(),
  dccMarkdown("
              [Back to the Table of Contents](/)
              ")
))

  
