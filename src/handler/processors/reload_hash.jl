function process_reload_hash(request::HTTP.Request, state::HandlerState)
    reload_tuple = (
        reloadHash = state.reload.hash,
        hard = state.reload.hard,
        packages = keys(state.cache.resources.files),
        files = state.reload.changed_assets
    )
    state.reload.hard = false
    state.reload.changed_assets = []
    return HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON3.write(reload_tuple))

end
