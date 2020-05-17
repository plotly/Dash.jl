using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    html_p(id="tcid", children = "Hello Disable UI"),
    dcc_graph(id="broken", animate = 3)
end

run_server(app, debug = true,
    dev_tools_hot_reload = false, dev_tools_ui = false
)