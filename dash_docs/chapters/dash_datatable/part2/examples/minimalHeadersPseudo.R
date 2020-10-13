dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_cell_conditional = lapply(c('Date', 'Region'),
                                  function(name) {
                                    list(
                                      'if' = list('column_id' = name),
                                      textAlign = 'left'
                                    )
                                  }),
  style_as_list_view = TRUE,
  style_cell = list(padding = '5px'),
  style_header = list(
    backgroundColor = 'white',
    fontWeight = 'bold' 
  )
)
