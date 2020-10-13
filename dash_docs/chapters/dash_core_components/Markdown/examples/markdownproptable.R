markdownproptable =utils$props_to_list('dccMarkdown')
x <- data.table::rbindlist(markdownproptable, fill = TRUE)

app <- Dash$new()

layout = app$layout(
  generate_table(x)
  
)

app$run_server()
