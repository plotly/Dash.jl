module TestComponents
using Dash
export html_div, html_a, dcc_input, dcc_graph, html_h1, html_img

function html_div(; kwargs...)
    available_props = Set(Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state])
    wild_props = Set(Symbol[Symbol("data-"), Symbol("aria-")])
    wild_regs = r"^(?<prop>data-|aria-)"

    result = Component("Div", "dash_html_components", Dict{Symbol, Any}(), available_props, Set(Symbol[Symbol("data-"), Symbol("aria-")]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "html_div"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function html_div(children::Any; kwargs...)
result = html_div(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

html_div(children_maker::Function; kwargs...) = html_div(children_maker(); kwargs...)

function html_h1(; kwargs...)
    available_props = Set(Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state])
    wild_props = Set(Symbol[Symbol("data-"), Symbol("aria-")])
    wild_regs = r"^(?<prop>data-|aria-)"

    result = Component("H1", "dash_html_components", Dict{Symbol, Any}(), available_props, Set(Symbol[Symbol("data-"), Symbol("aria-")]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "html_h1"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function html_h1(children::Any; kwargs...)
result = html_h1(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

html_h1(children_maker::Function; kwargs...) = html_h1(children_maker(); kwargs...)

function html_img(; kwargs...)
    available_props = Set(Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :alt, :crossOrigin, :height, :sizes, :src, :srcSet, :useMap, :width, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state])
    wild_props = Set(Symbol[Symbol("data-"), Symbol("aria-")])
    wild_regs = r"^(?<prop>data-|aria-)"

    result = Component("Img", "dash_html_components", Dict{Symbol, Any}(), available_props, Set(Symbol[Symbol("data-"), Symbol("aria-")]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "html_img"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function html_img(children::Any; kwargs...)
result = html_img(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

html_img(children_maker::Function; kwargs...) = html_img(children_maker(); kwargs...)

function html_a(; kwargs...)
    available_props = Set(Symbol[:children, :id, :n_clicks, :n_clicks_timestamp, :key, :role, :download, :href, :hrefLang, :media, :rel, :shape, :target, :accessKey, :className, :contentEditable, :contextMenu, :dir, :draggable, :hidden, :lang, :spellCheck, :style, :tabIndex, :title, :loading_state])
    wild_props = Set(Symbol[Symbol("data-"), Symbol("aria-")])
    wild_regs = r"^(?<prop>data-|aria-)"

    result = Component("A", "dash_html_components", Dict{Symbol, Any}(), available_props, Set(Symbol[Symbol("data-"), Symbol("aria-")]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "html_a"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function html_a(children::Any; kwargs...)
result = html_a(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

html_a(children_maker::Function; kwargs...) = html_a(children_maker(); kwargs...)



function dcc_input(; kwargs...)
    available_props = Set(Symbol[:id, :value, :style, :className, :debounce, :type, :autoComplete, :autoFocus, :disabled, :inputMode, :list, :max, :maxLength, :min, :minLength, :multiple, :name, :pattern, :placeholder, :readOnly, :required, :selectionDirection, :selectionEnd, :selectionStart, :size, :spellCheck, :step, :n_submit, :n_submit_timestamp, :n_blur, :n_blur_timestamp, :loading_state, :persistence, :persisted_props, :persistence_type])
    wild_props = Set(Symbol[])
    wild_regs = r"^(?<prop>)"

    result = Component("Input", "dash_core_components", Dict{Symbol, Any}(), available_props, Set(Symbol[]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "dcc_input"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function dcc_input(children::Any; kwargs...)
result = dcc_input(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

dcc_input(children_maker::Function; kwargs...) = dcc_input(children_maker(); kwargs...)

function dcc_graph(; kwargs...)
    available_props = Set(Symbol[:id, :responsive, :clickData, :clickAnnotationData, :hoverData, :clear_on_unhover, :selectedData, :relayoutData, :extendData, :restyleData, :figure, :style, :className, :animate, :animation_options, :config, :loading_state])
    wild_props = Set(Symbol[])
    wild_regs = r"^(?<prop>)"

    result = Component("Graph", "dash_core_components", Dict{Symbol, Any}(), available_props, Set(Symbol[]))

    for (prop, value) = pairs(kwargs)
        m = match(wild_regs, string(prop))
        if (length(wild_props) == 0 || isnothing(m)) && !(prop in available_props)
            throw(ArgumentError("Invalid property $(string(prop)) for component " * "dcc_graph"))
        end

        push!(result.props, prop => Front.to_dash(value))
    end

return result
end

function dcc_graph(children::Any; kwargs...)
result = dcc_graph(;kwargs...)
push!(result.props, :children => Front.to_dash(children))
return result
end

dcc_graph(children_maker::Function; kwargs...) = dcc_graph(children_maker(); kwargs...)

end
