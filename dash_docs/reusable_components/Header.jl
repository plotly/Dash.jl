using DashHtmlComponents

function Header(title::String)
    return html_div(
        html_h2(
            title,
            style = (borderBottom = "thin lightgrey solid", marginRight = 20,)
        )
    )
end
