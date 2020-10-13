library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultIndicator = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/indicator/examples/defaultIndicator.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Indicator Examples and Reference')
  )
)

# Individual Components and Examples

defaultIndicator <- htmlDiv(list(
  htmlH3("Default Indicator"),
  htmlP("An example of a default Indicator without any extra properties."),
  htmlDiv(
    list(
      examples$defaultIndicator$source_code,
      examples$defaultIndicator$layout
    ),
    className = 'code-container'
  )
))

indicatorLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown("Define the label and label orientation with `label` and `labelPosition`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqIndicator(
    label = "Label",
    labelPosition = "bottom",
    value = TRUE)
  '
  )
))

indicatorBoolOff <-  htmlDiv(list(
  htmlH3("Boolean Indicator Off"),
  dccMarkdown("A boolean indicator set to off `value = FALSE`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqIndicator(
    label = "Off",
    value = FALSE)
  '
  )))

indicatorSquare <-  htmlDiv(list(
  htmlH3("Square"),
  dccMarkdown(
    "Create a square boolean indicator by setting the `width`
              and `height` to the same value."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqIndicator(
    label = "Square",
    width = 16,
    height = 16
)
  '
  )))

indicatorColor <-  htmlDiv(list(
  htmlH3("Color"),
  dccMarkdown(
    "Define the color of the boolean indicator with `color = '#<color>'`"
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqIndicator(
    label = "Purple",
    color = "#551A8B",
    value = TRUE
)
  '
  )))

indicatorProps <- props_to_list("daqIndicator")

indicatorPropsDF <- rbindlist(indicatorProps, fill = TRUE)

indicatorTable <- generate_table(indicatorPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultIndicator,
  htmlHr(),
  indicatorLabel,
  htmlHr(),
  indicatorBoolOff,
  htmlHr(),
  indicatorSquare,
  htmlHr(),
  indicatorColor,
  htmlHr(),
  htmlHr(),
  htmlH3("Indicator Properties"),
  indicatorTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
