module Components
import JSON2
export Component, <|, hasproperty, is_prop_available, validate

abstract type AbstractComponent end


struct Component <: AbstractComponent
    type ::String
    namespace ::String
    props ::Dict{Symbol, Any}
    available_props ::Set{Symbol}
    wildcard_props ::Set{Symbol}
end

JSON2.@format Component begin
    available_props => (exclude = true,)
    wildcard_props => (exclude = true,)
end

function <|(comp::Component, value::Any)
    comp.props["children"] = value
    return comp
end

hasproperty(c::Component, prop::Symbol) = haskey(c.props, prop)
function is_prop_available(c::Component, prop::Symbol) 
    if length(c.wildcard_props) > 0
        wild_regs = Regex("^(?<prop>$(join(c.wildcard_props, "|")))")
        if !isnothing(match(wild_regs, string(prop)))
            return true
        end
    end
    
    return prop in c.available_props
end


function _validate_childs(childs::Union{Vector, Tuple}, ids::Set{Symbol})
    for child in childs
        _validate(child, ids)
    end
end
function _validate_childs(childs::Component, ids::Set{Symbol})
    _validate(childs, ids)
end
function _validate_childs(childs, ids::Set{Symbol}) end


function _validate(comp::Component, ids::Set{Symbol})
    if haskey(comp.props, :id)
        id = Symbol(comp.props[:id])
        id in ids && error("Duplicate component id found in the initial layout: $(id)")
        push!(ids, id)
    end
    _validate_childs(get(comp.props, :children, nothing), ids)
end
function _validate(non_comp, ids::Set{Symbol}) end

function validate(comp::Component)
    _validate(comp, Set{Symbol}())
end

end