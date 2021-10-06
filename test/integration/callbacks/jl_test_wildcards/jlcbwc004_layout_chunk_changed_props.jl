using Dash

app = dash()
app.layout = html_div() do
    dcc_input(id=(type = "input", index = 1), value="input-1"),
    html_div(id="container"),
    html_div(id="output-outer"),
    html_button("Show content", id="btn")
end


callback!(app, Output("container", "children"), Input("btn", "n_clicks")) do n
    if !isnothing(n) && n > 0
        return html_div(
            [
                dcc_input(id=(type = "input", index = 2), value="input-2"),
                html_div(id="output-inner"),
            ]
        )
    else
        return "No content initially"
    end
end

function trigger_info()
    triggered = callback_context().triggered
    trig_string = !isempty(triggered) ? "Truthy" : "Falsy"
    prop_ids = join(getproperty.(triggered, :prop_id), ", ")
    return "triggered is $trig_string with prop_ids $prop_ids"
end


callback!(app,
    Output("output-inner", "children"),
    Input((type = "input", index = ALL), "value"),
) do wc_inputs
    return trigger_info()
end



callback!(app,
    Output("output-outer", "children"),
    Input((type = "input", index = ALL), "value")
    )  do value
    return trigger_info()
end

run_server(app)
