library(dash)
library(dashHtmlComponents)


app <- Dash$new()

app$layout(
    htmlDiv(
        list(
            htmlButton("execute callback", id="button_1"),
            htmlDiv("callback not executed", id="first_output_1"),
            htmlDiv("callback not executed", id="second_output_1")
        )
    )
)

app$callback(
    list(output("first_output_1", "children"),
         output("second_output_1", "children")),
    params=list(input("button_1", "n_clicks")),
    function(n_clicks) {
        return(list(paste0("n_clicks is ", as.character(n_clicks)),
                    paste0("n_clicks is ", as.character(n_clicks))
            )
        )
    }
)

app$run_server()
