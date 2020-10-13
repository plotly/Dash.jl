dashDataTable(
  data = df_to_list(df),
  columns = lapply(colnames(df),
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   })
)

