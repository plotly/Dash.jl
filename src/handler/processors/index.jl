function process_index(request::HTTP.Request, state::HandlerState)
    get_cache(state).need_recache && rebuild_cache!(state)
    return HTTP.Response(
        200,
        ["Content-Type" => "text/html"],
        body = state.cache.index_string
        )
end
