# AUTO GENERATED FILE - DO NOT EDIT

export dugc_pagemenu

"""
    dugc_pagemenu(;kwargs...)

A PageMenu component.

Keyword arguments:
- `id` (String; optional): The ID used to identify this component in Dash callbacks.
- `dummy` (String; optional)
- `dummy2` (String; optional)
- `loading_state` (optional): Object that holds the loading state object coming from dash-renderer. loading_state has the following type: lists containing elements 'is_loading', 'prop_name', 'component_name'.
Those elements have the following types:
  - `is_loading` (Bool; optional): Determines if the component is loading or not
  - `prop_name` (String; optional): Holds which property is loading
  - `component_name` (String; optional): Holds the name of the component that is loading
"""
function dugc_pagemenu(; kwargs...)
        available_props = Symbol[:id, :dummy, :dummy2, :loading_state]
        wild_props = Symbol[]
        return Component("dugc_pagemenu", "PageMenu", "dash_user_guide_components", available_props, wild_props; kwargs...)
end

