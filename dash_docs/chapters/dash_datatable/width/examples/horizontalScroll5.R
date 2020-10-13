library(dash)
library(dashTable)

df_election <- data.frame(
  Date = c("July 12th, 2013 - July 25th, 2013",
           "July 12th, 2013 - August 25th, 2013",
           "July 12th, 2014 - August 25th, 2014"),
  Election_Polling_Organization = c("The New York Times", "Pew Research", "The Washington Post"),
  Rep = c(1, -20, 3.512),
  Dem = c(10,20,30),
  Ind = c(2, 10924, 3912),
  Region = c("Northern New York State to the Southern Appalachian Mountains",
             "Canada",
             "Southern Vermont")
)

app <- Dash$new()

app$layout(
  dashDataTable(
    style_table = list(overflowX = 'scroll'), 
    style_cell = list(
      minWidth = '180px', 
      width = '180px', 
      maxWidth = '180px',
      whiteSpace = 'no-wrap',
      overflow = 'hidden',
      textOverflow = 'ellipsis'
    ),
    css = list(
      list(
        selector = '.dash-cell div.dash-cell-value',
        rule = 'display: inline; white-space: inherit; overflow: inherit; text-overflow: inherit;'
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
)

app$run_server()
