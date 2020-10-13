library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultTank = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/tank/examples/defaultTank.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Tank Examples and Reference')
  )
)

# Individual Components and Examples

defaultTank <- htmlDiv(list(
  htmlH3("Default Tank"),
  htmlP("An example of a default Tank without any extra properties."),
  htmlDiv(
    list(
      examples$defaultTank$source_code,
      examples$defaultTank$layout
    ),
    className = 'code-container'
  )
))

tankCurrent <-  htmlDiv(list(
  htmlH3("Current value with units"),
  dccMarkdown(
    "Display the current value, along with optional `units`
              with the units and `showCurrentValue` properties."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqTank(
    value = 6,
    showCurrentValue = TRUE,
    units = "gallons",
    style = list("margin-left" = "50px")
)
  '
  )))

tankSize <-  htmlDiv(list(
  htmlH3("Height and width"),
  dccMarkdown("Control the size of the tank by setting `height` and `width`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqTank(
    height = 75,
    width = 200,
    value = 6,
    style = list("margin-left" = "50px")
)
  '
  )))

tankLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Display a label alongside your tank in
              the specified position with `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqTank(
    value = 3,
    label = "Tank label",
    labelPosition = "bottom"
)
  '
  )))

tankCustomScales <-  htmlDiv(list(
  htmlH3("Custom scales"),
  dccMarkdown(
    "Control the intervals at which labels are displayed,
    as well as the labels themselves with the `scale` property."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqTank(
  value = 3,
  scale = list(
    "interval" = 2,
    "labelInterval" = 2,
    "custom" = list("5" = "Set point")
  ),
  style = list("margin-left" = "50px")
)
  '
  )))

tankLog <-  htmlDiv(list(
  htmlH3("Logarithmic"),
  dccMarkdown(
    "Use a logarithmic scale for the tank with the specified base by setting `logarithmic = TRUE`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqTank(
    min = 0,
    max = 10,
    value = 300,
    logarithmic = TRUE,
    base = 3,
    style = list("margin-left" = "50px")

)
  '
  )))

tankProps <- props_to_list("daqTank")

tankPropsDF <- rbindlist(tankProps, fill = TRUE)

tankTable <- generate_table(tankPropsDF)

layout <- htmlDiv(
  list(
    dashdaq_intro,
    htmlHr(),
    defaultTank,
    htmlHr(),
    tankCurrent,
    htmlHr(),
    tankSize,
    htmlHr(),
    tankLabel,
    htmlHr(),
    tankCustomScales,
    htmlHr(),
    tankLog,
    htmlHr(),
    htmlHr(),
    htmlH3("Tank Properties"),
    tankTable,
    htmlHr(),
    dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)

#app$run_server()
