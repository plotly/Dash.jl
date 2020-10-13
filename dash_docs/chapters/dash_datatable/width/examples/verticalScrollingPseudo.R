dashDataTable(
  style_table= list(
    maxHeight = '300',
    overflowY = 'scroll'
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
