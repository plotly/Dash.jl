using DashHtmlComponents

function Section(title::String, links, description="", headerStyle = ())
    return(
        html_div(
            className = "toc--section",
            children = (
                html_h2(
                    title,
                    style = merge((borderBottom = "thin lightgrey solid", marginTop = 50,), headerStyle, )
                ),
                html_div(description),
                html_ul(
                    links,
                    className = "toc--chapters"
                )
            )
        )
    )
end
