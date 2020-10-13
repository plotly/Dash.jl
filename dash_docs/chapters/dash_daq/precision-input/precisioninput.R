library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultPrecisionInput = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/precision-input/examples/defaultPrecisionInput.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Precision Input Examples and Reference')
  )
)

# Individual Components and Examples

defaultPrecisionInput <- htmlDiv(list(
  htmlH3("Default Precision Input"),
  htmlP("An example of a default precision input without any extra properties."),
  htmlDiv(
    list(
      examples$defaultPrecisionInput$source_code,
      examples$defaultPrecisionInput$layout
    ),
    className = 'code-container'
  )
))

precisionLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPrecisionInput(
    label = "Label",
    labelPosition = "top",
    precision = 2,
    value = 12

)
  '
  )))

precisionPrecision <-  htmlDiv(list(
  htmlH3("Precision"),
  dccMarkdown(
    "The `precision` property is mandatory for this component.
    The `precision` property indicates the accuracy of the specified number."
  ),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqPrecisionInput(
    precision = 2,
    value = 125)
  '
  )))

precisionLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPrecisionInput(
    label = "Label",
    labelPosition = "top",
    precision = 2,
    value = 12

)
  '
  )))

precisionMaxMin <-  htmlDiv(list(
  htmlH3("Max and Min"),
  dccMarkdown(
    "Set the maximum and minimum value of the numeric input with `max` and `min`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPrecisionInput(
    precision = 2,
    value = 15,
    max = 20,
    min = 10
)
  '
  )))

precisionSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Set the length (in pixels) of the numeric input `size`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPrecisionInput(
    size = 120,
    precision = 4,
    value = 245,
)
  '
  )))

precisionDisabled <-  htmlDiv(list(
  htmlH3("Disabled"),
  dccMarkdown("Disable the precision input by setting `disabled = TRUE`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPrecisionInput(
    disabled = TRUE,
    precision = 4,
    value = 9999,
)
  '
  )))

precisionProps <- props_to_list("daqPrecisionInput")

precisionPropsDF <- rbindlist(precisionProps, fill = TRUE)

precisionTable <- generate_table(precisionPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultPrecisionInput,
  htmlHr(),
  precisionLabel,
  htmlHr(),
  precisionPrecision,
  htmlHr(),
  precisionMaxMin,
  htmlHr(),
  precisionSize,
  htmlHr(),
  precisionDisabled,
  htmlHr(),
  htmlHr(),
  htmlH3("Precision Input Properties"),
  precisionTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))

#app$run_server()
