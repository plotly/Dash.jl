# AUTO GENERATED FILE - DO NOT EDIT

export dugc_sidebar

"""
    dugc_sidebar(;kwargs...)
    dugc_sidebar(children::Any;kwargs...)
    dugc_sidebar(children_maker::Function;kwargs...)


A Sidebar component.

Keyword arguments:
- `children` (a list of or a singular dash component, string or number; optional): Custom content in the "no results found" panel
- `id` (String; optional): The ID used to identify this component in Dash callbacks.
- `urls` (Array; optional): URLs
- `depth` (Real; optional): depth
"""
function dugc_sidebar(; kwargs...)
        available_props = Symbol[:children, :id, :urls, :depth]
        wild_props = Symbol[]
        return Component("dugc_sidebar", "Sidebar", "dash_user_guide_components", available_props, wild_props; kwargs...)
end

dugc_sidebar(children::Any; kwargs...) = dugc_sidebar(;kwargs..., children = children)
dugc_sidebar(children_maker::Function; kwargs...) = dugc_sidebar(children_maker(); kwargs...)

