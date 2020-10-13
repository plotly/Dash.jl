dashDataTable(
  style_table = list(
    maxHeight = '300px',
    overflowY = 'scroll',
    border = 'thin lightgrey solid'
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
