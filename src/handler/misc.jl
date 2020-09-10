function mime_by_path(path)
    endswith(path, ".js") && return "application/javascript"
    endswith(path, ".css") && return "text/css"
    endswith(path, ".map") && return "application/json"
    return nothing
end