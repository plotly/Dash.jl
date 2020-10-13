dashDataTable(
  fixed_columns = list(headers = TRUE, data = 1),
  style_table = list(width = "100%"),
  columns = lapply(colnames(df_election),
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df_election)
)
