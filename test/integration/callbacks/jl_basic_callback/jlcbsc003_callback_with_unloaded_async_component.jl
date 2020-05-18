using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_tabs() do
        dcc_tab() do
            html_button(id="btn", children = "Update Input"),
            html_div(id = "output", children = ["Hello"])
        end,
        dcc_tab() do
            html_div("test")
        end
    end
end

callback!(app, callid"btn.n_clicks => output.children") do n_clicks
    isnothing(n_clicks) && throw(PreventUpdate())
    return "Bye"
end

run_server(app)
