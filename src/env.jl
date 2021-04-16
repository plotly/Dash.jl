const DASH_ENV_PREFIX = "DASH_"

dash_env_key(name::String; prefix = DASH_ENV_PREFIX) =  prefix * uppercase(name)

dash_env(name::String, default = nothing; prefix = DASH_ENV_PREFIX) = get(ENV, dash_env_key(name, prefix = prefix), default)

function dash_env(t::Type{T}, name::String, default = nothing; prefix = DASH_ENV_PREFIX) where {T<:Number}
    key = dash_env_key(name, prefix = prefix)
    !haskey(ENV, key) && return default
    return parse(T, lowercase(get(ENV, key, "")))
end

dash_env(t::Type{String}, name::String, default = nothing; prefix = DASH_ENV_PREFIX) = dash_env(name, default, prefix = prefix)


macro env_default!(name, type = String, default = nothing)
    name_str = string(name)
    return esc(:(
        $name = isnothing($name) ?
        dash_env($type, $name_str, $default)
        :
        $name
        ))
end
