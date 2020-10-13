library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultNumericInput = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/numeric-input/examples/defaultNumericInput.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Numeric Input Examples and Reference')
  )
)

# Individual Components and Examples

defaultNumericInput <- htmlDiv(list(
  htmlH3("Default Numeric Input"),
  htmlP("An example of a default numeric input without any extra properties."),
  htmlDiv(
    list(
      examples$defaultNumericInput$source_code,
      examples$defaultNumericInput$layout
    ),
    className = 'code-container'
  )
))

numericLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqNumericInput(
    label = "Label",
    labelPosition = "bottom",
    value = 10
)
  '
  )))

numericSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Extend the size with `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqNumericInput(
    value = 10,
    size = 120)
  '
  )))

numericMaxMin <-  htmlDiv(list(
  htmlH3("Max and Min"),
  dccMarkdown("Set the minimum and maximum bounds with `min` and `max`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqNumericInput(
    min = 0,
    max = 100,
    value = 20)
  '
  )))

numericDisable <-  htmlDiv(list(
  htmlH3("Disable"),
  dccMarkdown("Disable the numeric input by setting `disabled = TRUE`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqNumericInput(
    disabled = TRUE,
    min = 0,
    max = 10,
    value = 2
)
  '
  )))

numericProps <- props_to_list("daqNumericInput")

numericPropsDF <- rbindlist(numericProps, fill = TRUE)

numericTable <- generate_table(numericPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultNumericInput,
  htmlHr(),
  numericLabel,
  htmlHr(),
  numericSize,
  htmlHr(),
  numericMaxMin,
  htmlHr(),
  numericDisable,
  htmlHr(),
  htmlHr(),
  htmlH3("Numeric Input Properties"),
  numericTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))

#app$run_server()
