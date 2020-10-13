locationproptable =utils$props_to_list('dccLocation')
x <- data.table::rbindlist(locationproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
