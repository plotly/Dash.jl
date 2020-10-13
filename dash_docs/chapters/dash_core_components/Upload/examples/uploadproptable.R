uploadproptable =utils$props_to_list('dccUpload')
x <- data.table::rbindlist(uploadproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
