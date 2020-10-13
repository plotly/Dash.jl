source('dash_docs/utils.R', local=utils)
datepickerproptable =utils$props_to_list('dccDatePickerRange')
x <- data.table::rbindlist(datepickerproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  utils$generate_table(x)
  
)

app$run_server()
