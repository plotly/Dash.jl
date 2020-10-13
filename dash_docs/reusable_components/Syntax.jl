using DashHtmlComponents

function Syntax(children::Component; style = code_container, summary = "")
    if (summary != "")
        return(
            html_details(
                (
                    html_summary(children = summary),
                    html_div(children)
                ),
                open = true
            )
        )
    else
        return(
            dcc_markdown(
                children,
                style = style
            )
        )
    end
end
