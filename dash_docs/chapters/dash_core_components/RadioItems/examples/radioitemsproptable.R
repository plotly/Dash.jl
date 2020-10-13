radioproptable =utils$props_to_list('dccRadioItems')
x <- data.table::rbindlist(radioproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
