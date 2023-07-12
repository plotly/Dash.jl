function process_dependencies(request::HTTP.Request, state::HandlerState)
    return HTTP.Response(
        200,
        ["Content-Type" => "application/json"],
        body = state.cache.dependencies_json
        )
end
