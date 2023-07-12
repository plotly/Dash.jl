function process_default_favicon(request::HTTP.Request, state::HandlerState)
    ico_contents = read(
        joinpath(ROOT_PATH, "src", "favicon.ico")
    )
    return HTTP.Response(
        200,
        ["Content-Type" => "image/x-icon"],
        body = ico_contents
        )
end
