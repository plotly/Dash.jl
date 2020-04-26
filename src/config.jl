function absolute_assets_path(assets_path::AbstractString)
    #TODO app path, enviroment variable etc..
    return joinpath(pwd(), assets_path)
end

function pathname_configs(url_base_pathname, requests_pathname_prefix, routes_pathname_prefix)
    
    raise_error = (s) -> error("""
    $s This is ambiguous.
    To fix this, set `routes_pathname_prefix` instead of `url_base_pathname`.

    Note that `requests_pathname_prefix` is the prefix for the AJAX calls that
    originate from the client (the web browser) and `routes_pathname_prefix` is
    the prefix for the API routes on the backend (as defined within HTTP.jl).
    `url_base_pathname` will set `requests_pathname_prefix` and
    `routes_pathname_prefix` to the same value.
    If you need these to be different values then you should set
    `requests_pathname_prefix` and `routes_pathname_prefix`,
    not `url_base_pathname`.
    """)


    if !isnothing(url_base_pathname) && !isnothing(requests_pathname_prefix)
        raise_error("You supplied `url_base_pathname` and `requests_pathname_prefix`")
    end

    if !isnothing(url_base_pathname) && !isnothing(routes_pathname_prefix)
        raise_error("You supplied `url_base_pathname` and `routes_pathname_prefix`")
    end

    if !isnothing(url_base_pathname) && isnothing(routes_pathname_prefix)
        routes_pathname_prefix = url_base_pathname
    elseif isnothing(routes_pathname_prefix)
        routes_pathname_prefix = "/"
    end

    !startswith(routes_pathname_prefix, "/") && error("routes_pathname_prefix` needs to start with `/`")
    !endswith(routes_pathname_prefix, "/") && error("routes_pathname_prefix` needs to end with `/`")
    
    if isnothing(requests_pathname_prefix)
        requests_pathname_prefix = routes_pathname_prefix
    end

    !startswith(requests_pathname_prefix, "/") &&
             error("requests_pathname_prefix` needs to start with `/`")
    !endswith(requests_pathname_prefix, routes_pathname_prefix) &&
             error("requests_pathname_prefix` needs to end with `routes_pathname_prefix`")
    
    return (url_base_pathname, requests_pathname_prefix, routes_pathname_prefix)
end
