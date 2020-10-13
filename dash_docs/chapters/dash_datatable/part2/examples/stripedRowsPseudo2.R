dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_cell_conditional = list(
    list(
      'if' = list('row_index' = 'odd'),
      backgroundColor = 'rgb(248, 248, 248)'
    )
  ),
  style_header = list(
    backgroundColor = 'white',
    fontWeight = 'bold' 
  )
)
