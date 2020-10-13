graphproptable =utils$props_to_list('dccGraph')
x <- data.table::rbindlist(graphproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
