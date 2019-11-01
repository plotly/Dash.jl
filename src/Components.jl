module Components
import JSON2
export Component, ComponentContainer, <|

abstract type AbstractComponent end


struct Component <: AbstractComponent
    type ::String
    namespace ::String
    props ::Dict{Symbol, Any}
    available_props ::Set{Any}
end

JSON2.@format Component begin
    #=type => (name = "type")
    namespace => (name = "namespace")
    props => (name = "props")=#
    available_props => (exclude = true,)
end

function <|(cont::Component, value::Any)
    cont.props["children"] = value
    return cont
end

function is_valid_idprop(comp::Component, idprop::Tuple{Symbol, Symbol})::Bool
    if haskey(comp.props, :id) && Symbol(comp.props[:id]) == idprop[1]
        return idprop[2] in comp.available_props        
    end

    if haskey(comp.props, :children)
        for child in comp.props[:children]
            if is_valid_idprop(child, idprop)
                return true
            end
        end
    end
    return false
end
end