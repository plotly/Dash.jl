const default_index = """<!DOCTYPE html>
<html>
    <head>
        {%metas%}
        <title>{%title%}</title>
        {%favicon%}
        {%css%}
    </head>
    <body>
        {%app_entry%}
        <footer>
            {%config%}
            {%scripts%}
            {%renderer%}
        </footer>
    </body>
</html>"""


"""
    struct DashApp <: Any

Representation of Dash application.

Not meant to be constructed directly, use `dash` function instead.
"""
mutable struct DashApp
    root_path ::String
    is_interactive ::Bool
    config ::DashConfig
    index_string ::Union{String, Nothing}
    title ::String
    layout ::Union{Nothing, Component, Function}
    devtools ::DevTools
    callbacks ::Dict{Symbol, Callback}
    
    DashApp(root_path, is_interactive, config, index_string, title = "Dash") = new(root_path, is_interactive, config, index_string, title, nothing, DevTools(dash_env(Bool, "debug", false)), Dict{Symbol, Callback}())
    
end

#only name, index_string and layout are available to set
function Base.setproperty!(app::DashApp, property::Symbol, value)
    property == :name && return set_name!(app, value)
    property == :index_string && return set_index_string!(app, value)
    property == :layout && return set_layout!(app::DashApp, value)
    property == :title && return set_title!(app::DashApp, value)

    property in fieldnames(DashApp) && error("The property `$(property)` of `DashApp` is read-only")

    error("The property `$(property)` of `DashApp` don't exists")
end

function set_name!(app::DashApp, name)
    setfield!(app, :name, name)
end

function set_title!(app::DashApp, title)
    setfield!(app, :title, title)
end

get_name(app::DashApp) = app.name

function set_layout!(app::DashApp, component::Union{Component,Function})
    setfield!(app, :layout, component)
end

get_layout(app::DashApp) = app.layout

function check_index_string(index_string::AbstractString)
    validate_index(
        "index_string", index_string, 
        [
            "{%app_entry%}"=>r"{%app_entry%}",
            "{%config%}"=>r"{%config%}",
            "{%scripts%}"=>r"{%scripts%}"
        ]
    )
end
function set_index_string!(app::DashApp, index_string::AbstractString)
    check_index_string(index_string)
    setfield!(app, :index_string, index_string)
end

get_index_string(app::DashApp) = app.component.index_string


function enable_dev_tools!(app::DashApp; debug = nothing, 
            dev_tools_ui = nothing,
            dev_tools_props_check = nothing,
            dev_tools_serve_dev_bundles = nothing,
            dev_tools_hot_reload = nothing,
            dev_tools_hot_reload_interval = nothing,
            dev_tools_hot_reload_watch_interval = nothing,
            dev_tools_hot_reload_max_retry = nothing,
            dev_tools_silence_routes_logging = nothing,
            dev_tools_prune_errors = nothing)
    @env_default!(debug, Bool, true)
    setfield!(app, :devtools, DevTools(
        debug;
        ui = dev_tools_ui,
        props_check = dev_tools_props_check,
        serve_dev_bundles = dev_tools_serve_dev_bundles,
        hot_reload = dev_tools_hot_reload,
        hot_reload_interval = dev_tools_hot_reload_interval,
        hot_reload_watch_interval = dev_tools_hot_reload_watch_interval,
        hot_reload_max_retry = dev_tools_hot_reload_max_retry,
        silence_routes_logging = dev_tools_silence_routes_logging,
        prune_errors = dev_tools_prune_errors
    ))
end

get_devsetting(app::DashApp, name::Symbol) = getproperty(app.devtools, name)

get_setting(app::DashApp, name::Symbol) = getproperty(app.config, name)

get_assets_path(app::DashApp) = joinpath(app.root_path, get_setting(app, :assets_folder))

