library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultColorpicker = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/color-picker/examples/defaultColorPicker.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Color Picker Examples and Reference')
  )
)

# Individual Components and Examples

defaultColorPicker <- htmlDiv(list(
  htmlH3("Default Color Picker"),
  htmlP("An example of a default Color Picker without any extra properties."),
  htmlDiv(
    list(
      examples$defaultColorpicker$source,
      examples$defaultColorpicker$layout
    ),
    className = 'code-container'
  )
))

pickerSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown(
    "Set the size (width) of the color picker in pixels using the `size` property."
  ),
  utils$LoadAndDisplayComponent("
library(dashDaq)

daqColorPicker(
  label = 'Small',
  size = 164)
  "
  )))

pickerLabel <-  htmlDiv(list(
  htmlH3("Label"),
  dccMarkdown(
    "Define the label and label position using the `label` and `labelPosition` properties."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqColorPicker(
  label = "Label",
  labelPosition = "bottom"
)
  '
  )))

pickerDisabled <-  htmlDiv(list(
  htmlH3("Disabled"),
  dccMarkdown("To disable the Color Picker set `disabled` to `TRUE`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqColorPicker(
  label = "Color Picker",
  disabled = TRUE
)
  '
  )))

pickerHexColors <-  htmlDiv(list(
  htmlH3("Hex Colors"),
  dccMarkdown(
    "Use hex values with the Color Picker by setting `value = list(hex = '#<hex_color>')`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqColorPicker(
  label = "Color Picker",
  value = list(hex = "#0000FF")
)
  '
  )))

pickerRGBColors <-  htmlDiv(list(
  htmlH3("RGB Colors"),
  dccMarkdown(
    "
Use RGB color values with the Color Picker by setting:

`value = list(rgb = list(r = <r_value>, g = <g_value>, b = <b_value>, a = <a_value>)`
"
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqColorPicker(
  label = "Color Picker",
  value = list(rgb = list(r = 255, g = 0, b = 0, a = 0))
)
  '
  )))

colorPickerProps <- props_to_list("daqColorPicker")

colorPickerPropsDF <- rbindlist(colorPickerProps, fill = TRUE)

colorPickerTable <- generate_table(colorPickerPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultColorPicker,
  htmlHr(),
  pickerSize,
  htmlHr(),
  pickerLabel,
  htmlHr(),
  pickerDisabled,
  htmlHr(),
  pickerHexColors,
  htmlHr(),
  pickerRGBColors,
  htmlHr(),
  htmlHr(),
  htmlH3("Color Picker Properties"),
  colorPickerTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
