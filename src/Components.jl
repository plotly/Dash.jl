module Components
export Component, ComponentContainer, <|

abstract type AbstractComponent end


struct Component <: AbstractComponent
    type ::String
    namespace ::String
    props ::Dict{String, Any}
end

function <|(cont::Component, value::Any)
    cont.props["children"] = value
    return cont
end

end