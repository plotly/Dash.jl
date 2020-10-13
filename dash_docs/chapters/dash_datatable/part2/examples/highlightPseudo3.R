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
      'if' = list(column_id = 'Temperature'),
      backgroundColor = '#3D9970',
      color = 'white'
    )
  )
)
