buttonproptable =utils$props_to_list('htmlButton')
x <- data.table::rbindlist(buttonproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
