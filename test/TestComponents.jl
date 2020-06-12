module TestComponents
using DashBase
export html_div, html_a, dcc_input, dcc_graph, html_h1, html_img

function html_div(; kwargs...)
    available_props = Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state]
    wild_props = Symbol[Symbol("data-"), Symbol("aria-")]

    return Component("html_div", "Div", "dash_html_components", available_props, wild_props; kwargs...)

end

html_div(children::Any; kwargs...) = html_div(;kwargs..., children = children)

html_div(children_maker::Function; kwargs...) = html_div(children_maker(); kwargs...)

function html_h1(; kwargs...)
    available_props = Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state]
    wild_props = Symbol[Symbol("data-"), Symbol("aria-")]

    return Component("html_h1", "H1", "dash_html_components", available_props, wild_props; kwargs...)

end

html_h1(children::Any; kwargs...) = html_h1(;kwargs..., children = children)

html_h1(children_maker::Function; kwargs...) = html_h1(children_maker(); kwargs...)

function html_img(; kwargs...)
    available_props = Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :alt, :crossOrigin, :height, :sizes, :src, :srcSet, :useMap, :width, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state]
    wild_props = Symbol[Symbol("data-"), Symbol("aria-")]

    return Component("html_h1", "Img", "dash_html_components", available_props, wild_props; kwargs...)
end

html_img(children::Any; kwargs...) = html_img(;kwargs..., children = children)

html_img(children_maker::Function; kwargs...) = html_img(children_maker(); kwargs...)

function html_a(; kwargs...)
    available_props = Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :download, :href, :hrefLang, :media, :rel, :shape, :target, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state]
    wild_props = Symbol[Symbol("data-"), Symbol("aria-")]

    return Component("html_a", "A", "dash_html_components", available_props, wild_props; kwargs...)
end

html_a(children::Any; kwargs...) = html_a(;kwargs..., children = children)

html_a(children_maker::Function; kwargs...) = html_a(children_maker(); kwargs...)



function dcc_input(; kwargs...)
    available_props = Symbol[:id, :value, :style, :className, :debounce, :type, :autoComplete, :autoFocus, :disabled, :inputMode, :list, :max, :maxLength, :min, :minLength, :multiple, :name, :pattern, :placeholder, :readOnly, :required, :selectionDirection, :selectionEnd, :selectionStart, :size, :spellCheck, :step, :n_submit, :n_submit_timestamp, :n_blur, :n_blur_timestamp, :loading_state, :persistence, :persisted_props, :persistence_type]
    wild_props = Symbol[]

    return Component("dcc_input", "Input", "dash_core_components", available_props, wild_props; kwargs...)
end

dcc_input(children::Any; kwargs...) = dcc_input(;kwargs..., children = children)

dcc_input(children_maker::Function; kwargs...) = dcc_input(children_maker(); kwargs...)

function dcc_graph(; kwargs...)
    available_props = Symbol[:id, :responsive, :clickData, :clickAnnotationData, :hoverData, :clear_on_unhover, :selectedData, :relayoutData, :extendData, :restyleData, :figure, :style, :className, :animate, :animation_options, :config, :loading_state]
    wild_props = Symbol[]

    return Component("dcc_graph", "Graph", "dash_core_components", available_props, wild_props; kwargs...)
end

dcc_graph(children::Any; kwargs...) = dcc_graph(kwargs..., children = children)

dcc_graph(children_maker::Function; kwargs...) = dcc_graph(children_maker(); kwargs...)

end