using Dash
using DashHtmlComponents
using DashCoreComponents
function todo_app(content_callback)
    app = dash()

    content = html_div() do
        html_div("Dash To-Do list"),
        dcc_input(id="new-item"),
        html_button("Add", id="add"),
        html_button("Clear Done", id="clear-done"),
        html_div(id="list-container"),
        html_hr(),
        html_div(id="totals")
    end

    if content_callback
        app.layout = html_div() do
            html_div(id="content"),
            dcc_location(id="url")
        end
        callback!(app, Output("content", "children"), Input("url", "pathname")) do v
            return content
        end
    else
        app.layout = content
    end

    style_todo = Dict("display" => "inline", "margin" =>"10px")
    style_done = Dict("textDecoration" => "line-through", "color" => "#888")
    merge!(style_done, style_todo)

    callback!(app, Output("list-container", "children"), Output("new-item", "value"),
            Input("add", "n_clicks"),
            Input("new-item", "n_submit"),
            Input("clear-done", "n_clicks"),
            State("new-item", "value"),
            State((item = ALL,), "children"),
            State((item = ALL, action = "done"), "value"),
    ) do add, add2, clear, new_item, items, items_done
        triggered = [t.prop_id for t in callback_context().triggered]
        adding = any((id)->id in ("add.n_clicks", "new-item.n_submit"), triggered)
        clearing = any((id)->id == "clear-done.n_clicks", triggered)
        
        new_spec = Vector{Any}()

        push!.(Ref(new_spec),
            Iterators.filter(zip(items, items_done)) do (text, done)
                return !(clearing && !isempty(done))
            end
        ) 

        adding && push!(new_spec, (new_item, []))
        new_list = [
            html_div(style = (clear = "both",)) do
                dcc_checklist(
                    id=(item = i, action = "done"),
                    options=[(label = "", value = "done")],
                    value=done,
                    style=(display = "inline",),
                ),
                html_div(
                    text, id=(item = i,), style= !isempty(done) ? style_done : style_todo
                ),
                html_div(id=(item = i, preceding = true), style=style_todo)
            end
            for (i, (text, done)) in enumerate(new_spec)
        ]
        return [new_list, adding ? "" : new_item]
    end

    callback!(app,
        Output((item = MATCH,), "style"),
        Input((item = MATCH, action = "done"), "value")
    ) do done
        println(done)
        return !isempty(done) ? style_done : style_todo
    end

    callback!(app,
        Output((item = MATCH, preceding = true), "children"),        
        Input((item = ALLSMALLER, action = "done"), "value"),
        Input((item = MATCH, action = "done"), "value"),
        
    ) do done_before, this_done
        !isempty(this_done) && return ""
        all_before = length(done_before)
        done_before = count((d)->!isempty(d), done_before)
        out = "$(done_before) of $(all_before) preceding items are done"
        (all_before == done_before) && (out *= " DO THIS NEXT!")
        return out
    end

    callback!(app,
        Output("totals", "children"), Input((item = ALL, action = "done"), "value")
    ) do done        
        count_all = length(done)
        count_done = count((d)->!isempty(d), done)
        result = "$(count_done) of $(count_all) items completed"
        (count_all > 0) && (result *= " - $(floor(Int, 100 * count_done / count_all))%")            
        
        return result
    end
    
    return app
   
end