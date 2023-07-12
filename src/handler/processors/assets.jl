function process_assets(request::HTTP.Request, state::HandlerState; file_path::AbstractString)
    app = state.app
    filename = joinpath(get_assets_path(app), file_path)
    try
        headers = Pair{String,String}[]
        mimetype = mime_by_path(filename)
        !isnothing(mimetype) && push!(headers, "Content-Type" => mimetype)
        file_contents = read(filename)
        return HTTP.Response(200, headers;body = file_contents)
    catch
        return HTTP.Response(404)
    end

end
