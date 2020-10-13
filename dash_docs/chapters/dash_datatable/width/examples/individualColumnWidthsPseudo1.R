dashDataTable(
  style_cell_conditional = list(
    list(
      'if' = list('column_id' = 'Date'), 
      width = '30%'
    ),
    list(
      'if' = list('column_id' = 'Region'), 
      width = '30%'
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
