using Dash, DashHtmlComponents, DashCoreComponents, DataFrames


df7 = DataFrame(a = [1, 2, 3],
               b = [4, 1, 4],
               c = ["x", "y", "z"])

app = dash()

app.layout = html_div() do
    dcc_dropdown(id="dropdown",
                 options = [
                    (label = i, value = i) for i in df7[:, "c"]
                 ],
                 value="x"
    ),
    html_div(id="output-2")
end

callback!(
    app,
    Output("output-2", "children"),
    Input("dropdown", "value"),
) do value
    # Here, `df7` is an example of a variable that is
    # 'outside the scope of this function'.
    # It is not safe to modify or reassign this variable
    # inside this callback.
    # do not do this, this is not safe!
    global df7 = filter!(row -> row.c == value, df7)
    return length(df7[1, :])
end

run_server(app, "0.0.0.0", debug=true)
