struct DashConfig
    external_stylesheets ::Vector{ExternalSrcType}
    external_scripts ::Vector{ExternalSrcType}
    url_base_pathname ::Union{String, Nothing} #TODO This looks unused
    requests_pathname_prefix ::String
    routes_pathname_prefix ::String
    assets_folder ::String
    assets_url_path ::String
    assets_ignore ::String
    serve_locally ::Bool
    suppress_callback_exceptions ::Bool
    prevent_initial_callbacks ::Bool
    eager_loading ::Bool
    meta_tags ::Vector{Dict{String, String}}
    assets_external_path ::Union{String, Nothing}
    include_assets_files ::Bool
    show_undo_redo ::Bool
    compress ::Bool
    update_title ::String
end