"""
    dash(name::String;
            external_stylesheets,
            external_scripts,
            url_base_pathname,        
            requests_pathname_prefix,
            routes_pathname_prefix,
            assets_folder,
            assets_url_path,
            assets_ignore,        
            serve_locally,
            suppress_callback_exceptions,
            eager_loading , 
            meta_tags, 
            index_string, 
            assets_external_path, 
            include_assets_files, 
            show_undo_redo,
            compress
        )

Construct a dash app 

# Arguments
- `assets_folder::String` - a path, relative to the current working directory,
        for extra files to be used in the browser. Default ``'assets'``.

- `assets_url_path::String` - The local urls for assets will be:
        ``requests_pathname_prefix * assets_url_path * "/" * asset_path``
        where ``asset_path`` is the path to a file inside ``assets_folder``.
        Default ``'assets'`.
    

- `assets_ignore::String` - [IN DEVELOPMENT] A regex, as a string to pass to ``Regex``, for
        assets to omit from immediate loading. Ignored files will still be
        served if specifically requested. You cannot use this to prevent access
        to sensitive files. 
    :type assets_ignore: string

-  `assets_external_path::String` - [IN DEVELOPMENT] an absolute URL from which to load assets.
        Use with ``serve_locally=false``. Dash can still find js and css to
        automatically load if you also keep local copies in your assets
        folder that Dash can index, but external serving can improve
        performance and reduce load on the Dash server.        
    

- `include_assets_files::Bool` - [IN DEVELOPMENT] Default ``true``, set to ``False`` to prevent
        immediate loading of any assets. Assets will still be served if
        specifically requested. You cannot use this to prevent access
        to sensitive files. 
    

- `url_base_pathname::String`: A local URL prefix to use app-wide.
        Default ``nothing``. Both `requests_pathname_prefix` and
        `routes_pathname_prefix` default to `url_base_pathname`.
        

- `requests_pathname_prefix::String`: A local URL prefix for file requests.
        Defaults to `url_base_pathname`, and must end with
        `routes_pathname_prefix`
    

- `routes_pathname_prefix::String`: A local URL prefix for JSON requests.
        Defaults to ``url_base_pathname``, and must start and end
        with ``'/'``.

- `serve_locally`: [IN DEVELOPMENT] If ``true`` (default), assets and dependencies
        (Dash and Component js and css) will be served from local URLs.
        If ``false`` we will use CDN links where available.
    
- `meta_tags::Vector{Dict{String, String}}`: html <meta> tags to be added to the index page.
        Each dict should have the attributes and values for one tag, eg:
        ``Dict("name"=>"description", "content" => "My App")``
    

- `index_string::String`: Override the standard Dash index page.
        Must contain the correct insertion markers to interpolate various
        content into it depending on the app config and components used.
        See https://dash.plotly.com/external-resources for details.
    

- `external_scripts::Vector`: Additional JS files to load with the page.
        Each entry can be a String (the URL) or a Dict{String, String} with ``src`` (the URL)
        and optionally other ``<script>`` tag attributes such as ``integrity``
        and ``crossorigin``.    

- `external_stylesheets::Vector`: Additional CSS files to load with the page.
        Each entry can be a String (the URL) or a Dict{String, String} with ``href`` (the URL)
        and optionally other ``<link>`` tag attributes such as ``rel``,
        ``integrity`` and ``crossorigin``.    

- `suppress_callback_exceptions::Bool`: Default ``false``: check callbacks to
        ensure referenced IDs exist and props are valid. Set to ``true``
        if your layout is dynamic, to bypass these checks.
        
- `show_undo_redo::Bool`: Default ``false``, set to ``true`` to enable undo
        and redo buttons for stepping through the history of the app state.

- `compress::Bool`: Default ``true``, controls whether gzip is used to compress 
        files and data served by HTTP.jl when supported by the client. Set to
        ``false`` to disable compression completely.
"""
function dash(;
        external_stylesheets = ExternalSrcType[],
        external_scripts  = ExternalSrcType[],
        url_base_pathname = dash_env("url_base_pathname"),        
        requests_pathname_prefix = dash_env("requests_pathname_prefix"),
        routes_pathname_prefix = dash_env("routes_pathname_prefix"),
        assets_folder = "assets",
        assets_url_path = "assets",
        assets_ignore = "",        
        serve_locally = true,
        suppress_callback_exceptions = dash_env(Bool, "suppress_callback_exceptions", false),
        eager_loading = false, 
        meta_tags = Dict{Symbol, String}[], 
        index_string = default_index, 
        assets_external_path = dash_env("assets_external_path"), 
        include_assets_files = dash_env(Bool, "include_assets_files", true), 
        show_undo_redo = false,
        compress = true

    )
                    
        check_index_string(index_string) 
        config = DashConfig(
            external_stylesheets,
            external_scripts,
            pathname_configs(
                url_base_pathname,                
                requests_pathname_prefix,
                routes_pathname_prefix
                )...,
            assets_folder,
            lstrip(assets_url_path, '/'),
            assets_ignore,             
            serve_locally, 
            suppress_callback_exceptions, 
            eager_loading, 
            meta_tags, 
            assets_external_path, 
            include_assets_files, 
            show_undo_redo,
            compress
        )
        result = DashApp(app_root_path(), isinteractive(), config, index_string)
    return result
end