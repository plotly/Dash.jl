using DashHtmlComponents

function Chapter(name::String, href::Union{Nothing, String}, caption::Union{Nothing, String})
    divTitle = html_a(
        name,
        href = href,
        id = href,
        className = "toc--chapter-link"
    )
    divCaption = html_small(
        className = "toc--chapter-content",
        children = dcc_markdown(caption),
        style = (display = "block", marginTop = "3px",)
    )
    if !isnothing(caption)
        return(
            html_div(
                className = "toc--chapter",
                style = (marginTop = "10px",),
                children = (divTitle, divCaption,)
            )
        )
    else
        return(
            html_div(
                className = "toc--chapter",
                style = (marginTop = "10px",),
                children = (divTitle)
            )
        )
    end
end
