using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()
app.layout = html_div(id="before-reload-content") do
    html_h3("Hot restart"),
    dcc_input(id="input", value="initial"),
    html_div(id="output")
end

callback!(app, callid"input.value => output.children") do value
    return "before reload $value"

end

run_server(app,
        dev_tools_hot_reload=true,
        dev_tools_hot_reload_interval=0.1,
        dev_tools_hot_reload_watch_interval=0.1,
        dev_tools_hot_reload_max_retry=100
)
