library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultGraduatedbar = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/graduated-bar/examples/defaultGraduatedBar.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Graduated Bar Examples and Reference')
  )
)

# Individual Components and Examples

defaultGraduatedBar <- htmlDiv(list(
  htmlH3("Default Graduated Bar"),
  htmlP("An example of a default Graduated bar without any extra properties."),
  htmlDiv(
    list(
      examples$defaultGraduatedbar$source_code,
      examples$defaultGraduatedbar$layout
    ),
    className = 'code-container'
  )
))

graduatedOrientation <-  htmlDiv(list(
  htmlH3("Orientation"),
  dccMarkdown("Change the orientation of the bar to vertical `vertical = TRUE`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqGraduatedBar(
    vertical = TRUE,
    value = 10)
'
  )))

graduatedSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Manually adjust the size of the bar in pixels with `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqGraduatedBar(
    size = 200,
    value = 10)
  '
  )))

graduatedMax <-  htmlDiv(list(
  htmlH3("Max"),
  dccMarkdown("Manually set a maximum value with `max`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqGraduatedBar(
    max = 100,
    value = 50)
  '
  )))

graduatedStep <-  htmlDiv(list(
  htmlH3("Step"),
  dccMarkdown("Manually set the step size of each bar with `step`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqGraduatedBar(
    step = 2,
    max = 100,
    value = 50)
  '
  )))

graduatedShowCurrent <-  htmlDiv(list(
  htmlH3("Show Current Value"),
  dccMarkdown(
    "Display the current value of the graduated bar with `showCurrentValue = TRUE`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGraduatedBar(
    showCurrentValue = TRUE,
    max = 100,
    value = 38
)
  '
  )))

graduatedColorRange <-  htmlDiv(list(
  htmlH3("Color Range"),
  dccMarkdown(
    "Set a color range with:

`color = list('ranges' =
list('<color>' = list(<value>, <value>), '<color>' =
list(<value>, <value>), '<color>' = list(<value>, <value>)))`.

    "
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGraduatedBar(
  color = list(
    "ranges" = list(
      "green" = list(0, 4),
      "yellow" = list(4, 7),
      "red" = list(7, 10)
    )
  ),
  showCurrentValue = TRUE,
  value = 10
)
  '
  )))

graduatedColorGradient <-  htmlDiv(list(
  htmlH3("Color Gradient"),
  dccMarkdown(
    "Set a color range with:

`color = list('gradient' = TRUE, 'ranges' =
list('<color>' = list(<value>, <value>), '<color>' =
list(<value>, <value>), '<color>' = list(<value>, <value>)))`.

    "
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqGraduatedBar(
  color = list(
    "gradient" = TRUE,
    "ranges" = list(
      "green" = list(0, 4),
      "yellow" = list(4, 7),
      "red" = list(7, 10)
    )
  ),
  showCurrentValue = TRUE,
  value = 10
)
  '
  )))

graduatedProps <- props_to_list("daqGraduatedBar")

graduatedPropsDF <- rbindlist(graduatedProps, fill = TRUE)

graduatedTable <- generate_table(graduatedPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultGraduatedBar,
  htmlHr(),
  graduatedOrientation,
  htmlHr(),
  graduatedSize,
  htmlHr(),
  graduatedMax,
  htmlHr(),
  graduatedStep,
  htmlHr(),
  graduatedShowCurrent,
  htmlHr(),
  graduatedColorRange,
  htmlHr(),
  graduatedColorGradient,
  htmlHr(),
  htmlHr(),
  htmlH3("Graduated Bar Properties"),
  graduatedTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))
