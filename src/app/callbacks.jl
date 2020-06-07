dependency_string(dep::Dependency) = "$(dep.id).$(dep.property)"



function output_string(deps::CallbackDeps)
    if deps.multi_out
        return ".." *
        join(dependency_string.(deps.output), "...") *
        ".."
    end
    return dependency_string(deps.output[1])
end


"""
    function callback!(func::Union{Function, ClientsideFunction, String},
        app::DashApp,
        output::Union{Vector{Output}, Output},
        input::Union{Vector{Input}, Input},
        state::Union{Vector{State}, State} = []
        )

Create a callback that updates the output by calling function `func`. 

# Examples

```julia
app = dash() do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        dcc_input(id="graphTitle2", value="Let's Dance!", type = "text"),
        html_div(id="outputID"),
        html_div(id="outputID2")

    end
end
callback!(app, [Output("outputID2", "children"), Output("outputID", "children")],
    Input("graphTitle", "value"),
    State("graphTitle", "type")
    ) do inputValue, stateType
    return (stateType * "..." * inputValue, inputValue)
end
```
"""
function callback!(func::Union{Function, ClientsideFunction, String},
     app::DashApp,
     output::Union{Vector{Output}, Output},
     input::Union{Vector{Input}, Input},
     state::Union{Vector{State}, State} = State[]
     )
     return _callback!(func, app, CallbackDeps(output, input, state))
end

"""
    function callback!(func::Union{Function, ClientsideFunction, String},
        app::DashApp,
        deps...
        )

Create a callback that updates the output by calling function `func`. 
"Flat" version of `callback!` function, `deps` must be ``Output..., Input...[,State...]``

# Examples

```julia
app = dash() do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        dcc_input(id="graphTitle2", value="Let's Dance!", type = "text"),
        html_div(id="outputID"),
        html_div(id="outputID2")

    end
end
callback!(app, 
    Output("outputID2", "children"),
    Output("outputID", "children"),
    Input("graphTitle", "value"),
    State("graphTitle", "type")
    ) do  inputValue, stateType
    return (stateType * "..." * inputValue, inputValue)
end
```
"""
function callback!(func::Union{Function, ClientsideFunction, String},
     app::DashApp,
     deps::Dependency...
     )
     output = Output[]
     input = Input[]
     state = State[]
     _process_callback_args(deps, (output, input, state))
     return _callback!(func, app, CallbackDeps(output, input, state, length(output) > 1))
end

function _process_callback_args(args::Tuple{T, Vararg}, dest::Tuple{Vector{T}, Vararg}) where {T}
    push!(dest[1], args[1])
    _process_callback_args(Base.tail(args), dest)
end
function _process_callback_args(args::Tuple{}, dest::Tuple{Vector{T}, Vararg}) where {T}
end
function _process_callback_args(args::Tuple, dest::Tuple{Vector{T}, Vararg}) where {T}
    _process_callback_args(args, Base.tail(dest))
end
function _process_callback_args(args::Tuple, dest::Tuple{}) 
    error("The callback method must received first all Outputs, then all Inputs, then all States")
end
function _process_callback_args(args::Tuple{}, dest::Tuple{}) 
end


function _callback!(func::Union{Function, ClientsideFunction, String}, app::DashApp, deps::CallbackDeps)    
    
    check_callback(func, app, deps)
    
    out_symbol = Symbol(output_string(deps))
    callback_func = make_callback_func!(app, func, deps)      
    push!(app.callbacks, out_symbol => Callback(callback_func, deps))
end


make_callback_func!(app::DashApp, func::Union{Function, ClientsideFunction}, deps::CallbackDeps) = func

function make_callback_func!(app::DashApp, func::String, deps::CallbackDeps)
    first_output = first(deps.output)
    namespace = replace("_dashprivate_$(first_output.id)", "\""=>"\\\"")
    function_name = replace("$(first_output.property)", "\""=>"\\\"")

    function_string = """
            var clientside = window.dash_clientside = window.dash_clientside || {};
            var ns = clientside["$namespace"] = clientside["$namespace"] || {};
            ns["$function_name"] = $func;
    """
    push!(app.inline_scripts, function_string)
    return ClientsideFunction(namespace, function_name)
end

function check_callback(func, app::DashApp, deps::CallbackDeps)


    isempty(deps.output) && error("The callback method requires that one or more properly formatted outputs are passed.")
    isempty(deps.input) && error("The callback method requires that one or more properly formatted inputs are passed.")

    length(deps.output) != length(unique(deps.output)) && error("One or more callback outputs have been duplicated; please confirm that all outputs are unique.")

    for out in deps.output
        if any(x->out in x.dependencies.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    args_count = length(deps.state) + length(deps.input)

    check_callback_func(func, args_count)

    for id_prop in deps.input
        id_prop in deps.output && error("Circular input and output arguments were found. Please verify that callback outputs are not also input arguments.")
    end
end

function check_callback_func(func::Function, args_count)
    !hasmethod(func, NTuple{args_count, Any}) && error("The arguments of the specified callback function do not align with the currently defined callback; please ensure that the arguments to `func` are properly defined.")
end
function check_callback_func(func, args_count)
end