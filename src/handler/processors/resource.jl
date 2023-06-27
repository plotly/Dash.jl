function process_resource(request::HTTP.Request, state::HandlerState; namespace::AbstractString, path::AbstractString)
    (relative_path, is_fp) = parse_fingerprint_path(path)
    registered_files = state.cache.resources.files
    if !haskey(registered_files, namespace)
        #TODO Exception like in python
        return HTTP.Response(404)
    end
    namespace_files = registered_files[namespace]
    if !in(relative_path, namespace_files.files)
        #TODO Exception like in python
        return HTTP.Response(404)
    end

    filepath = joinpath(namespace_files.base_path, relative_path)

    try
        headers = Pair{String,String}[]
        file_contents = read(joinpath(namespace_files.base_path, relative_path))
        mimetype = mime_by_path(relative_path)
        !isnothing(mimetype) && push!(headers, "Content-Type" => mimetype)
        if is_fp
            push!(headers,
                "Cache-Control" => "public, max-age=31536000" # 1 year
            )
        else
            etag = bytes2hex(MD5.md5(file_contents))
            push!(headers, "ETag" => etag)
            request_etag = HTTP.header(request, "If-None-Match", "")
            request_etag == etag && return HTTP.Response(304)
        end
        return HTTP.Response(200, headers; body = file_contents)

    catch e
        !(e isa SystemError) && rethrow(e)
        #TODO print to log
        return HTTP.Response(404)
    end
end
