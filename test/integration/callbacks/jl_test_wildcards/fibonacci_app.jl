using Dash
function fibonacci_app(clientside)
    app = dash()
    app.layout = html_div() do
        dcc_input(id = "n", type = "number", min = 0, max = 10, value = 4),
        html_div(id = "series"),
        html_div(id = "sum")
    end

    get_n(n::Int) = n
    function get_n(n::String)
        try
            return parse(Int, n)
        catch
            return 0
        end
    end
    get_n(n) = 0

    callback!(app, Output("series", "children"),Input("n", "value")) do n
        return [html_div(id=(i = i,)) for i in 1:get_n(n)]
    end

    if clientside
        callback!(
            """
            function(vals) {
                var len = vals.length;
                return len < 2 ? len : +(vals[len - 1] || 0) + +(vals[len - 2] || 0);
            }
            """, app,
            Output((i = MATCH,), "children"),
            Input((i = ALLSMALLER,), "children")
        )

        callback!(
            """
            function(vals) {
                var sum = vals.reduce(function(a, b) { return +a + +b; }, 0);
                return vals.length + ' elements, sum: ' + sum;
            }
            """, app,
            Output("sum", "children"),
            Input((i = ALL,), "children"),
        )
    else
        callback!(app,
            Output((i = MATCH,), "children"), Input((i = ALLSMALLER,), "children")
        ) do prev
            (length(prev) < 2) && return length(prev)
            return prev[end]  + prev[end - 1]

        end

        callback!(app, Output("sum", "children"), Input((i = ALL,), "children")) do seq

            seq_sum = isempty(seq) ? 0 : sum(get_n, seq)
            return "$(length(seq)) elements, sum: $(seq_sum)"
        end
    end

    return app
end