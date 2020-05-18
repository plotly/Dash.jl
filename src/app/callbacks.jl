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
    callback!(func::Function, app::Dash, id::CallbackId)

Create a callback that updates the output by calling function `func`.


# Examples

```julia
app = dash) do
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

Alternatively, the `callid` string macro is also available when passing `input`, `state`, and `output` arguments to `callback!`: 

```julia
callback!(app, callid"{graphTitle.type} graphTitle.value => outputID.children, outputID2.children") do stateType, inputValue

    return (stateType * "..." * inputValue, inputValue)
end
```


"""
function callback!(func::Function, app::DashApp, id::CallbackId)    
    
    check_callback(func, app, id)
    
    out_symbol = Symbol(output_string(id))
        
    push!(app.callbacks, out_symbol => Callback(func, id))
end


function check_callback(func::Function, app::DashApp, id::CallbackId)

    

    isempty(id.input) && error("The callback method requires that one or more properly formatted inputs are passed.")

    length(id.output) != length(unique(id.output)) && error("One or more callback outputs have been duplicated; please confirm that all outputs are unique.")

    for out in id.output
        if any(x->out in x.id.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    args_count = length(id.state) + length(id.input)

    !hasmethod(func, NTuple{args_count, Any}) && error("The arguments of the specified callback function do not align with the currently defined callback; please ensure that the arguments to `func` are properly defined.")

    for id_prop in id.input
        id_prop in id.output && error("Circular input and output arguments were found. Please verify that callback outputs are not also input arguments.")
    end
end
