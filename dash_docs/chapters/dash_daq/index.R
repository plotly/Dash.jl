#Source assets
utils <- new.env()
source('dash_docs/utils.R', local=utils)
styles <- new.env()
source('dash_docs/styles.R', local=styles)

# Load Necessary Packages
library('dash')
library('dashCoreComponents')
library('dashHtmlComponents')
library('dashTable')
library('dashDaq')
library('data.table')


# Necessary Functions:
titleLink <- function(componentName) {
  return(htmlH2(dccLink(
    componentName,
    href = paste('/dash-daq/', tolower(componentName), sep = '')
  )))
}

referenceLink <- function(componentName) {
  return (htmlDiv(list(
    htmlBr(),
    dccLink(
      sprintf('More %s Examples & Reference', componentName),
      href = paste('/dash-daq/', tolower(componentName), sep = ''),
      htmlBr()
    )
  )))
}

dashDaqIntro <- htmlDiv(list(
  dccMarkdown(
    "
# Dash DAQ

Dash is a web application framework that provides pure R & Python abstraction
around HTML, CSS, and JavaScript.

Dash DAQ comprises a robust set of controls that make it simpler to
integrate data acquisition and controls into your Dash applications.

The source is on GitHub at [plotly/dash-daq](https://github.com/plotly/dash-daq).
  "
  ),

  dccMarkdown(sprintf(
    "These docs are using version %s.", packageVersion("dashDaq")
  )),

  dccMarkdown(
    paste(
      "```r",
      "\n",
      "library(dashDaq)",
      "\n",
      "packageVersion(\"dashDaq\")",
      "\n",
      packageVersion("dashDaq"),
      "\n",
      "```",
      sep = ""
    ),
    style = c(styles$container_padding_bottom, styles$code_container)
  )
))

booleanSwitch <- htmlDiv(list(
  titleLink("BooleanSwitch"),
  dccMarkdown("A switch component that toggles between on and off."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqBooleanSwitch(
  id = 'my-daq-booleanswitch',
  on = TRUE
)
"
  ))
)

colorPicker <- htmlDiv(list(
  titleLink("ColorPicker"),
  dccMarkdown("A color picker."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqColorPicker(
  id = 'my-color-picker',
  label = 'colorPicker'
)
"
  ))
)

gauge <- htmlDiv(list(
  titleLink("Gauge"),
  dccMarkdown("A gauge component that points to some value between some range."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqGauge(
  id = 'my-daq-gauge',
  max = 10,
  value = 6,
  min = 0
)
"
  ))
)

graduatedBar <- htmlDiv(list(
  titleLink("GraduatedBar"),
  dccMarkdown(
    "A graduated bar component that displays
        a value within some range as a percentage."
  ),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqGraduatedBar(
  id = 'my-daq-graduatedbar',
  value = 4
)
"
  ))
)

indicator <- htmlDiv(list(
  titleLink("Indicator"),
  dccMarkdown("A boolean indicator LED"),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqIndicator(
  id = 'my-daq-indicator',
  value = TRUE,
  color = '#00cc96'
)
"
  ))
)

joystick <- htmlDiv(list(
  titleLink("Joystick"),
  dccMarkdown("A joystick that can be used to apply direction and force."),
  utils$LoadAndDisplayComponent("
library(dashDaq)

daqJoystick(
  id = 'my-daq-joystick',)
")
))

knob <- htmlDiv(list(
  titleLink("Knob"),
  dccMarkdown("A knob component that can be turned to a value between some range."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqKnob(
  id = 'my-daq-knob',
  max = 10,
  value = 8,
  min = 0
)
  "
  )))

ledDisplay <- htmlDiv(list(
  titleLink("LEDDisplay"),
  dccMarkdown("A 7-segment LED display component."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqLEDDisplay(
  id = 'my-daq-leddisplay',
  value = '3.1459'
)
  "
  )))

numericInput <- htmlDiv(list(
  titleLink("NumericInput"),
  dccMarkdown(
    "A numeric input component that can be set to a value between some range."
  ),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqNumericInput(
  id = 'my-daq-numericinput',
  max = 10,
  value = 5,
  min = 0
)
  "
  )))

