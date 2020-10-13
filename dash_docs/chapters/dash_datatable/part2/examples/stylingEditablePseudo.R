dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName,
                       editable = (colName == 'Humidity')
                     )
                   }),
  data = df_to_list(df),
  style_data_conditional = list(
    list(
      'if' = list(column_editable = FALSE),
      backgroundColor = 'rgb(30, 30, 30)',
      color = 'white'
    ) 
  ), 
  style_header_conditional = list(
    list(
      'if' = list(column_editable = FALSE),
      backgroundColor = 'rgb(30, 30, 30)',
      color = 'white'
    ) 
  )
)
