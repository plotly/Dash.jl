using DataFrames, UrlDownload, Dash, DashHtmlComponents, DashCoreComponents


df3 = DataFrame(urldownload("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv"))

function generate_table(dataframe, max_rows = 10)
    html_table([
        html_thead(html_tr([html_th(col) for col in names(df3)])),
        html_tbody([
            html_tr([html_td(dataframe[r, c]) for c in names(dataframe)]) for r = 1:min(nrow(dataframe), max_rows)
        ]),
    ])
end


app = dash()

app.layout = html_div() do
    html_h4("US Agriculture Exports (2011)"),
    generate_table(df3, 10)
end

run_server(app, "0.0.0.0", debug=true)
