dropdownproptable =utils$props_to_list('dccDropdown')
x <- data.table::rbindlist(dropdownproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
