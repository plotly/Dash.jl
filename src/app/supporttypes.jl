const IdProp = Tuple{Symbol, Symbol}

struct CallbackId
    state ::Vector{IdProp}
    input ::Vector{IdProp}
    output ::Vector{IdProp}    
end

CallbackId(;input,
            output,
            state = Vector{IdProp}()
            ) = CallbackId(state, input, output)


Base.convert(::Type{Vector{IdProp}}, v::IdProp) = [v]
struct ClientsideFunction
    namespace ::String
    function_name ::String
end
struct Callback
    func ::Union{Function, ClientsideFunction}
    id ::CallbackId
end

struct PreventUpdate <: Exception
    
end


struct NoUpdate
end

no_update() = NoUpdate()

const ExternalSrcType = Union{String, Dict{String, String}}
