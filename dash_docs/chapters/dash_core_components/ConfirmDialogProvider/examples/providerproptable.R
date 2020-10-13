providerproptable =utils$props_to_list('dccConfirmDialogProvider')
x <- data.table::rbindlist(providerproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
