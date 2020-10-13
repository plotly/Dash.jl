library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

df <- read.csv(
  file = 'https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv',
  stringsAsFactors = FALSE
)

# add an id column and set it as the index
# in this case the unique ID is just the country name, so we could have just
# renamed 'country' to 'id' (but given it the display name 'country'), but
# here it's duplicated just to show the more general pattern.
df$id <- df$country
rownames(df) <- df$country

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'datatable-row-ids',
        columns = lapply(setdiff(colnames(df), "id"), 
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
      htmlDiv(id = 'datatable-row-ids-container')
    )
  )
)

app$callback(output = list(id = 'datatable-row-ids-container', property = 'children'),
             params = list(input(id = 'datatable-row-ids', property = 'derived_virtual_row_ids'),
                           input(id = 'datatable-row-ids', property = 'selected_row_ids'),
                           input(id = 'datatable-row-ids', property = 'active_cell')),
             function(row_ids, selected_row_ids, active_cell) {
               
               selected_id <- unlist(selected_row_ids)
               
               if(is.null(unlist(row_ids))) {
                 subdf <-  df
                 row_ids <- subdf$id
               } else {
                 subdf <- df[sapply(unlist(row_ids), function(id) {which(df$id %in% id)}), ]
                 row_ids <- unlist(row_ids)
               }

               active_row_id <- if(is.null(unlist(active_cell))) {
                 character(0)
               } else {
                 active_cell[['row_id']]
               }
               
               colors <- sapply(row_ids, 
                                function(row_id){
                                  if(row_id %in% active_row_id) '#FF69B4'
                                  else if (row_id %in% selected_id) '#7FDBFF'
                                  else '#0074D9'
                                })
               
               columns <- intersect(c("pop", "lifeExp", "gdpPercap"),
                                    colnames(subdf))
               
               if(length(columns) != 0) {

                 lapply(columns,
                        function(column) {

                          dccGraph(
                            id = paste(column, "--row-ids"),
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
             })

app$run_server()