powerButton <- htmlDiv(list(
  titleLink("PowerButton"),
  dccMarkdown("A power button component that can be turned on or off."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqPowerButton(
  id = 'my-daq-powerbutton',
  on = TRUE
)
  "
  )))

precisionInput <- htmlDiv(list(
  titleLink("PrecisionInput"),
  dccMarkdown(
    "A numeric input component that converts an input value to the desired precision."
  ),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqPrecisionInput(
  id = 'my-daq-precisioninput',
  precision = 4,
  value = 299792458
)
  "
  )))

slider <- htmlDiv(list(
  titleLink("Slider"),
  dccMarkdown("A slider component with support for a target value."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqSlider(
  id = 'my-daq-slider',
  max = 100,
  value = 17,
  targets = list('25' = list('label' = 'TARGET')),
  min = 0
)
  "
  )))

stopButton <- htmlDiv(list(
  titleLink("StopButton"),
  dccMarkdown("A stop button"),
  utils$LoadAndDisplayComponent("
library(dashDaq)

daqStopButton(
  id = 'my-daq-stopbutton')
  "
  )))

tank <- htmlDiv(list(
  titleLink("Tank"),
  dccMarkdown("A tank component that fills to a value between some range."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqTank(
  id = 'my-daq-tank',
  max = 10,
  value = 5,
  min = 0
)
  "
  )))

thermometer <- htmlDiv(list(
  titleLink("Thermometer"),
  dccMarkdown("A thermometer component that fills to a value between some range."),
  utils$LoadAndDisplayComponent(
    "
library(dashDaq)

daqThermometer(
  id = 'my-daq-thermometer',
  max = 105,
  value = 98.6,
  min = 95
)
  "
  )))

toggleSwitch <- htmlDiv(list(
  titleLink("ToggleSwitch"),
  dccMarkdown("A switch component that toggles between two values."),
  utils$LoadAndDisplayComponent("
library(dashDaq)

daqToggleSwitch(
  id = 'my-daq-toggleswitch')
  "
  )))

# List holding output of LoadExampleCode for darkThemeProvider below
dtEx <-
  list(
    dtprovider = utils$LoadExampleCode("dash_docs/chapters/dash_daq/examples/darkThemeMainPageEx.R")
  )

darkThemeProvider <- htmlDiv(list(
  titleLink("DarkThemeProvider"),
  dccMarkdown(
    "A component placed at the root of the component tree
              to make all components match the dark theme."
  ),
  htmlDiv(
    list(dtEx$dtprovider$source_code,
         dtEx$dtprovider$layout),
    className = 'code-container'
  )
))


layout <- htmlDiv(
  list(
    dashDaqIntro,
    htmlHr(),
    booleanSwitch,
    referenceLink("BooleanSwitch"),
    htmlHr(),
    colorPicker,
    referenceLink("ColorPicker"),
    htmlHr(),
    gauge,
    referenceLink("Gauge"),
    htmlHr(),
    graduatedBar,
    referenceLink("GraduatedBar"),
    htmlHr(),
    indicator,
    referenceLink("Indicator"),
    htmlHr(),
    joystick,
    referenceLink("Joystick"),
    htmlHr(),
    knob,
    referenceLink("Knob"),
    htmlHr(),
    ledDisplay,
    referenceLink("LEDDisplay"),
    htmlHr(),
    numericInput,
    referenceLink("NumericInput"),
    htmlHr(),
    powerButton,
    referenceLink("PowerButton"),
    htmlHr(),
    precisionInput,
    referenceLink("PrecisionInput"),
    htmlHr(),
    slider,
    referenceLink("Slider"),
    htmlHr(),
    stopButton,
    referenceLink("StopButton"),
    htmlHr(),
    tank,
    referenceLink("Tank"),
    htmlHr(),
    thermometer,
    referenceLink("Thermometer"),
    htmlHr(),
    toggleSwitch,
    referenceLink("ToggleSwitch"),
    htmlHr(),
    darkThemeProvider,
    referenceLink("DarkThemeProvider"),
    htmlHr(),
    htmlHr(),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)
