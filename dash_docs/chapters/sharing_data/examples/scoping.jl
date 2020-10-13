using Dash, DashHtmlComponents, DashCoreComponents, DataFrames

df8 = DataFrame(a = [1, 2, 3],
               b = [4, 1, 4],
               c = ["x", "y", "z"])
s
app = dash()

app.layout = html_div() do
    dcc_dropdown(id="dropdown-7",
                 options = [
                    (label = i, value = i) for i in df8[:, "c"]
                 ],
                 value="x"
    ),
    html_div(id="output-7")
end

callback!(
    app,
    Output("output-7", "children"),
    Input("dropdown-7", "value"),
) do value
    df8f = df8[df8.c .== value, :]
    return length(df8f[1, :])
end

run_server(app, "0.0.0.0", debug=true)
