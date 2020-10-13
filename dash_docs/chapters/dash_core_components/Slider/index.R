library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
source('dash_docs/styles.R')
source('dash_docs/components.R')

examples <- list(
  simpleslider = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Slider/examples/slider1.R'),
  proptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Slider/examples/sliderproptable.R'),
  nonlinearex = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Slider/examples/sliderupdatemode.R')
)

layout <- htmlDiv(list(
  htmlH1('Slider Examples and Reference'),

  htmlHr(),
  htmlH3('Simple Slider Example
'),
  dccMarkdown('An example of a basic slider tied to a callback.
              '),
  examples$simpleslider$source,
  examples$simpleslider$layout,

  #--------------------------------

  htmlH3('Marks and Steps'),
  dccMarkdown("If slider `marks` are defined and `step` is set to `NULL` \
                 then the slider will only be able to select values that \
              have been predefined by the `marks`. `marks` is a `list` \
              where the keys represent the numerical values and the \
              values represent their labels."),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccSlider(
    min=0,
    max=10,
    marks = list(
    "0" = "0 °F",
    "3" = "3 °F",
    "5" = "5 °F",
    "7.65" = "7.65 °F",
    "10" = "10 °F"
    ),
    value=5
  )

  '
  ))),

  #--------------------------------

  htmlH3('Marks and Steps'),
  dccMarkdown("By default, `included=TRUE`, meaning the rail trailing the \
                 handle will be highlighted. To have the handle act as a \
              discrete value set `included=FALSE`. To style `marks`, \
              include a style css attribute alongside the list value."),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccSlider(
    min=0,
    max=100,
    value = 65,
    marks = list(
    "0" = list("label" = "0 °C", "style" = list("color" = "#77b0b1")),
    "26" = list("label" = "26 °C"),
    "37" = list("label" = "37 °C"),
    "100" = list("label" = "100 °C", "style" = list("color" = "#FF4500"))
    )
  )

  '
  ))),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccSlider(
    min=0,
    max=100,
    marks = list(
    "0" = list("label" = "0 °C", "style" = list("color" = "#77b0b1")),
    "26" = list("label" = "26 °C"),
    "37" = list("label" = "37 °C"),
    "100" = list("label" = "100 °C", "style" = list("color" = "#FF4500"))
    ),

    included=FALSE
    )

  '
  ))),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
    library(dashCoreComponents)
    dccSlider(
    min=0,
    max=100,
    marks = list(
    "0" = list("label" = "0 °C", "style" = list("color" = "#77b0b1")),
    "26" = list("label" = "26 °C"),
    "37" = list("label" = "37 °C"),
    "100" = list("label" = "100 °C", "style" = list("color" = "#FF4500"))
    ),

    included=FALSE
    )

  '
  ))),
  htmlH3('Non-Linear Slider and Updatemode'),
  examples$nonlinearex$source,
  examples$nonlinearex$layout,

  htmlH3('Slider Properties'),
  examples$proptable$layout,

  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
