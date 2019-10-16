module Dashboards
import HTTP, JSON2
include("Components.jl")
const components_packages = (
    dash_renderer = "/dash/dash-renderer/dash_renderer/",
    dash_core_components = "/dash-core-components/dash_core_components/",
    dash_html_components = "/dash-html-components/dash_html_components/"
)
function index(req::HTTP.Request)
    metas = ["""<meta http-equiv="X-UA-Compatible" content="IE=edge">""", """<meta charset="UTF-8">"""]
    title = "Test Dash"
    css = """<link rel="stylesheet" href="https://codepen.io/chriddyp/pen/bWLwgP.css">"""
    app_entry = """
        <div id="react-entry-point">
            <div class="_dash-loading">
                Loading...
            </div>
        </div>
    """
    config = (
        url_base_pathname = nothing,
        requests_pathname_prefix = "/",
        ui = true,
        props_check = true,
        show_undo_redo = false
    )
    
    scripts = Components.@components_js_include
    


    HTTP.Response(200, """<!DOCTYPE html>
    <html>
        <head>
            $(join(metas, ""))
            <title>$(title)</title>            
            $(css)
        </head>
        <body>
            $(app_entry)
            <footer>
            <script id="_dash-config" type="application/json">$(JSON2.write(config))</script>
            $scripts
            <script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>
            </footer>
        </body>
    </html>""")
end

const DASH_ROUTER = HTTP.Router()
HTTP.@register(DASH_ROUTER, "GET", "/", index)
Components.@register_js_sources(DASH_ROUTER, "")


test() = HTTP.serve(DASH_ROUTER, HTTP.Sockets.localhost, 8080)

end # module
