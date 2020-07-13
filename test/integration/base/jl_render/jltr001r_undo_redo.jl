using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash(show_undo_redo=true)

app.layout = html_div() do
 dcc_input(id="a"),
 html_div(id="b") 
end

callback!(app, 
    Output("b","children"),
    Input("a","value")
    ) do inputValue
    return inputValue
end

run_server(app)