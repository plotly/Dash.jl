make_css_tag(url::String) = """<link rel="stylesheet" href="$(url)">"""
make_css_tag(dict::Dict{String, String}) = formattag("link", dict, opened = true)

make_scipt_tag(url::String) = """<script src="$(url)"></script>"""
make_scipt_tag(dict::Dict{String, String}) = formattag("script", dict)

function metas_html(app::DashApp)
    meta_tags = app.config.meta_tags
    has_ie_compat = any(meta_tags) do tag
        get(tag, "http-equiv", "") == "X-UA-Compatible"
    end
    has_charset = any(tag -> haskey(tag, "charset"), meta_tags)
    
    result = String[]
    !has_ie_compat && push!(result, "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">")
    !has_charset && push!(result, "<meta charset=\"UTF-8\">")

    append!(result, formattag.("meta", meta_tags, opened = true))
    return join(result, "\n        ")

end

css_html(app::DashApp) = join(map(make_css_tag, app.config.external_stylesheets), "\n       ")

app_entry_html() = """
<div id="react-entry-point">
    <div class="_dash-loading">
        Loading...
    </div>
</div>
"""

function config_html(app::DashApp; debug = false) 
    config = (
        url_base_pathname = app.config.url_base_pathname,
        requests_pathname_prefix = app.config.requests_pathname_prefix,
        ui = true,
        props_check = debug,
        show_undo_redo = app.config.show_undo_redo,
        suppress_callback_exceptions = app.config.suppress_callback_exceptions
    )
    return """<script id="_dash-config" type="application/json">$(JSON2.write(config))</script>"""
end 



function scripts_html(app::DashApp; debug = false)
    scripts = app.config.external_scripts
    append!(scripts, 
        ComponentPackages.components_js_sources(app.config.requests_pathname_prefix, debug = debug)
    )
    return join(map(make_scipt_tag, scripts), "\n            ")
end

renderer_html() = """<script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>"""

favicon_html(app::DashApp) = "" 

#=
def _walk_assets_directory(self):
        walk_dir = self.config.assets_folder
        slash_splitter = re.compile(r"[\\/]+")
        ignore_str = self.config.assets_ignore
        ignore_filter = re.compile(ignore_str) if ignore_str else None

        for current, _, files in os.walk(walk_dir):
            if current == walk_dir:
                base = ""
            else:
                s = current.replace(walk_dir, "").lstrip("\\").lstrip("/")
                splitted = slash_splitter.split(s)
                if len(splitted) > 1:
                    base = "/".join(slash_splitter.split(s))
                else:
                    base = splitted[0]

            if ignore_filter:
                files_gen = (x for x in files if not ignore_filter.search(x))
            else:
                files_gen = files

            for f in sorted(files_gen):
                path = "/".join([base, f]) if base else f

                full = os.path.join(current, f)

                if f.endswith("js"):
                    self.scripts.append_script(self._add_assets_resource(path, full))
                elif f.endswith("css"):
                    self.css.append_css(self._add_assets_resource(path, full))
                elif f == "favicon.ico":
                    self._favicon = path
=#

function find_assets_files(app::DashApp)
    result = (css = String[], js = String[], favicon = nothing)
    
    if app.config.include_assets_files
        for (base, dirs, files) in walkdir(app.config.assets_folder)
            if !isempty(files)
                relative = (base == app.config.assets_folder) ? "" : relpath(base, app.config.assets_folder)
                relative_uri = join(splitpath(relative), "/") * "/"
                
                
            end
            
            
        end
    end
    return result
end

function index_page(app::DashApp; debug = false)    
    
    return interpolate_string(app.config.index_string,
        metas = metas_html(app),
        title = app.name,
        favicon = favicon_html(app),
        css = css_html(app),
        app_entry = app_entry_html(),
        config = config_html(app, debug = debug),
        scripts = scripts_html(app, debug = debug),
        renderer = renderer_html()
    )
end