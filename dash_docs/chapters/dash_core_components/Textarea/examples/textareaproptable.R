textproptable =utils$props_to_list('dccTextarea')
x <- data.table::rbindlist(textproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
