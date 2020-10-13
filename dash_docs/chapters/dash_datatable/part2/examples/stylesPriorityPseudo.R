dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_cell = list(
    border = '1px solid grey'
  ),
  style_header = list(
    border = '1px solid black' 
  )
)
