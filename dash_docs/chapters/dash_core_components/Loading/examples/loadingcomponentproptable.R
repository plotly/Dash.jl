loadingproptable =utils$props_to_list('dccLoading')
x <- data.table::rbindlist(loadingproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
