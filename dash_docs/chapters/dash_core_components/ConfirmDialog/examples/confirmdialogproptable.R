confirmproptable =utils$props_to_list('dccConfirmDialog')
x <- data.table::rbindlist(confirmproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
 utils$generate_table(x)
  
)

app$run_server()
