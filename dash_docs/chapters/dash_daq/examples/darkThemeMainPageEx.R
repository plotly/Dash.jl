library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

theme <- list(
  'dark'= FALSE,
  'detail' = '#007439',
  'primary' = '#00EA64', 
  'secondary' = '#6E6E6E'
)

app$layout(htmlDiv(
  id = 'dark-theme-provider-demo',
  children = list(
    htmlBr(),
    daqToggleSwitch(
      id = 'daq-light-dark-theme',
      label = list('Light', 'Dark'),
      style = list('width' = '250px', 'margin' = 'auto'),
      value = FALSE
    ),
    htmlDiv(
      id = 'dark-theme-component-demo',
      children = list(daqDarkThemeProvider(
        theme = theme,
        children = daqKnob(value = 6)
      )),
      style = list('display' = 'block',
                   'margin-left' = 'calc(50% - 110px)')
    )
  )
))

app$callback(
  output(id = "dark-theme-component-demo", property = "children"),
  params = list(input(id = "daq-light-dark-theme", property = "value")),
  
  turn_dark <- function(dark_theme) {

    if (dark_theme) {
      theme['dark'] <- TRUE
    }
    else {
      theme['dark'] <- FALSE
    }
    return(list(daqDarkThemeProvider(theme = theme, children = daqKnob(value = 6))))
  }
)

app$callback(
  output(id = "dark-theme-provider-demo", property = "style"),
  params = list(input(id = "daq-light-dark-theme", property = "value")),
  
  change_bg <- function(dark_theme) {
    if (dark_theme) {
      return(list("background-color" = "#303030", "color" = "white"))
    }
    else {
      return(list("background-color" = "white", "color" = "black"))
    }
  }
)
app$run_server()
