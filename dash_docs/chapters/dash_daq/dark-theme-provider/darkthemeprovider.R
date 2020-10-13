library(dash)
library(dashDaq)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultDarkThemeProvider = utils$LoadExampleCode(
    "dash_docs/chapters/dash_daq/dark-theme-provider/examples/defaultDarkThemeProvider.R")
)

dashdaq_intro <- htmlDiv(list(
  dccMarkdown('# Dark Theme Provider Examples and Reference')
  )
)

# Individual Components and Examples

defaultDarkThemeProvider <- htmlDiv(list(
  htmlH3("Default Dark Theme Provider"),
  htmlP("An example of a default dark theme provider without any extra properties."),
  htmlDiv(
    list(
      examples$defaultDarkThemeProvider$source_code,
      examples$defaultDarkThemeProvider$layout
    ),
    className = 'code-container'
  )
))

dtProviderProps <- props_to_list("daqDarkThemeProvider")

dtProviderPropsDF <- rbindlist(dtProviderProps, fill = TRUE)

dtProviderTable <- generate_table(dtProviderPropsDF)

layout <- htmlDiv(list(
  dashdaq_intro,
  htmlHr(),
  defaultDarkThemeProvider,
  htmlHr(),
  htmlHr(),
  htmlH3("Dark Theme Provider  Properties"),
  dtProviderTable,
  htmlHr(),
  dccMarkdown("[Back to Dash DAQ Documentation](/dash-daq)"),
  dccMarkdown("[Back to the Table of Contents](/)")
))

#app$run_server()
