storeproptable =utils$props_to_list('dccStore')
x <- data.table::rbindlist(storeproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
