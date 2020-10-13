library(dash)
library(dashTable)

df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/solar.csv")

app <- Dash$new()

app$layout(
  dashDataTable(
    data = df_to_list(df), 
    columns = lapply(colnames(df), 
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     })
  )
)

app$run_server()

