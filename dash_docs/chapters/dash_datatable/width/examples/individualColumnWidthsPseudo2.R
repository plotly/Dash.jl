dashDataTable(
  style_cell_conditional = list(
    list(
      'if' = list('column_id' = 'Temperature'),
      width = '130px'
    ),
    list(
      'if' = list('column_id' = 'Humidity'),
      width = '130px'
    ),      
    list(
      'if' = list('column_id' = 'Pressure'),
      width = '130px'
    )
  ),
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df)
)
