using .Contexts
const CallbackContextItems = Union{Nothing, Vector{NamedTuple}}
const TriggeredParam = NamedTuple{(:prop_id, :value)}


mutable struct CallbackContext
    response::HTTP.Response
    inputs::Dict{String, Any}
    states::Dict{String, Any}
    outputs_list::Vector{Any}
    inputs_list::Vector{Any}
    states_list::Vector{Any}
    triggered::Vector{TriggeredParam}
    function CallbackContext(response, outputs_list, inputs_list, states_list, changed_props)
        input_values = inputs_list_to_dict(inputs_list)
        state_values = inputs_list_to_dict(states_list)
        triggered = TriggeredParam[(prop_id = id, value = input_values[id]) for id in changed_props]
        return new(response, input_values, state_values, outputs_list, inputs_list, states_list, triggered)
    end
end

const _callback_context_storage = TaskContextStorage()

function with_callback_context(f, context::CallbackContext)
    return with_context(f, _callback_context_storage, context)
end

"""
    callback_context()::CallbackContext

    Get context of current callback, available only inside callback processing function
"""
function callback_context()
    !has_context(_callback_context_storage) && error("callback_context() is only available from a callback processing function")
    return get_context(_callback_context_storage)
end

function inputs_list_to_dict(list::AbstractVector)
    result = Dict{String, Any}()
    _item_to_dict!.(Ref(result), list)
    return result
end

dep_id_string(id::AbstractDict) = sorted_json(id)
dep_id_string(id::AbstractString) = String(id)
function _item_to_dict!(target::Dict{String, Any}, item)
    target["$(dep_id_string(item.id)).$(item.property)"] = get(item, :value, nothing)
end

_item_to_dict!(target::Dict{String, Any}, item::AbstractVector) =  _item_to_dict!.(Ref(target), item)