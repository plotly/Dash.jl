using MacroTools
macro prop(e)
    if e.head != :(=) || length(e.args) != 2 || !(e.args[1] isa AbstractString) 
        error("expected AbstractString = value")
    end
    keys = Symbol[Symbol(e.args[1])] 
    esc(:(NamedTuple{Tuple($(keys))}(Tuple(Any[$(e.args[2])]))...))
end