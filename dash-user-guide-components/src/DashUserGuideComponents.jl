
module DashUserGuideComponents
using Dash

const resources_path = realpath(joinpath( @__DIR__, "..", "deps"))
const version = "0.0.4"

include("dugc_pagemenu.jl")
include("dugc_sidebar.jl")

function __init__()
    DashBase.register_package(
        DashBase.ResourcePkg(
            "dash_user_guide_components",
            resources_path,
            version = version,
            [
                DashBase.Resource(
    relative_package_path = "dash_user_guide_components.min.js",
    external_url = "https://unpkg.com/dash_user_guide_components@0.0.4/dash_user_guide_components/dash_user_guide_components.min.js",
    dynamic = nothing,
    async = nothing,
    type = :js
),
DashBase.Resource(
    relative_package_path = "dash_user_guide_components.min.js.map",
    external_url = "https://unpkg.com/dash_user_guide_components@0.0.4/dash_user_guide_components/dash_user_guide_components.min.js.map",
    dynamic = true,
    async = nothing,
    type = :js
)
            ]
        )

    )
end
end
