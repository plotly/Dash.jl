module chapters_sharing_data
using Dash, DashHtmlComponents, DashCoreComponents

export examples

include("../../utils.jl")
include("../../styles.jl")

include("../../reusable_components/Header.jl")
include("../../reusable_components/Example.jl")
include("../../reusable_components/Syntax.jl")

scoping_wrong = LoadExampleCode("./dash_docs/chapters/sharing_data/examples/scoping_wrong.jl")
scoping = LoadExampleCode("./dash_docs/chapters/sharing_data/examples/scoping.jl")

examples = [scoping_wrong, scoping]

app =  dash()
scoping_wrong.callback!(app)
scoping.callback!(app)


app.layout = html_div() do
    Header("Sharing Data Between Callbacks"),
    html_blockquote(dcc_markdown("This is the 5th chapter of the [Dash Tutorial](/).
    The [previous chapter](/interactive-visualization) covered how to use callbacks with
    the `dcc_graph` component. The [next and final chapter](/faqs) covers
    frequently asked questions and gotchas. Just getting started? Make sure to [install the necessary
    dependencies](/installation)")),
    dcc_markdown("
    One of the core Dash principles explained in the [Getting Started Guide on Callbacks] is that
    **Dash callbacks must never modify variables outside of their scope**. It is not safe to
    modify any `global` variables. This chapter explains why and provides some alternative
    patterns for sharing state between callbacks.

    ### Why Share State?

    In some apps, you may have multiple callbacks that depend on expensive data processing tasks like
    making SQL queries, running simulations, or downloading data.

    Rather than have each callback run the same expensive task, you can have one callback run the task and
    then share the results with the rest of the callbacks.

    This need has been somewhat ameliorated now that you can have [multiple outputs](/basic-callbacks) for one callback.
    This way, that expensive task can be done once and immediately used in all the outputs. But in some cases this
    still isn't ideal, for example if there are simple follow-on tasks that modify the results, like unit conversions.
    We shouldn't need to repeat a large database query just to change the results from Fahrenheit to Celsius!

    ### Why Global Variables Will Break Your app
    Dash is designed to work in multi-user environments where multiple people may view the application at the
    same time and will have **independent sessions**.

    If your app uses `global` variables, then one's user's session could set the variable to one value which
    would affect the next user's session.

    Dash is also designed to be able to run with **multiple workers** so that callbacks can be executed in parallel.

    When Dash apps run across multiple workers, their memory is *not shared*. This means that if you modify
    a global variable in one callback, that modification will not be applied to the rest of the workers.

    Here's a sketch of an app with a callback that modifies data out of its scope. This type of pattern *will not
    work reliably* for the reasons outlined above.

    "),
    scoping_wrong.source_code,
    Example(scoping_wrong.layout),


    dcc_markdown("""
    To fix this example, simply re-assign the filtered dataset to a new variable
    inside the callback, or follow one of the strategies outlined in the next
    part of this guide.

    """),

    scoping.source_code,
    Example(scoping.layout),


    dcc_markdown("""
    ### Sharing Data Between Callbacks

    In order to share data safely across multiple Julia processes, we need to store the data
    somewhere that is accessible to each of the processes.

    There are two main places to store this data:

    1. In the user's browser session.
    2. On the disk (e.g. on a file or on a new database).

    The following examples illustrate these approaches.

    """),
    dcc_markdown("""

    ### Example 1 - Storing Data in the Browser With A Hidden div

    To save data a user's browser session:
    * Implemented by saving the data as part of Dash's front-end store through
    the methonds explained in https://community.plotly.com/t/sharing-a-dataframe-between-plots/6173.

    * Data has to be converted to a string like JSON for storage and transport.

    * Data that is cached in this way will *only be available in the user's current sessiion*.
        * If you open up a new browser, the app's callbacks will always compute the data. The
        data is only cached and transported between callbacks within the session.

        * As such, unlike with caching, this method doesn't increase the memory footprint
        of the app.

        * There could be a cost in network transport. If you're sharing 10MB of data between callbacks,
        then that data will be transported over the network between each callback.

        * If the network cost is too high, then compute the aggregations upfront and transport those. Your
        app likely won't be displaying 10MB of data, it will just be displaying a subset or an aggregation
        of it.

    This example outlines how you can perform an expensive data processing step in one callback, serialize the
    output as JSON, and provide it as an input to the other callbacks. This example uses standard Dash callbacks
    and stores the JSON-ifed data inside a hidden div in the app.

    """),
    dcc_markdown("""

    ```
    global_df = DataFrame(CSV.File("..."))

    app.layout = html_div() do
        dcc_graph(id="graph"),
        html_table(id="table"),
        dcc_dropdown(id="dropdown"),
        html_div(id="intermediate-value", style = (display = "None"))

    end

    callback!(
        app,
        Output("intermediate-value", "children"),
        Input("dropdown", "value"),
    ) do value

        dff = your_expensive_clean_or_compute_step(value)
        return JSON.json(dff)
    end

    callback!(
        app,
        Output("graph", "figure"),
        Input("intermediate-value", "children"),
    ) do dff

        figure = create_figure(dff)
        return figure
    end

    callback!(
        app,
        Output("table", "children"),
        Input("intermediate-value", "children"),
    ) do dff

        table = create_table(dff)
        return table
    end
    ```

    """),
    dcc_markdown("""

    ### Example 2 - Computing Aggregations Upfront

    Sending the computed data over the network can be expensive if the data is large. In some cases, serializing
    this data and JSON can also be expensive.

    In many cases, your app will only display a subset or an aggregation of the computed or filtered data.
    In these cases, you could precompute your aggregations in your data processing callback and transport these
    aggregations to the remaining callbacks.

    Here's a simple example of how you might transport filtered or aggregated data to multiple callbacks.

    """),
    dcc_markdown("""

    ```
    callback!(
        app,
        Output("intermediate-value", "children"),
        Input("dropdown", "value"),
    ) do value

        df = your_expensive_clearn_or_compute_step(value)

        # a few filter steps that compute the data
        # as it's needed in the future callback

        df1 = filter(row -> row.Fruit == "apples")
        df2 = filter(row -> row.Fruit == "oranges")
        df3 = filter(row -> row.Fruit == "figs")

        datasets = Dict("df1"=>JSON.json(df1), "df2"=>JSON.json(df2), "df3"=>JSON.json(df3))
        return JSON.json(datasets)
    end

    callback!(
        app,
        Output("graph", figure"),
        Input("intermediate-value", "children"),
    ) do dff

        figure = create_figure_1(dff)
        return figure

    end

    callback!(
        app,
        Output("graph", figure"),
        Input("intermediate-value", "children"),
    ) do dff

        figure = create_figure_2(dff)
        return figure

    end

    callback!(
        app,
        Output("graph", figure"),
        Input("intermediate-value", "children"),
    ) do dff

        figure = create_figure_3(dff)
        return figure

    end
    ```
    """),
    dcc_markdown("
    The next chapter of the tutorial covers frequently asked questions about Dash and
    some common gotchas.

    [Dash Tutorial Part 6: FAQs and Gotchas](/faqs)
    ")
end

end
