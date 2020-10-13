library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultGauge = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/gauge/examples/defaultGauge.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Gauge Examples and Reference')
  )
)

# Individual Components and Examples
defaultGauge <- htmlDiv(list(
  htmlH3("Default Gauge"),
  htmlP("An example of a default Gauge without any extra properties."),
  htmlDiv(
    list(
      examples$defaultGauge$source_code,
      examples$defaultGauge$layout
    ),
    className = 'code-container'
  )
))

minAndMax <-  htmlDiv(list(
  htmlH3("Minimum and Maximum"),
  dccMarkdown(
    "Specify the minimum and maximum values of the gauge, using the `min` and `max` properties. If
the scale is logarithmic the minimum and maximum will represent an exponent."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
    value = 5,
    label = "Default",
    max = 20,
    min = 0
)
'
  )))

currentAndUnits <-  htmlDiv(list(
  htmlH3("Current Value and Units"),
  dccMarkdown(
    "Show the current value of the gauge and the units with `showCurrentValue = TRUE`
and `units = <units>`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
    showCurrentValue = TRUE,
    units = "MPH",
    value = 5,
    label = "Default",
    max = 10,
    min = 0
)
  '
  )))

logGauge <-  htmlDiv(list(
  htmlH3("Logarithmic Gauge"),
  dccMarkdown(
    "To set the scale of the gauge to logarithmic use the property `logarithmic = TRUE`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
    logarithmic = TRUE,
    value = 5,
    label = "Default",
    max = 10,
    min = 0
)
  '
  )))

colorGauge <-  htmlDiv(list(
  htmlH3("Color"),
  dccMarkdown(
    "Set the color of the gauge by using the property `color = <hex_color>`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
    color = "#9B51E0",
    value = 2,
    label = "Default",
    max = 5,
    min = 0
)
  '
  )))

colorGradientGauge <-  htmlDiv(list(
  htmlH3("Color Gradient"),
  dccMarkdown(
    "Apply a color gradient to the gauge with the property:

`color = list('gradient' = TRUE, 'ranges' = list('<color>' = list(<value>, <value>), '<color>' =
list(<value>, <value>), '<color>' = list(<value>, <value>)))`."
    
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
  color = list(
    "gradient" = TRUE,
    "ranges" = list(
      "green" = list(0, 6),
      "yellow" = list(6, 8),
      "red" = list(8, 10)
    )
  ),
  value = 2,
  label = "Default",
  max = 10,
  min = 0
)
  '
  )))

sizeGauge <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Adjust the size of the gauge in pixels `size = 200`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqGauge(
    size = 200,
    value = 2,
    label = "Default")
  '
  )))

scaleGauge <-  htmlDiv(list(
  htmlH3("Scale"),
  dccMarkdown(
    "Modify where the scale starts, the label interval,
and actual interval with the `scale` property."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGauge(
    label = "Scale",
    scale = list("start" = 0, "interval" = 3, "labelInterval" = 2),
    value = 3,
    min=0,
    max=24
)
  '
  )))

gaugeProps <- props_to_list("daqGauge")

gaugePropsDF <- rbindlist(gaugeProps, fill = TRUE)

gaugeTable <- generate_table(gaugePropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultGauge,
  htmlHr(),
  minAndMax,
  htmlHr(),
  currentAndUnits,
  logGauge,
  htmlHr(),
  colorGauge,
  htmlHr(),
  colorGradientGauge,
  htmlHr(),
  sizeGauge,
  htmlHr(),
  scaleGauge,
  htmlHr(),
  htmlHr(),
  htmlH3("Gauge Properties"),
  gaugeTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
