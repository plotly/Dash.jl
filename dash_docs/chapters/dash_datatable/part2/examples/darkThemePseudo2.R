dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_as_list_view = TRUE,
  style_cell = list(
    color = 'white',
    backgroundColor = 'rgb(50, 50, 50)'
  ),
  style_header = list(
    backgroundColor = 'rgb(30, 30, 30)'
  )
)
