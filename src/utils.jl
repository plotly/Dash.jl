using MacroTools
macro wildprop(e)
    if e.head != :(=) || length(e.args) != 2 || !(e.args[1] isa AbstractString) 
        error("expected AbstractString = value")
    end
    keys = Symbol[Symbol(e.args[1])] 
    esc(:(NamedTuple{Tuple($(keys))}(Tuple(Any[$(e.args[2])]))...))
end

function parse_props(s)
    function make_prop(part) 
        m = match(r"^(?<id>[A-Za-z]+[\w\-\:\.]*)\.(?<prop>[A-Za-z]+[\w\-\:\.]*)$", strip(part))
        if isnothing(m)
            error("expected <id>.<property>[,<id>.<property>...] in $(part)")
        end
        
        return (Symbol(m[:id]), Symbol(m[:prop]))
    end    

    props_parts = split(s, ",", keepempty = false)
    
    return map(props_parts) do part
        return make_prop(part)
    end    
end

"""
    @callid_str"

Macro for crating Dash CallbackId.
Parse string in form "[{State1[, ...]}] Input1[, ...] => Output1[, ...]"

#Examples
```julia
    id1 = callid"{inputDiv.children} input.value => output1.value, output2.value"
```
"""
macro callid_str(s)
    rex = r"(\{(?<state>.*)\})?(?<input>.*)=>(?<output>.*)"ms
    m = match(rex, s)
    if isnothing(m)
        error("expected {state} input => output")
    end
    input = parse_props(strip(m[:input]))
    output = parse_props(strip(m[:output]))
    state = isnothing(m[:state]) ? Vector{IdProp}() : parse_props(strip(m[:state]))
    return CallbackId(state, input, output) 
end