library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultPowerButton = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/power-button/examples/defaultPowerButton.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Power Button Examples and Reference')
  )
)

# Individual Components and Examples

defaultPowerButton <- htmlDiv(list(
  htmlH3("Default Power Button"),
  htmlP("An example of a default power button without any extra properties."),
  htmlDiv(
    list(
      examples$defaultPowerButton$source_code,
      examples$defaultPowerButton$layout
    ),
    className = 'code-container'
  )
))

powerLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqPowerButton(
    on = TRUE,
    label = "Label",
    labelPosition = "top"
)
  '
  )))

powerSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown(
    "Adjust the size (diameter in pixels) of the power button with `size`."
  ),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqPowerButton(
    on = TRUE,
    size = 100)
  '
  )))

powerColor <-  htmlDiv(list(
  htmlH3("Color"),
  dccMarkdown("Set the color of the power button with `color`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqPowerButton(
    on = TRUE,
    color = "#FF5E5E")
  '
  )))

powerProps <- props_to_list("daqPowerButton")

powerPropsDF <- rbindlist(powerProps, fill = TRUE)

powerTable <- generate_table(powerPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultPowerButton,
  htmlHr(),
  powerLabel,
  htmlHr(),
  powerSize,
  htmlHr(),
  powerColor,
  htmlHr(),
  htmlHr(),
  htmlH3("Power Button Properties"),
  powerTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))

#app$run_server()
