# app$callback(
#   output(id = 'intermediate-value', property = 'children'),
#   list(input(id = 'dropdown', property = 'value')),
#   function(value) {
#     
#     cleaned_df <- your_expensive_clean_or_compute_step(value)
#     
#     # a few filter steps that compute the data
#     # as it's needed in the future callbacks
#     df_1 <- cleaned_df[cleaned_df['fruit'] == 'apples', ]
#     df_2 <- cleaned_df[cleaned_df['fruit'] == 'oranges', ]
#     df_3 <- cleaned_df[cleaned_df['fruit'] == 'figs', ]
#     
#     datasets <- list(
#       df_1 = jsonlite::toJSON(df_1, ...),
#       df_2 = jsonlite::toJSON(df_2, ...),
#       df_3 = jsonlite::toJSON(df_3, ...)
#     )
#     
#     jsonlite::toJSON(datasets, ...)
#   })
# 
# app$callback(
#   output(id = 'graph', property = 'figure'),
#   list(input(id = 'intermediate-value', property = 'children')),
#   function(jsonified_cleaned_data) {
#     
#     datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
#     dff <- jsonlite::fromJSON(datasets[['df_1']], ...)
#     figure <- create_figure_1(dff)
#     figure
#   })
# 
# app$callback(
#   output(id = 'graph', property = 'figure'),
#   list(input(id = 'intermediate-value', property = 'children')),
#   function(jsonified_cleaned_data) {
#     
#     datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
#     dff <- jsonlite::fromJSON(datasets[['df_2']], ...)
#     figure <- create_figure_2(dff)
#     figure
#   })
# 
# app$callback(
#   output(id = 'graph', property = 'figure'),
#   list(input(id = 'intermediate-value', property = 'children')),
#   function(jsonified_cleaned_data) {
#     
#     datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
#     dff <- jsonlite::fromJSON(datasets[['df_3']], ...)
#     figure <- create_figure_3(dff)
#     figure
#   })
