library(dash)
library(dashHtmlComponents)


app <- Dash$new()

app$layout(
    htmlDiv(
        list(
            htmlButton("execute fast callback", id="button_3"),
            htmlButton("execute slow callback", id="button_4"),
            htmlDiv("callback not executed", id="first_output_3"),
            htmlDiv("callback not executed", id="second_output_3"),
            htmlDiv("callback not executed", id="third_output_3")
        )
    )
)

app$callback(
    list(output("first_output_3", "children")),
    params=list(input("button_3", "n_clicks")),
    function(n_clicks) {
        return(list(paste("in the fast callback it is ",
                    toString(Sys.time())))
        )
    }
)

app$callback(
    list(output("second_output_3", "children")),
    params=list(input("button_4", "n_clicks")),
    function(n_clicks) {
        Sys.sleep(5)
        return(list(paste("in the slow callback it is ", toString(Sys.time()))))
    }
)

app$callback(
    list(output("third_output_3", "children")),
    params=list(input("first_output_3", "children"), input("second_output_3", "children")),
    function(children_1, children_2) {
        return(list(paste("in the third callback it is ", toString(Sys.time()))))
    }
)

app$run_server()
