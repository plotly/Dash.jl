# library(dash)
# library(dashCoreComponents)
# library(dashHtmlComponents)
# 
# external_stylesheets <- list(
#   list('https://codepen.io/chriddyp/pen/bWLwgP.css')
# )
# app <- Dash$new(external_stylesheets = external_stylesheets)
# 
# string <- "
# <!DOCTYPE html>
# <html>
#     <head>
#         {%metas%}
#         <title>{%title%}</title>
#         {%favicon%}
#         {%css%}
#     </head>
#     <body>
#         <div>My Custom header</div>
#         {%app_entry%}
#         <footer>
#             {%config%}
#             {%scripts%}
#             {%renderer%}
#         </footer>
#         <div>My Custom footer</div>
#     </body>
# </html>
# "
# app$index_string <- string
# 
# app$layout(htmlDiv('Simple Dash App'))
# 
# app$run_server()
