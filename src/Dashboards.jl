module Dashboards
import HTTP, JSON2
include("scripts.jl")
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
    
    scripts = join(map(SCRIPTS) do pair
        """<script src="/_dash-component-suites/$(pair.second.package)/$(pair.second.file)?v=$(pair.second.version)"></script>"""
    end, "")
    


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
function component_suites(req::HTTP.Request)
    dump(req.target)
    target = HTTP.URI(req.target)
    parts = split(target.path, "/")
    
    if length(parts) < 4
        return HTTP.Response(404)
    end
    
    package = Symbol(parts[3])
    
    if !haskey(components_packages, package)
        return HTTP.Response(404)
    end
    
    filename = (@__DIR__) * "/../lib" * components_packages[package] * parts[4]
    
    try    
        response = HTTP.Response(200)
        response.body = read(filename)
        push!(response.headers, "Content-Type" => "application/javascript")    
        return response
    catch
        return HTTP.Response(404)
    end
    
end

const DASH_ROUTER = HTTP.Router()
HTTP.@register(DASH_ROUTER, "GET", "/", index)
HTTP.@register(DASH_ROUTER, "GET", "/_dash-component-suites/*", component_suites)
test() = HTTP.serve(DASH_ROUTER, HTTP.Sockets.localhost, 8080)

end # module
