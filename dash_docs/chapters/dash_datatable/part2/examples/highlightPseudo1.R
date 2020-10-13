dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_data_conditional = list(
    list(
      'if' = list(row_index = 4),
      backgroundColor = '#3D9970',
      color = 'white'
    )
  )
)
