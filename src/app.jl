const IdProp = Tuple{Symbol, Symbol}

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



struct CallbackId
    state ::Vector{IdProp}
    input ::Vector{IdProp}
    output ::Vector{IdProp}    
end

CallbackId(;input ::Union{Vector{IdProp}, IdProp},
            output ::Union{Vector{IdProp}, IdProp},
            state ::Union{Vector{IdProp}, IdProp} = Vector{IdProp}()
            ) = CallbackId(state, input, output)


Base.convert(::Type{Vector{IdProp}}, v::IdProp) = [v]

struct Callback
    func ::Function
    id ::CallbackId
    pass_changed_props ::Bool
end

struct PreventUpdate <: Exception
    
end


struct NoUpdate
end

no_update() = NoUpdate()

mutable struct Layout
    component::Union{Nothing, Component}
end

const ExternalSrcType = Union{String, Dict{String, String}}

struct DashConfig
    external_stylesheets ::Vector{ExternalSrcType}
    external_scripts ::Vector{ExternalSrcType}
    url_base_pathname ::Union{String, Nothing} #TODO This looks unused
    requests_pathname_prefix ::String
    routes_pathname_prefix ::String
    assets_folder ::String
    assets_url_path ::String
    assets_ignore ::String    
    serve_locally ::Bool
    suppress_callback_exceptions ::Bool
    eager_loading ::Bool
    meta_tags ::Vector{Dict{String, String}} 
    index_string ::Union{String, Nothing}
    assets_external_path ::Union{String, Nothing}
    include_assets_files ::Bool
    show_undo_redo ::Bool
    compress ::Bool
end

"""
    struct DashApp <: Any

Representation of Dash application.

Not meant to be constructed directly, use `dash` function instead.
"""
mutable struct DashApp
    name ::String
    config ::DashConfig
    layout ::Union{Nothing, Component}
    devtools ::DevTools
    callbacks ::Dict{Symbol, Callback}
    
    DashApp(name::String, config::DashConfig) = new(name, config, nothing, DevTools(dash_env(Bool, "debug", false)), Dict{Symbol, Callback}())
    
end

function set_layout!(app::DashApp, component::Component)
    app.layout = component
end

get_layout(app::DashApp) = app.component

function set_debug!(app::DashApp; debug = nothing, ui = nothing,
            props_check = nothing,
            serve_dev_bundles = nothing,
            hot_reload = nothing,
            hot_reload_interval = nothing,
            hot_reload_watch_interval = nothing,
            hot_reload_max_retry = nothing,
            silence_routes_logging = nothing,
            prune_errors = nothing)
    @env_default!(debug, Bool, true)
    app.devtools = DevTools(
        debug;
        props_check = props_check,
        serve_dev_bundles = serve_dev_bundles,
        hot_reload = hot_reload,
        hot_reload_interval = hot_reload_interval,
        hot_reload_watch_interval = hot_reload_watch_interval,
        hot_reload_max_retry = hot_reload_max_retry,
        silence_routes_logging = silence_routes_logging,
        prune_errors = prune_errors
    )
end

get_devsetting(app::DashApp, name::Symbol) = getproperty(app.devtools, name)

get_setting(app::DashApp, name::Symbol) = getproperty(app.config, name)


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
- `name::String` - The name of your application
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
function dash(name::String = dash_env("dash_name", "");
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
                    
        config = DashConfig(
            external_stylesheets,
            external_scripts,
            pathname_configs(
                url_base_pathname,                
                requests_pathname_prefix,
                routes_pathname_prefix
                )...,
            absolute_assets_path(assets_folder),
            lstrip(assets_url_path, '/'),
            assets_ignore,             
            serve_locally, 
            suppress_callback_exceptions, 
            eager_loading, 
            meta_tags, 
            index_string, 
            assets_external_path, 
            include_assets_files, 
            show_undo_redo,
            compress
        )
        
        result = DashApp(name, config)
    return result
end

function dash(layout_maker ::Function, name::String = dash_env("dash_name", "");
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
    result = dash(name,
        external_stylesheets=external_stylesheets,
        external_scripts=external_scripts,
        url_base_pathname=url_base_pathname,
        requests_pathname_prefix = requests_pathname_prefix,
        routes_pathname_prefix = routes_pathname_prefix,
        assets_folder = assets_folder,
        assets_url_path = assets_url_path, 
        assets_ignore = assets_ignore,        
        serve_locally = serve_locally,
        suppress_callback_exceptions = suppress_callback_exceptions,
        eager_loading = eager_loading,
        meta_tags = meta_tags,
        index_string = index_string,
        assets_external_path = assets_external_path,
        include_assets_files = include_assets_files,
        show_undo_redo = show_undo_redo,
        compress = compress
        )
    set_layout!(result, layout_maker())
    return result
end



idprop_string(idprop::IdProp) = "$(idprop[1]).$(idprop[2])"


function output_string(id::CallbackId)
    if length(id.output) == 1
        return idprop_string(id.output[1])
    end
    return ".." *
    join(map(idprop_string, id.output), "...") *
    ".."
end

"""
    callback!(func::Function, app::Dash, id::CallbackId; pass_changed_props = false)

Create a callback that updates the output by calling function `func`.

If `pass_changed_props` is true then the first argument of callback is an array of changed properties

# Examples

```julia
app = dash("Test") do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        dcc_input(id="graphTitle2", value="Let's Dance!", type = "text"),
        html_div(id="outputID"),
        html_div(id="outputID2")

    end
end
callback!(app, CallbackId(
    state = [(:graphTitle, :type)],
    input = [(:graphTitle, :value)],
    output = [(:outputID, :children), (:outputID2, :children)]
    )
    ) do stateType, inputValue
    return (stateType * "..." * inputValue, inputValue)
end
```

You can use macro `callid` string macro for make CallbackId : 

```julia
callback!(app, callid"{graphTitle.type} graphTitle.value => outputID.children, outputID2.children") do stateType, inputValue

    return (stateType * "..." * inputValue, inputValue)
end
```

Using `changed_props`

```julia
callback!(app, callid"graphTitle.value, graphTitle2.value => outputID.children", pass_changed_props = true) do changed, input1, input2
    if "graphTitle.value" in changed
        return input1
    else
        return input2
    end
end
```

"""
function callback!(func::Function, app::DashApp, id::CallbackId; pass_changed_props = false)    
    
    check_callback(func, app, id, pass_changed_props)
    
    out_symbol = Symbol(output_string(id))
        
    push!(app.callbacks, out_symbol => Callback(func, id, pass_changed_props))
end


function check_callback(func::Function, app::DashApp, id::CallbackId, pass_changed_props)

    

    isempty(id.input) && error("The callback method requires that one or more properly formatted inputs are passed.")

    length(id.output) != length(unique(id.output)) && error("One or more callback outputs have been duplicated; please confirm that all outputs are unique.")

    for out in id.output
        if any(x->out in x.id.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    args_count = length(id.state) + length(id.input)
    pass_changed_props && (args_count+=1)

    !hasmethod(func, NTuple{args_count, Any}) && error("Callback function don't have method with proper arguments")

    for id_prop in id.input
        id_prop in id.output && error("Circular input and output arguments were found. Please verify that callback outputs are not also input arguments.")
    end
end
