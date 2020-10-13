library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

app <- Dash$new()

app$layout(
    htmlDiv(
    list(
      dashDataTable(
        id = 'datatable-interactivity',
        columns = lapply(colnames(df), 
                         function(colName){
                           list(
                             id = colName,
                             name = colName,
                             deletable = TRUE
                           )
                         }),
        data = df_to_list(df),
        editable = TRUE,
        filter_action="native",
        sort_action="native",
        sort_mode = "multi",
        row_selectable = "multi",
        row_deletable = TRUE,
        selected_rows = character(0),
        page_action="native",
        page_current= 0,
        page_size= 10
      ),
      # define children: https://github.com/plotly/dash-core-components/issues/227
      htmlDiv(id = 'datatable_interactivity_container')
    )
  )
)

app$callback(output = list(id = 'datatable_interactivity_container', property = 'children'),
             params = list(input(id = 'datatable-interactivity', property = 'derived_virtual_data'),
                           input(id = 'datatable-interactivity', property = 'derived_virtual_selected_rows')),
             function(rows, derived_virtual_selected_rows) {
               # When the table is first rendered, `derived_virtual_data` and
               # `derived_virtual_selected_rows` will be `list(NULL)`. This is due to an
               # idiosyncracy in Dash (unsupplied properties are always NULL and Dash
               # calls the dependent callbacks when the component is first rendered).
               # So, if `rows` is `list(NULL)`, then the component was just rendered
               # and its value will be the same as the component's dataframe.
               # Instead of setting `list(NULL)` in here, you could also set
               # `derived_virtual_data = as.list(0:(dim(df)[1] - 1))` when you initialize
               # the component.
               
               # the index of a vector in Python starts at 0, but 1 in R
               derived_virtual_selected_rows <- unlist(derived_virtual_selected_rows)
               if(is.null(derived_virtual_selected_rows)) {
                 derived_virtual_selected_rows <- character(0)
               } else derived_virtual_selected_rows <- derived_virtual_selected_rows + 1
               
               subdf <- if(is.null(unlist(rows))) df else as.data.frame(do.call(rbind, rows))
               
               colors <- sapply(1:dim(subdf)[1], 
                                function(i){
                                  if(i %in% derived_virtual_selected_rows) '#7FDBFF' else '#0074D9'
                                })
               
               # check if column exists - user may have deleted it
               # If `column.deletable=False`, then you don't
               # need to do this check.
               columns <- intersect(c("pop", "lifeExp", "gdpPercap"),
                                    colnames(subdf))
               
               if(length(columns) != 0) {
                 
                 lapply(columns,
                        function(column) {
                          
                          dccGraph(
                            id = column,
                            figure = list(
                              data = list(
                                list(
                                  x = subdf[, "country"],
                                  y = subdf[, column],
                                  type = "bar",
                                  marker = list(color = colors)
                                )
                              ),
                              layout = list(
                                xaxis = list(automargin = TRUE),
                                yaxis = list(
                                  automargin = TRUE,
                                  title = list(text = column)
                                ),
                                height = 250,
                                margin = list(t = 10, l = 10, r = 10)
                              )
                            )
                          )
                        }
                 )
               }
             }
)

app$run_server()
