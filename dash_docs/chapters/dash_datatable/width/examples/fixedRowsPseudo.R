dashDataTable(
  fixed_rows= list(headers = TRUE, data = 0),
  style_cell = list(
    width = '150px'
  ),
  columns = lapply(colnames(df_long), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df_long)
)
