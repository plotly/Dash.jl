library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  button = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Button/examples/button.R'),
  buttomtimestamp = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Button/examples/buttontimestamp.R'),
  buttonproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Button/examples/buttonproptable.R')
)

layout <- htmlDiv(list(
  htmlH1('Button Examples and Reference'),
  htmlHr(),
  htmlBr(),
  htmlH3('Button Basic Example'),
  htmlHr(),
  dccMarkdown("An example of a default button without any extra properties \
               and `n_clicks` in the callback. `n_clicks` is an integer that represents \
               that number of times the button has been clicked. Note that the original \
               value is `NULL`."),
  
  examples$button$source,
  examples$button$layout,
  
  htmlBr(),
  htmlH3('Button with n_clicks_timestamp'),
  htmlHr(),
  dccMarkdown("This example utilizes the `n_clicks_timestamp` property, \
    which returns an integer representation of time. This is useful for \
    determining when the button was last clicked."),
  
  examples$buttomtimestamp$source,
  examples$buttomtimestamp$layout,
  
  htmlBr(),
  htmlH3('Button Properties'),
  htmlHr(),
  
  examples$buttonproptable$layout,
  
  dccMarkdown("
[Back to the Table of Contents](/)
")

))
  
