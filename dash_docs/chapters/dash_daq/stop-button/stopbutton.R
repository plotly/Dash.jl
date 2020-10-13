library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultStopButton = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/stop-button/examples/defaultStopButton.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Stop Button Examples and Reference')
  )
)

# Individual Components and Examples

defaultStopButton <- htmlDiv(list(
  htmlH3("Default Stop Button"),
  htmlP("An example of a default stop button without any extra properties."),
  htmlDiv(
    list(
      examples$defaultStopButton$source_code,
      examples$defaultStopButton$layout
    ),
    className = 'code-container'
  )
))

stopLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqStopButton(
    label = "Label",
    labelPosition = "top"
)
  '
  )))

stopSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Adjust the size (width in pixels) of the stop button with `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqStopButton(
    size = 120)
  '
  )))

stopText <-  htmlDiv(list(
  htmlH3("Button Text"),
  dccMarkdown("Set the text displayed in the button `buttonText`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqStopButton(
    buttonText = "text")
  '
  )))

stopDisabled <-  htmlDiv(list(
  htmlH3("Disabled"),
  dccMarkdown("Set the button by setting `disabled = TRUE`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqStopButton(
    disabled = TRUE)
  '
  )))


stopProps <- props_to_list("daqStopButton")

stopPropsDF <- rbindlist(stopProps, fill = TRUE)

stopTable <- generate_table(stopPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultStopButton,
  htmlHr(),
  stopLabel,
  htmlHr(),
  stopSize,
  htmlHr(),
  stopText,
  htmlHr(),
  stopDisabled,
  htmlHr(),
  htmlHr(),
  htmlH3("Stop Button Properties"),
  stopTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
