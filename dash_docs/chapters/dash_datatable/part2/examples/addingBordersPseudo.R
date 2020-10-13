dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_data = list(
    border = '1px solid blue'
  ),
  style_header = list(
    border = '1px solid pink' 
  )
)
