
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

sliderproptable =utils$props_to_list('dccSlider')
x <- data.table::rbindlist(sliderproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
