library(dash)
library(dashTable)

df <- read.csv(
  file = "https://raw.githubusercontent.com/plotly/datasets/master/solar.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

app <- Dash$new()

app$layout(
  dashDataTable(
    id = "table",
    columns = lapply(colnames(df), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    data = df_to_list(df)
  )
)

app$run_server()
