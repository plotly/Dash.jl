using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()
btns = ["btn-$i" for i in 1:6]
app.layout = html_div() do
    html_div([html_button(btn, id = btn) for btn in btns]),
    html_div(id = "output")
end

callback!(app, 
    Output("output", "children"),
    [Input(btn, "n_clicks") for btn in btns]
) do args...
    isnothing(callback_context().triggered) && throw(PreventUpdate())
    trigger = callback_context().triggered[1]
    name = split(trigger.prop_id, ".")[1]
    return "Just clicked $(name) for the $(trigger.value) time!"
end

run_server(app)