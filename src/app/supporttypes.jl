struct TraitInput end
struct TraitOutput end
struct TraitState end

struct Dependency{T}
    id ::String
    property ::String
end

const Input = Dependency{TraitInput}
const State = Dependency{TraitState}
const Output = Dependency{TraitOutput}

const IdProp = Tuple{Symbol, Symbol}



struct CallbackDeps
    output ::Vector{Output}    
    input ::Vector{Input}
    state ::Vector{State}
    CallbackDeps(output, input, state = State[]) = new(output, input, state)
    CallbackDeps(;output, input, state = State[]) = new(output, input, state)
end

Base.convert(::Type{Vector{T}}, v::T) where {T <: Dependency} = [v]

struct ClientsideFunction
    namespace ::String
    function_name ::String
end
struct Callback
    func ::Union{Function, ClientsideFunction}
    dependencies ::CallbackDeps
end

struct PreventUpdate <: Exception
    
end


struct NoUpdate
end

no_update() = NoUpdate()

const ExternalSrcType = Union{String, Dict{String, String}}
