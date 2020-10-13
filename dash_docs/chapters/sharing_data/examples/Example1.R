# library(dash)
# library(dashCoreComponents)
# library(dashHtmlComponents)
# 
# app <- Dash$new()
# 
# global_df <- read.csv('...')
# 
# app$layout(
#   htmlDiv(
#     list(
#       dccGraph(id='graph'),
#       htmlTable(id='table'),
#       dccDropdown(id='dropdown'),
# 
#       # Hidden div inside the app that stores the intermediate value
#       htmlDiv(id='intermediate-value',
#               style=list(display = 'none'))
#     )
#   )
# )
# 
# app$callback(
#   output(id = 'intermediate-value', property = 'children'),
#   list(input(id = 'dropdown', property = 'value')),
#   function(value) {
# 
#     # some expensive clean data step
#     cleaned_df <- your_expensive_clean_or_compute_step(value)
# 
#     # more generally, this line would be
#     # convert 'data.frame' data structure to 'json' in R
#     jsonlite::toJSON(cleaned_df, ...)
#   }
# )
# 
# app$callback(
#   output(id = 'graph', property = 'figure'),
#   list(input(id = 'intermediate-value', 'children')),
#   function(value) {
# 
#     # load 'json' in R
#     dff <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
#     # create your figure with json data
#     figure <- create_figure(dff)
#     figure
#   }
# )
# 
# app$callback(
#   output(id = 'table', property = 'figure'),
#   list(input(id = 'intermediate-value', 'children')),
#   function(value) {
# 
#     # load json in R
#     dff <- jsonlite::fromJSON(jsonified_cleaned_data)
#     # create your table with json data
#     table <- create_table(dff)
#     table
#   }
# )
