using Dash
using DashHtmlComponents
using DashCoreComponents
js_files = [
    "https://www.google-analytics.com/analytics.js",
    Dict("src"=> "https://cdn.polyfill.io/v2/polyfill.min.js"),
    Dict(
        "src"=> "https://cdnjs.cloudflare.com/ajax/libs/ramda/0.26.1/ramda.min.js",
        "integrity"=> "sha256-43x9r7YRdZpZqTjDT5E0Vfrxn1ajIZLyYWtfAXsargA=",
        "crossorigin"=> "anonymous",
    ),
    Dict(
        "src"=> "https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.11/lodash.min.js",
        "integrity"=> "sha256-7/yoZS3548fXSRXqc/xYzjsmuW3sFKzuvOCHd06Pmps=",
        "crossorigin"=> "anonymous",
    ),
]

css_files = [
    "https://codepen.io/chriddyp/pen/bWLwgP.css",
    Dict(
        "href"=> "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css",
        "rel"=> "stylesheet",
        "integrity"=> "sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO",
        "crossorigin"=> "anonymous",
    )
]

app = dash(external_scripts=js_files, external_stylesheets=css_files)
app.index_string = """<!DOCTYPE html>
<html>
    <head>
        {%metas%}
        <title>{%title%}</title>
        {%css%}
    </head>
    <body>
        <div id="tested"></div>
        <div id="ramda-test"></div>
        <button type="button" id="btn">Btn</button>
        {%app_entry%}
        <footer>
            {%config%}
            {%scripts%}
            {%renderer%}
        </footer>
    </body>
</html>"""

app.layout = html_div()

run_server(app)
