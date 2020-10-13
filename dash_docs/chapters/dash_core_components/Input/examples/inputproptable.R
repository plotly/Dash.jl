inputproptable =utils$props_to_list('dccInput')
x <- data.table::rbindlist(inputproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
