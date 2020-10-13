test =utils$props_to_list('dccTabs')
x <- data.table::rbindlist(test, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
