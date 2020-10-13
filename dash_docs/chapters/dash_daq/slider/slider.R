library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultSlider = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/slider/examples/defaultSlider.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Slider Examples and Reference')
  )
)

# Individual Components and Examples
defaultSlider <- htmlDiv(list(
  htmlH3("Default Slider"),
  htmlP("An example of a default Slider without any extra properties."),
  htmlDiv(
    list(
      examples$defaultSlider$source_code,
      examples$defaultSlider$layout
    ),
    className = 'code-container'
  )
))

sliderMarks <-  htmlDiv(list(
  htmlH3("Marks"),
  dccMarkdown("Set custom marks on the slider using with `marks`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqSlider(
    id = "my-daq-marks",
    min = 0,
    max = 100,
    value = 30,
    marks = list("25" = "mark", "50" = "50")
)
  '
  )))

sliderSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Change the size of the slider using `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqSlider(
    size = 50
    )
  ')
))

sliderHandle <-  htmlDiv(list(
  htmlH3("Handle Label"),
  dccMarkdown("Set the labels for the handle that is dragged with `handleLabel`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqSlider(
    id = "my-daq-slider",
    value = 17,
    handleLabel = "Handle"
)
  '
  )))

sliderStep <-  htmlDiv(list(
  htmlH3("Step"),
  dccMarkdown("Change the value of increments or decrements using `step`."),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqSlider(
    min = 0,
    max = 100,
    value = 50,
    handleLabel = list("showCurrentValue" = TRUE, "label" = "VALUE"),
    step = 10
)
  '
  )))

sliderVertical <-  htmlDiv(list(
  htmlH3("Vertical Orientation"),
  dccMarkdown("Make the slider display vertically by setting vertical = TRUE."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqSlider(
    vertical = TRUE)
  '
  )))

sliderProps <- props_to_list("daqSlider")

sliderPropsDF <- rbindlist(sliderProps, fill = TRUE)

sliderTable <- generate_table(sliderPropsDF)

layout <- htmlDiv(
  list(
    dashdaq_intro,
    htmlHr(),
    defaultSlider,
    htmlHr(),
    sliderMarks,
    htmlHr(),
    sliderSize,
    htmlHr(),
    sliderHandle,
    htmlHr(),
    sliderStep,
    htmlHr(),
    sliderVertical,
    htmlHr(),
    htmlHr(),
    htmlH3("Slider Properties"),
    sliderTable,
    htmlHr(),
    dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)
