library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

theme <- list(
  'dark' = TRUE,
  'detail' = '#007439',
  'primary' = '#00EA64',
  'secondary' = '#6E6E6E'
)

rootLayout <- htmlDiv(list(
  daqBooleanSwitch(
    on = TRUE,
    id = 'darktheme-daq-booleanswitch',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqToggleSwitch(
    id = 'darktheme-daq-toggleswitch',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqColorPicker(
    value = 17,
    id = 'darktheme-daq-colorpicker',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqGauge(
    min = 0,
    max = 10,
    value = 6,
    color = theme[['primary']],
    id = 'darktheme-daq-gauge',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqGraduatedBar(
    value = 4,
    color = theme[['primary']],
    id = 'darktheme-daq-graduatedbar',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqIndicator(
    value = TRUE,
    color = theme[['primary']],
    id = 'darktheme-daq-indicator',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqKnob(
    min = 0,
    max = 10,
    value = 6,
    color = theme[['primary']],
    id = 'darktheme-daq-knob',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqLEDDisplay(
    value = "3.14159",
    color = theme[['primary']],
    id = 'darktheme-daq-leddisplay',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqNumericInput(
    min = 0,
    max = 10,
    value = 4,
    id = 'darktheme-daq-numericinput',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqPowerButton(
    on = TRUE,
    color = theme[['primary']],
    id = 'darktheme-daq-powerbutton',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqPrecisionInput(
    precision = 4,
    value = 299792458,
    id = 'darktheme-daq-precisioninput',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqStopButton(
    id = 'darktheme-daq-stopbutton',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqSlider(
    min = 0,
    max = 100,
    value = 30,
    targets = list("25" = list("label" = "TARGET")),
    color = theme[['primary']],
    id = 'darktheme-daq-slider',
    className = 'dark-theme-control'
  ), htmlBr(),
  daqTank(
    min = 0,
    max = 10,
    value = 5,
    id='darktheme-daq-tank',
    color = theme[['primary']],
    className = 'dark-theme-control'
  ), htmlBr(),
  daqThermometer(
    min = 95,
    max = 105,
    value = 98.6,
    id = 'darktheme-daq-thermometer',
    className = 'dark-theme-control',
    color = theme[['primary']],
  ), htmlBr()
))

app$layout(htmlDiv(
  id = 'dark-theme-container',
  style = list('padding' = '50px'),
  children = list(
    daqToggleSwitch(
      id = 'toggle-theme',
      label = list('Light', 'Dark'),
      value = TRUE
    ),
    htmlBr(),
    htmlDiv(
      id = 'theme-colors',
      children = list(
        daqColorPicker(
          id = 'primary-color',
          label = 'Primary color',
          value = list(hex = '#00EA64')
        ),
        daqColorPicker(
          id = 'secondary-color',
          label = 'Accent color',
          value = list(hex = '#6E6E6E')
        ),
        daqColorPicker(
          id = 'detail-color',
          label = 'Detail color',
          value = list(hex = '#007439')
        )
      )
    ),
    htmlDiv(
      id = 'dark-theme-components',
      children = list(daqDarkThemeProvider(theme = theme,
                                           children = rootLayout)),
      style = list(
        'border' = 'solid 1px #A2B1C6',
        'border-radius' = '5px',
        'padding' = '50px',
        'margin-top' = '20px'
      )
    )
  )
))

app$callback(
  output(id = "dark-theme-components", property = "children"),
  params = list(input(id = "toggle-theme", property = "value"),
                input(id = "primary-color", property = "value"),
                input(id = "secondary-color", property = "value"),
                input(id = "detail-color", property = "value")
                ),

  turn_dark <- function(dark, p, s, d) {
    if (dark) {
      theme[['dark']] <- TRUE
    } else {
      theme[['dark']] <- FALSE
    }
    
    if (length(p) > 0) {
      theme[['primary']] <- p$hex
      
      # When rootLayout child has color property, update to p$hex
      rootLayout <- lapply(
        1:length(rootLayout[[1]]$children),
          function(i) {
            if (length(rootLayout[[1]]$children[[i]]$props$color) > 0) {
              rootLayout[[1]]$children[[i]]$props$color <- p$hex
              rootLayout[[1]]$children[[i]]
            } else {
              rootLayout[[1]]$children[[i]]
            }
          })
    }
    if (length(s) > 0) {
      theme[['secondary']] <- s$hex
    }
    if (length(d) > 0) {
      theme[['detail']] <- d$hex
    }
    return(daqDarkThemeProvider(theme = theme, children = rootLayout))
  }
)

app$callback(
  output(id = "dark-theme-components", property = "style"),
  params = list(input(id = "toggle-theme", property = "value"),
                state(id = "dark-theme-components", property = "style")),

  switch_bg <- function(dark, currentStyle) {

    if (dark) {
      currentStyle[['backgroundColor']] <- '#303030'
      
    }
    else {
      currentStyle[['backgroundColor']] <- 'white'
      }
    
    return(currentStyle)
    
  }
)

app$run_server()
