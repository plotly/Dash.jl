using Dash
using DashHtmlComponents
using DashCoreComponents
app = dash(assets_ignore=".*ignored.*")
app.index_string = """<!DOCTYPE html>
<html>
    <head>
        {%metas%}
        <title>{%title%}</title>
        {%css%}
    </head>
    <body>
        <div id="tested"></div>
        {%app_entry%}
        <footer>
            {%config%}
            {%scripts%}
            {%renderer%}
        </footer>
    </body>
</html>"""

app.layout = html_div(id="layout") do
    html_div("Content", id="content"),
    dcc_input(id="test")
end
callback!(app,
    Output("output","children"),
    Input("input","value")
    ) do value
    return value
end

run_server(app)
