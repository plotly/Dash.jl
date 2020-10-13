library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlDiv(
        className = "app-header",
        children = list(
          htmlDiv('Plotly Dash', className = "app-header--title")
        )
      ),
      htmlDiv(
        list(
          htmlH5('Overview'),
          htmlDiv(" 
                This is an example of a simple Dash app with
                local, customized CSS.
            ")
        )
      )
    )
  )
)

#app$run_server()
