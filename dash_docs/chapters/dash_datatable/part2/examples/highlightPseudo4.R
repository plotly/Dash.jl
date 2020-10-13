dashDataTable(
  columns = lapply(colnames(df), 
                   function(colName){
                     list(
                       id = colName,
                       name = colName
                     )
                   }),
  data = df_to_list(df),
  style_data_conditional = list(
    list(
      'if' = list(column_id = 'Region', 
                  filter_query = '{Region} eq "Montreal"'),
      backgroundColor = '#3D9970',
      color = 'white'
    ),
    list(
      'if' = list(column_id = 'Humidity', 
                  filter_query = '{Humidity} eq 20'),
      backgroundColor = '#3D9970',
      color = 'white'
    ),
    list(
      'if' = list(column_id = 'Temperature', 
                  filter_query = '{Temperature} > 3.9'),
      backgroundColor = '#3D9970',
      color = 'white'
    )
  )
)
