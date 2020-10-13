library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultKnob = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/knob/examples/defaultKnob.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Knob Examples and Reference')
  )
)

# Individual Components and Examples

defaultKnob <- htmlDiv(list(
  htmlH3("Default Knob"),
  htmlP("An example of a default Knob without any extra properties."),
  htmlDiv(
    list(
      examples$defaultKnob$source_code,
      examples$defaultKnob$layout
    ),
    className = 'code-container'
  )
))

knobSize <-  htmlDiv(list(
  htmlH3("Size"),
  dccMarkdown("Set the size(diameter) of the knob in pixels with `size`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqKnob(
    size = 140,
    value = 3)
  '
  )))

knobMax <-  htmlDiv(list(
  htmlH3("Max"),
  dccMarkdown("Set the maximum value of the knob using `max`."),
  utils$LoadAndDisplayComponent('
library(dashDaq)

daqKnob(
    max = 100,
    value = 3)
  '
  )))

knobRanges <-  htmlDiv(list(
  htmlH3("Color Ranges"),
  dccMarkdown(
    "Control color ranges with:

`color = list('ranges' = list('<color>' = list(<value>, <value>),
'<color>' = list(<value>, <value>), '<color>' = list(<value>, <value>)))`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqKnob(label = "Color Ranges",
        value = 3,
        color = list("ranges" =
                       list(
                         "green" = list(0, 5),
                         "yellow" = list(5, 9),
                         "red" = list(9, 10)
                       )
                     )
        )
    '
  )
))

knobGradient <-  htmlDiv(list(
  htmlH3("Color Gradient"),
  dccMarkdown(
    "Set up a color gradient with:

`color = list('gradient' =  TRUE,
'ranges' = list('<color>' = list(<value>, <value>),
'<color>' = list(<value>, <value>), '<color>' = list(<value>, <value>)))`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqKnob(
  label = "Color Ranges",
  value = 3,
  color = list(
    "gradient" = TRUE,
    "ranges" =
      list(
        "green" = list(0, 5),
        "yellow" = list(5, 9),
        "red" = list(9, 10)
      )
  )
)
  '
  )))

knobScale <-  htmlDiv(list(
  htmlH3("Scale"),
  dccMarkdown(
    "Adjust the scale interval, label interval, and start of the scale with `scale`."
  ),
  utils$LoadAndDisplayComponent(
    '
library(dashDaq)

daqKnob(
    value = 7,
    max = 18,
    scale = list("start" = 0, "labelInterval" = 3, "interval" = 3)
)
  '
  )))


knobProps <- props_to_list("daqKnob")

knobPropsDF <- rbindlist(knobProps, fill = TRUE)

knobTable <- generate_table(knobPropsDF)

layout <- htmlDiv(
  list(
    dashdaq_intro,
    htmlHr(),
    defaultKnob,
    htmlHr(),
    knobSize,
    htmlHr(),
    knobMax,
    htmlHr(),
    knobRanges,
    htmlHr(),
    knobGradient,
    htmlHr(),
    knobScale,
    htmlHr(),
    htmlHr(),
    htmlH3("Knob Properties"),
    knobTable,
    htmlHr(),
    dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)
