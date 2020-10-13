library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultToggleSwitch = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/toggle-switch/examples/defaultToggleSwitch.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Toggle Switch Examples and Reference')
  )
)

# Individual Components and Examples

defaultToggleSwitch <- htmlDiv(list(
  htmlH3("Default Toggle Switch"),
  htmlP("An example of a default toggle switch without any extra properties."),
  htmlDiv(
    list(
      examples$defaultToggleSwitch$source_code,
      examples$defaultToggleSwitch$layout
    ),
    className = 'code-container'
  )
))

toggleVertical <-  htmlDiv(list(
  htmlH3("Vertical orientation"),
  dccMarkdown("Make the switch display vertically by setting `vertical = TRUE`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqToggleSwitch(
    vertical = TRUE)
  '
  )))

toggleSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Adjust the size of the toggle switch with `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqToggleSwitch(
    size = 100)
  '
  )))

toggleLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Add a label to the toggle switch and specify its
              position using `label` and `labelPosition`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqToggleSwitch(
    label = "My toggle switch",
    labelPosition = "bottom"
)
  '
  )))

toggleProps <- props_to_list("daqToggleSwitch")

togglePropsDF <- rbindlist(toggleProps, fill = TRUE)

toggleTable <- generate_table(togglePropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultToggleSwitch,
  htmlHr(),
  toggleVertical,
  htmlHr(),
  toggleSize,
  htmlHr(),
  toggleLabel,
  htmlHr(),
  htmlHr(),
  htmlH3("Toggle Switch Properties"),
  toggleTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))

#app$run_server()
