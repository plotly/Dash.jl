library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultThermometer = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/thermometer/examples/defaultThermometer.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Thermometer Examples and Reference')
  )
)

# Individual Components and Examples
defaultThermometer <- htmlDiv(list(
  htmlH3("Default Thermometer"),
  htmlP("An example of a default Thermometer without any extra properties."),
  htmlDiv(
    list(
      examples$defaultThermometer$source_code,
      examples$defaultThermometer$layout
    ),
    className = 'code-container'
  )
))

thermometerCurrent <-  htmlDiv(list(
  htmlH3("Current value with units"),
  dccMarkdown(
    "Display the value of the thermometer along with
    optional units with `showCurrentValue` and `units`.
"
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqThermometer(
    min = 95,
    max = 105,
    value = 100,
    showCurrentValue = TRUE,
    units = "C"
)
  '
  )))

thermometerSize <-  htmlDiv(list(
  htmlH3("Height and width"),
  dccMarkdown("Control the size of the thermometer by setting `height` and `width`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqThermometer(
    id = "my-daq-tsize",
    height = 150,
    width = 5,
    value = 5)
  '
  )))

thermometerLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Display a label alongside the thermometer in
              the specified position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqThermometer(
    id = "my-daq-tlabel",
    value = 5,
    label = "Current temperature",
    labelPosition = "top"
)
  '
  )))

thermometerCustomScales <-  htmlDiv(list(
  htmlH3("Custom scales"),
  dccMarkdown(
    "Control the intervals at which labels are displayed,
    as well as the labels themselves with the `scale` property."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqThermometer(
  id = "my-daq-tscales",
  value = 5,
  scale = list(
    "start" = 2,
    "interval" = 3,
    "labelInterval" = 2,
    "custom" = list("2" = "ideal temperature",
                    "5" = "projected temperature")
  )
)
  '
  )))


thermometerProps <- props_to_list("daqThermometer")

thermometerPropsDF <- rbindlist(thermometerProps, fill = TRUE)

thermometerTable <- generate_table(thermometerPropsDF)

layout <- htmlDiv(
  list(
    dashdaq_intro,
    htmlHr(),
    defaultThermometer,
    htmlHr(),
    thermometerCurrent,
    htmlHr(),
    thermometerSize,
    htmlHr(),
    thermometerLabel,
    htmlHr(),
    thermometerCustomScales,
    htmlHr(),
    htmlHr(),
    htmlH3("Thermometer Properties"),
    thermometerTable,
    htmlHr(),
    dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)

#app$run_server()
