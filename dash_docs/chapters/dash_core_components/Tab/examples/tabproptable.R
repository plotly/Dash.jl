tabproptable =utils$props_to_list('dccTab')
x <- data.table::rbindlist(tabproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
