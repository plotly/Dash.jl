using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash(assets_folder="hr_assets")
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
app.layout = html_div(id="hot-reload-content") do
    html_h3("Hot reload")
end

run_server(app,
        dev_tools_hot_reload=true,
        dev_tools_hot_reload_interval=0.1,
        dev_tools_hot_reload_max_retry=100,
)
