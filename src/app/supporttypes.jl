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


struct CallbackDeps
    output ::Vector{Output}
    input ::Vector{Input}
    state ::Vector{State}
    multi_out::Bool
    CallbackDeps(output, input, state, multi_out) = new(output, input, state, multi_out)
    CallbackDeps(output::Output, input, state = State[]) = new(output, input, state, false)
    CallbackDeps(output::Vector{Output}, input, state = State[]) = new(output, input, state, true)
end

Base.convert(::Type{Vector{T}}, v::T) where {T<:Dependency}= [v]

struct ClientsideFunction
    namespace ::String
    function_name ::String
end
struct Callback
    func ::Union{Function, ClientsideFunction}
    dependencies ::CallbackDeps
end

is_multi_out(cb::Callback) = cb.dependencies.multi_out == true
get_output(cb::Callback) = cb.dependencies.output
get_output(cb::Callback, i) = cb.dependencies.output[i]
first_output(cb::Callback) = first(cb.dependencies.output)

struct PreventUpdate <: Exception
    
end


struct NoUpdate
end

no_update() = NoUpdate()

const ExternalSrcType = Union{String, Dict{String, String}}
