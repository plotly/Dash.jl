library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

df <- read.csv(url("https://gist.githubusercontent.com/chriddyp/c78bf172206ce24f77d6363a2d754b59/raw/c353e8ef842413cae56ae3920b8fd78468aa4cb2/usa-agricultural-exports-2011.csv"))

generate_table <- function(df, nrows=10) {

  rows <- lapply(1: min(nrows, nrow(df)),
                 function(i) {
                   htmlTr(children = lapply(as.character(df[i,]), htmlTd))
                 }
  )
  header <- htmlTr(children = lapply(names(df), htmlTh))
  htmlTable(
    children = c(list(header), rows)
  )
}

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlH4(children='US Agriculture Exports (2011)'),
      generate_table(df)
    ), style= list("overflow-x" = "scroll")
  )
)

app$run_server()
