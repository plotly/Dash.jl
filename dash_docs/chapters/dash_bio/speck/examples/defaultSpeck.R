library(dashBio)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(readr)
library(dashTable)

app <- Dash$new()


importSpeck <- function(filepath,
                        header = FALSE,
                        skip = 2) {
  textdata <- read.table(
    text = paste0(readLines(filepath), collapse="\n"),
    header = header,
    skip = skip,
    col.names = c("symbol", "x", "y", "z"),
    stringsAsFactors = FALSE)

  return(dashTable::df_to_list(textdata))

}


data <- importSpeck("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz")

app$layout(htmlDiv(list(
  dccDropdown(
    id = 'speck-preset-views',
    options = list(
      list("label" = "Default", "value" = "default"),
      list("label" = "Ball and Stick", "value" = "stickball")
    ),
    value = "default"
  ),

  dashbioSpeck(
    id = "default-speck",
    data = data
  )
)))


app$callback(
  output(id = "default-speck", property = "presetView"),
  params = list(
    input(id = "speck-preset-views", property = "value")
  ),

  update_preset_view <- function(preset_name) {
    return(preset_name)
  }
)

app$run_server()
