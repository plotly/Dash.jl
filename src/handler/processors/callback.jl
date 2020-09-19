function split_callback_id(callback_id::AbstractString)
    if startswith(callback_id, "..")
        result = []
        append!.(Ref(result), split_callback_id.(split(callback_id[3:end-2], "...", keepempty = false)))
        return result
    end
    parts = rsplit(callback_id, ".")
    return [(id = parts[1], property = parts[2])]
end

input_to_arg(input) = get(input, :value, nothing)
input_to_arg(input::Vector) = input_to_arg.(input)

make_args(inputs, state) = vcat(input_to_arg(inputs), input_to_arg(state))

res_to_vector(res) = res
res_to_vector(res::Vector) = res

function _push_to_res!(res, value, out::Vector)
    _push_to_res!.(Ref(res), value, out)
end
function _push_to_res!(res, value, out)
    !(value isa NoUpdate) && push!(res,
            dep_id_string(out.id) => Dict(
                Symbol(out.property) => DashBase.to_dash(value)
            )
        )
end

_single_element_vect(e::T) where {T} = T[e]
function process_callback_call(app, callback_id, outputs, inputs, state)
    cb = app.callbacks[callback_id]
    res = cb.func(make_args(inputs, state)...)
    (res isa NoUpdate) && throw(PreventUpdate())
    res_vector = is_multi_out(cb) ? res : _single_element_vect(res)
    validate_callback_return(outputs, res_vector, callback_id)

    response = Dict{String, Any}()

    _push_to_res!(response, res_vector, outputs)

    if length(response) == 0
        throw(PreventUpdate())
    end
    return Dict(:response=>response, :multi=>true)
end

outputs_to_vector(out::Vector) = out
outputs_to_vector(out) = [out]

function process_callback(request::HTTP.Request, state::HandlerState)
    app = state.app
    response = HTTP.Response(200, ["Content-Type" => "application/json"])

    params = JSON2.read(String(request.body))
    inputs = get(params, :inputs, [])
    state = get(params, :state, [])
    output = Symbol(params[:output])
    outputs_list = outputs_to_vector(get(params, :outputs, split_callback_id(params[:output])))
    changedProps = get(params, :changedPropIds, [])
    context = CallbackContext(response, outputs_list, inputs, state, changedProps)

    try
        cb_result = with_callback_context(context) do
            process_callback_call(app, output, outputs_list, inputs, state)
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


function validate_callback_return(outputs, value, callback_id)
    !(isa(value, Vector) || isa(value, Tuple)) &&
        throw(InvalidCallbackReturnValue(
            """
            The callback $callback_id is a multi-output.
            Expected the output type to be a list or tuple but got:
            $value
            """
        ))

    (length(value) != length(outputs)) &&
        throw(InvalidCallbackReturnValue(
            """
            Invalid number of output values for $callback_id.
            Expected $(length(outputs)), got $(length(value))
            """
        ))

    validate_return_item.(callback_id, eachindex(outputs), value, outputs)
end

function validate_return_item(callback_id, i, value::Union{<:Vector, <:Tuple}, spec::Vector)
    length(value) != length(spec) &&
        throw(InvalidCallbackReturnValue(
            """
            Invalid number of output values for $callback_id item $i.
            Expected $(length(value)), got $(length(spec))
            output spec: $spec
            output value: $value
            """
        ))
end
function validate_return_item(callback_id, i, value, spec::Vector)
    throw(InvalidCallbackReturnValue(
            """
            The callback $callback_id ouput $i is a wildcard multi-output.
            Expected the output type to be a list or tuple but got:
            $value.
            output spec: $spec
            """
        ))
end
validate_return_item(callback_id, i, value, spec) = nothing