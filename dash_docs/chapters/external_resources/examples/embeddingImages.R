library(dash)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlImg(src = '/assets/image.png')
    )
  )
)

# app$run_server(debug = TRUE)
