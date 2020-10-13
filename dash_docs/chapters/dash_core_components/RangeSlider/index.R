library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  rangeslider1 = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/RangeSlider/examples/rangeslider1.R'),
  rangeslidernonlinear = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/RangeSlider/examples/rangeslidernonlinear.R'),
  rangesliderproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/RangeSlider/examples/rangesliderproptable.R')
)


layout = htmlDiv(list(
  htmlH1("RangeSlider Examples and Reference"),
  htmlHr(),
  htmlH3('Simple RangeSlider Example'),
  htmlP("An example of a basic RangeSlider tied to a callback."),
  examples$rangeslider1$source,
  examples$rangeslider1$layout,

  htmlHr(),
  htmlH3('Marks and Steps'),
  dccMarkdown("If slider `marks` are defined and `step` is set to `NULL` \
                 then the slider will only be able to select values that \
              have been predefined by the `marks`."),

  utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
      min=0,
      max=10,
      marks=list(
        "0" = "0 °F",
        "3" = "3 °F",
        "5" = "5 °F",
        "7.65" = "7.65 °F",
        "10" = "10 °F"
      ),
      value=list(3, 7.65)
    )
   '
  ),

  htmlHr(),
  htmlH3('Included and Styling Marks'),

  dccMarkdown("By default, `included=TRUE`, meaning the rail trailing the \
                 handle will be highlighted. To have the handle act as a \
              discrete value set `included=FALSE`. To style `marks`, \
              include a style css attribute alongside the key value."),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
    min=0,
    max=100,
    marks = list(
    "0" = list("label" = "0 °C", "style" = list("color" = "#77b0b1")),
    "26" = list("label" = "26 °C"),
    "37" = list("label" = "37 °C"),
    "100" = list("label" = "100°C" , "style" = list("color" = "#FF4500"))
    )
    )

  '
  ))),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
    min=0,
    max=100,
    marks = list(
    "0" = list("label" = "0 °C", "style" = list("color" = "#77b0b1")),
    "26" = list("label" = "26 °C"),
    "37" = list("label" = "37 °C"),
    "100" = list("label" = "100°C" , "style" = list("color" = "#FF4500"))
    ),

    included=FALSE
    )

  '
  ))),

  htmlHr(),
  htmlH3('Multiple Handles'),
  dccMarkdown("To create multiple handles \
                  just define more values for `value`!"),

  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
    min=0,
    max=30,
    value=list(1, 3, 4, 5, 12, 17)
  )
  '
  ))),

  htmlHr(),
  htmlH3('Pushable Handles'),

  dccMarkdown("The `pushable` property is either a `boolean` or a numerical value. \
                The numerical value determines the minimum distance between \
              the handles. Try moving the handles around!"),
  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
    min=0,
    max=30,
    value=list(1, 3, 4, 5, 12, 17),
    pushable = 2
  )
  '
  ))), #Fix example, not pushing.

  htmlHr(),
  htmlH3('Crossing Handles'),

  dccMarkdown("If `allowCross=FALSE`, the handles will not be allowed to\
                  cross over each other"),
  htmlDiv(list(utils$LoadAndDisplayComponent2(
    '
library(dashCoreComponents)
dccRangeSlider(
    min=0,
    max=30,
    value=list(10,15),
    allowCross = FALSE
    )
  '
  ))),
  htmlHr(),

  htmlH3('Non-Linear Slider and Updatemode'),
  dccMarkdown("Create a logarithmic slider by setting `marks`\
               to be logarithmic and adjusting the slider's output \
               `value` in the callbacks. The `updatemode` property \
               allows us to determine when we want a callback to be \
               triggered. The following example has `updatemode='drag'` \
               which means a callback is triggered everytime the handle \
               is moved. \
               Contrast the callback output with the first example on this \
               page to see the difference."),

  examples$rangeslidernonlinear$source,
  examples$rangeslidernonlinear$layout,

  htmlH3('RangeSlider Properties'),
  examples$rangesliderproptable$layout,

  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
              ")



))
