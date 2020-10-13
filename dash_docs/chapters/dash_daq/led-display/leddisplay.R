library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultLEDDisplay = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/led-display/examples/defaultLEDDisplay.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# LED Display Examples and Reference')
  )
)

# Individual Components and Examples
defaultLEDDisplay <- htmlDiv(list(
  htmlH3("Default LED Display"),
  htmlP("An example of a default LED display without any extra properties."),
  htmlDiv(
    list(
      examples$defaultLEDDisplay$source_code,
      examples$defaultLEDDisplay$layout
    ),
    className = 'code-container'
  )
))

ledLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqLEDDisplay(
    label = "Label",
    labelPosition = "bottom",
    value = "12:34"
)
'
  )))

ledSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Adjust the size of the LED display with `size`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqLEDDisplay(
    label = "Large",
    value = "9:34",
    size = 64
)
  '
  )))

ledColor <-  htmlDiv(list(
  htmlH3("Color"),
  dccMarkdown("Adjust the color of the LED display with `color = #<hex_color>`"),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqLEDDisplay(
    label = "color",
    value = "1.001",
    color = "#FF5E5E"
)
  '
  )))

ledBgColor <-  htmlDiv(list(
  htmlH3("Background Color"),
  dccMarkdown(
    "Adjust the color of the LED display using `backgroundColor = #<hex_color>`"
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqLEDDisplay(
    label = "color",
    value = "1.001",
    backgroundColor = "#FF5E5E"
)
  '
  )))

ledProps <- props_to_list("daqLEDDisplay")

ledPropsDF <- rbindlist(ledProps, fill = TRUE)

ledTable <- generate_table(ledPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultLEDDisplay,
  htmlHr(),
  ledLabel,
  htmlHr(),
  ledSize,
  htmlHr(),
  ledColor,
  htmlHr(),
  ledBgColor,
  htmlHr(),
  htmlHr(),
  htmlH3("LED Display Properties"),
  ledTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
