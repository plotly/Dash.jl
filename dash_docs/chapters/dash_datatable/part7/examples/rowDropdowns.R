library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

df_per_row_dropdown <- data.frame(
  City = c('NYC', 'Montreal', 'Los Angeles'),
  Neighborhood = c('Brooklyn', 'Mile End', 'Venice'),
  Temperature_F = c(70, 60, 90)
)

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'dropdown_per_row',
        data = df_to_list(df_per_row_dropdown),
        columns = list(
          list(id = 'City', name = 'City'),
          list(id = 'Neighborhood', name = 'Neighborhood', presentation = 'dropdown'),
          list(id = 'Temperature_F', name = 'Temperature_F')
        ),
        editable = TRUE,
        dropdown_conditional = list(
          list(
            'if' = list(
              column_id = 'Neighborhood',
              filter_query = '{City} eq "NYC"'
            ),
            'options' = lapply(c('Brooklyn', 'Queens', 'Staten Island'), 
                               function(neighbor) {
                                 list(label = neighbor, value = neighbor)
                               })
          ),
          list(
            'if' = list(
              column_id = 'Neighborhood',
              filter_query = '{City} eq "Montreal"'
            ),
            'options' = lapply(c('Mile End', 'Plateau', 'Hochelaga'), 
                               function(neighbor) {
                                 list(label = neighbor, value = neighbor)
                               })
          ),
          list(
            'if' = list(
              column_id = 'Neighborhood',
              filter_query = '{City} eq "Los Angeles"'
            ),
            'options' = lapply(c('Venice', 'Hollywood', 'Los Feliz'), 
                               function(neighbor) {
                                 list(label = neighbor, value = neighbor)
                               })
          )
        )  
      ),
      htmlDiv(id = 'dropdown_per_row_container')
    )
  )
)

app$run_server()
