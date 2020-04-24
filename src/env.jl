dash_env_key(name::String) =  "DASH_" * uppercase(name)

dash_env(name::String, default = nothing) = get(ENV, dash_env_key(name), default)

function dash_env(t::Type{T}, name::String, default = nothing) where {T<:Number}    
    key = dash_env_key(name)
    !haskey(ENV, key) && return default    
    return parse(T, lowercase(get(ENV, key, "")))
end

dash_env(t::Type{String}, name::String, default = nothing) = dash_env(name, default)


macro env_default!(name, type = String, default = nothing)
    name_str = string(name)
    return esc(:(
        $name = isnothing($name) ? 
        dash_env($type, $name_str, $default)
        :
        $name
        ))
end