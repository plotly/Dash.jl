dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_cell = list(textAlign = 'right'),
  style_cell_conditional = list(
    list(
      'if' = list('column_id' = 'Region'),
      textAlign = 'left'
    )
  )
)
