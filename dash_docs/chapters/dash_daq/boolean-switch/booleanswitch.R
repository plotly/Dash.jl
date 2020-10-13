library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultBooleanswitch = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/boolean-switch/examples/defaultBooleanSwitch.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Boolean Switch Examples and Reference')
  )
)

# Individual Components and Examples
defaultBooleanSwitch <- htmlDiv(list(
  htmlH3("Default Boolean Switch"),
  htmlP(
    "An example of a default boolean switch without any extra properties."
  ),
  htmlDiv(
    list(
      examples$defaultBooleanswitch$source_code,
      examples$defaultBooleanswitch$layout
    ),
    className = 'code-container'
  )
))

booleanColor <-  htmlDiv(list(
  htmlH3("Color"),
  dccMarkdown("Set the color of the boolean switch with `color = #<hex_value>`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)
daqBooleanSwitch(
  on = TRUE,
  color = "#9B51E0")
  '
  )))

booleanLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Set the label and label position using the `label` and `labelPosition` properties."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqBooleanSwitch(
  on = TRUE,
  label = "Label",
  labelPosition = "top"
)
  '
  )))

verticalSwitch <-  htmlDiv(list(
  htmlH3("Vertical Switch"),
  dccMarkdown("Create a vertical oriented switch by setting `vertical = TRUE`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqBooleanSwitch(
  on = TRUE,
  label = "Vertical",
  vertical = TRUE
)
  '
  )))

disabledSwitch <-  htmlDiv(list(
  htmlH3("Disabled Switch"),
  dccMarkdown(
    "To disable the Boolean Switch set the property `disabled` to `TRUE`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqBooleanSwitch(
  disabled = TRUE,
  label = "Disabled",
  labelPosition = "bottom"
)
  '
  )))

booleanSwitchProps <- props_to_list("daqBooleanSwitch")

booleanSwitchPropsDF <- rbindlist(booleanSwitchProps, fill = TRUE)

booleanSwitchTable <- generate_table(booleanSwitchPropsDF)

layout <- htmlDiv(list(
      dashdaq_intro,
      htmlHr(),
      defaultBooleanSwitch,
      htmlHr(),
      booleanColor,
      htmlHr(),
      booleanLabel,
      htmlHr(),
      verticalSwitch,
      htmlHr(),
      disabledSwitch,
      htmlHr(),
      htmlHr(),
      htmlH3("Boolean Switch Properties"),
      booleanSwitchTable,
      htmlHr(),
      dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
      dccMarkdown("[Back to the Table of Contents](/)")
))
