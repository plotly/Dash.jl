
function _validate_children(children::Union{Vector, Tuple}, ids::Set{Symbol})
    for child in children
        _validate(child, ids)
    end
end
function _validate_children(children::Component, ids::Set{Symbol})
    _validate(children, ids)
end
function _validate_children(children, ids::Set{Symbol}) end


function _validate(comp::Component, ids::Set{Symbol})
    if hasproperty(comp, :id) && !isnothing(comp.id)
        id = Symbol(comp.id)
        id in ids && error("Duplicate component id found in the initial layout: $(id)")
        push!(ids, id)
    end
    hasproperty(comp, :children) && _validate_children(comp.children, ids)
end
function _validate(non_comp, ids::Set{Symbol}) end

function validate(comp::Component)
    _validate(comp, Set{Symbol}())
end
