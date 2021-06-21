using Dash

app = dash()
app.layout = html_div(id="before-reload-content") do
    html_h3("Hot restart"),
    dcc_input(id="input", value="initial"),
    html_div(id="output")
end

callback!(app, Output("output","children"), Input("input","value")) do value
    return "before reload $value"

end

run_server(app,
        dev_tools_hot_reload=true,
        dev_tools_hot_reload_interval=0.1,
        dev_tools_hot_reload_watch_interval=0.1,
        dev_tools_hot_reload_max_retry=100
)
