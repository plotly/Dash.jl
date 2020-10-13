dashDataTable(
  style_data = list(
    whiteSpace = 'no-wrap',
    overflow = 'hidden',
    textOverflow = 'ellipsis',
    maxWidth = 30
  ),
  css = list(
    list(
      'selector' = '.dash-cell div.dash-cell-value',
      'rule' = 'display: inline; white-space: inherit; overflow: inherit; text-overflow: inherit;'
    )
  ),
  columns = lapply(colnames(df_election), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df_election)
)
