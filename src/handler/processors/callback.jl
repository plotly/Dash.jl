function _process_callback(app::DashApp, body::String)
    params = JSON2.read(body)
    output = Symbol(params[:output])
    if !haskey(app.callbacks, output)
        return []
    end
    convert_values(inputs) = map(inputs) do x
        return get(x, :value, nothing)        
    end 
    args = []
    if haskey(params, :inputs)
        append!(args, convert_values(params.inputs))        
    end    
    if haskey(params, :state)
        append!(args, convert_values(params.state))        
    end
    
    res = app.callbacks[output].func(args...)
    if !app.callbacks[output].dependencies.multi_out
        if !(res isa NoUpdate)
            return Dict(
                :response => Dict(
                    :props => Dict(
                        Symbol(app.callbacks[output].dependencies.output[1].property) => Front.to_dash(res)
                    )
                )
            )
        else
            throw(PreventUpdate())
        end
    end
    response = Dict{Symbol, Any}()
    for (ind, out) in enumerate(app.callbacks[output].dependencies.output)
        if !(res[ind] isa NoUpdate)
            push!(response, 
            Symbol(out.id) => Dict(
                Symbol(out.property) => Front.to_dash(res[ind])
            )
            )
        end
    end
    if length(response) == 0
        throw(PreventUpdate())
    end
    return Dict(:response=>response, :multi=>true)
end

function split_callback_id(callback_id::AbstractString)
    if startswith(callback_id, "..")
        result = []
        append!.(Ref(result), split_callback_id.(split(callback_id, "..", keepempty = false)))
        return result
    end
    parts = rsplit(callback_id, ".")
    return [(id = parts[1], property = parts[2])]
end

input_to_arg(input) = get(input, :value, nothing)
input_to_arg(input::Vector) = input_to_arg.(input)

make_args(inputs, state) = vcat(input_to_arg(inputs), input_to_arg(state))

function process_callback_call(cb::Callback, inputs, state)
    res = cb.func(make_args(inputs, state)...)
    (res isa NoUpdate) && throw(PreventUpdate())
    if !is_multi_out(cb)
        return Dict(
            :response => Dict(
                :props => Dict(
                    Symbol(first_output(cb).property) => Front.to_dash(res)
                )
            )
        )
    end
    response = Dict{Symbol, Any}()
    for (ind, out) in enumerate(get_output(cb))
        if !(res[ind] isa NoUpdate)
            push!(response, 
            Symbol(out.id) => Dict(
                Symbol(out.property) => Front.to_dash(res[ind])
            )
            )
        end
    end
    if length(response) == 0
        throw(PreventUpdate())
    end
    return Dict(:response=>response, :multi=>true)
end

function process_callback(request::HTTP.Request, state::HandlerState)
    app = state.app
    response = HTTP.Response(200, ["Content-Type" => "application/json"])

    params = JSON2.read(String(request.body))
    inputs = get(params, :inputs, [])
    state = get(params, :state, [])
    output = Symbol(params[:output])
    outputs_list = get(params, :outputs, split_callback_id(params[:output]))
    changedProps = get(params, :changedPropIds, [])

    context = CallbackContext(response, outputs_list, inputs, state, changedProps)

    try
        cb_result = with_callback_context(context) do
            process_callback_call(app.callbacks[output], inputs, state)
        end
        response.body = Vector{UInt8}(JSON2.write(cb_result))
    catch e                                
        if isa(e,PreventUpdate)                
            return HTTP.Response(204)                                    
        else
            rethrow(e)
        end
    end 

    return response
end