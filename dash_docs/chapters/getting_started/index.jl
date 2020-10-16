module chapters_getting_started

using Dash, DashHtmlComponents, DashCoreComponents
include("../../utils.jl")
include("../../styles.jl")

include("../../reusable_components/Header.jl")
include("../../reusable_components/Example.jl")


getting_started_layout_1 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_1.jl")

getting_started_layout_2 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_2.jl")

getting_started_layout_3 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_3.jl")

getting_started_layout_4 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_4.jl")

getting_started_layout_5 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_5.jl")

getting_started_layout_6 = LoadExampleCode("./dash_docs/chapters/getting_started/examples/getting_started_layout_6.jl")

app = dash()

app.layout = html_div() do
    Header("Dash Layout"),
    html_blockquote(dcc_markdown("This is the 2nd chapter of the [Dash Tutorial](/).
    The previous chapter covered [installation](/installation) and the next chapter covers [Dash callbacks](/basic-callbacks).")),
    dcc_markdown("""
    This tutorial will walk you through a fundamental aspect of Dash apps, the app `layout`, through several self-contained apps.
    """),
    html_hr(),
    dcc_markdown("""
    Dash apps are composed of two parts. The first part is the `layout` of the app and it describes what the application looks like.
    The second part describes the interactivity of the application and will be covered in the [next chapter](/basic-callbacks).

    Dash provides Julia methods for all of the visual components of the application.
    We maintain a set of components in the `DashCoreComponents` and the `DashHtmlComponents` packages
    but you can also build your own with JavaScript and React.js

    Note: Throughout this documentation, Julia code examples are meant to be saved as files and executed using `julia app.jl`.
    These examples are not intended to run in Jupyter notebooks as-is,
    although most can be modified slightly to function in that environment.

    To get started, create a file called `app.jl` with the following code:
    """),
    getting_started_layout_1.source_code,
    Example(getting_started_layout_1.layout),

    dcc_markdown("""

    Run the app with
    ```
    \$ julia app.jl
    ```

    In the `julia` REPL you can run the following code, assuming that `app.jl` is in your current working directory.
    ```
    julia> include("app.jl")
    ```

    You can visit the app by visiting the URL http://127.0.0.1:8050.

    Note:

    1. The `layout` is composed of a tree of "components" like `html_div` and `dcc_graph`.
    2. The `DashHtmlComponents` package has a component for every HTML tag. The `html_h1("Hello Dash")` component
    generates a `<h1>Hello Dash</h1>` HTML element in your application.
    3. Not all components are pure HTML. The `DashCoreComponents` package describes higher level components
    that are interactive and genrated with JavaScript, HTML, and CSS through the React.js library.
    4. Each component is described entirely through keyword attributes. Dash is *declarative*: you will
    primarily describe your application through these attributes.
    5. The `children` property is special. By convention, it's always the first attribute which means that you can omit it;
    `html_div(children="Hello Dash")` is the same as `html_div("Hello Dash")`. Also, it can contain a string, a number, a single
    component, or a list of components.
    6. The fonts in your application will look a little bit different than what is displayed here. This application is using
    a custom CSS stylesheet to modify the default styles of the elements. If you would like to use this stylesheet,
    you can initialize your app with

    `app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])`
    """),
    Header("More About HTML"),
    dcc_markdown("""
    The `DashHtmlComponents` package contains a component class for every HTML tag as well as keyword arguments for all of the
    HTML arguments.

    Let's customize the text in our app by modifying the inline styles of the components:
    """),

    getting_started_layout_2.source_code,
    Example(getting_started_layout_2.layout),

    dcc_markdown("""

    In this example, we modified the inline styles of the `html_div` and
    `html_h1` components with the style property. `html_h1("Hello Dash",
    style = Dict("color" => "#7FDBFF", "textAlign" => "center"))` is rendered
    in the Dash application as `<h1 style="text-align: center; color: rgb(127, 219, 255);">Hello Dash</h1>`

    There are a few important differences between the `DashHtmlComponents` and HTML attributes:

    1. The `style` property in HTML is a semicolon separated string. In Dash, you can just supply a `Dict`.
    2. The keys in the `style` `Dict` are [camelCased]("https://en.wikipedia.org/wiki/Camel_case"). So instead of `text-align`, it's `textAlign`.
    3. The HTML `class` attribute is `className` in Dash.
    4. The children of the HTML tag is specified through the `children` keyword argument. By convention, this is
    always the first argument and so it is often omitted. Besides that, all of the available HTML attributes and
    tags are available to you within your Julia context.
    """),
    Header("Reusable Components"),
    dcc_markdown("""
    By writing our markup in Julia, we can create
    complex reusable components like tables without switching contexts or
    languages.

    Here's a quick example that generates a `Table` from a `DataFrame`.
    Create a file named `app.jl` with the following code:
    """),
    getting_started_layout_3.source_code,
    Example(getting_started_layout_3.layout),
    Header("More About Visualization"),
    dcc_markdown("""
    The `DashCoreComponents` package includes a component called `graph`.

    `graph` renders interactive data visualizations using the open source
    plotly.js JavaScript graphing library. Plotly.js supports over 35 chart types
    and renders charts in both vector-quality SVG and high-performance WebGL.

    The `figure` argument in the `dcc_graph` component is the same `figure` argument
    that is used by `plotly.py`, Plotly's open-source Python graphing library. Check out the
    plotly.py documentation and gallery to learn more.

    Here's an example that creates a scatter plot from a `DataFrame`. Create a file named `app.jl`
    with the following code:
    """),
    getting_started_layout_4.source_code,
    Example(getting_started_layout_4.layout),
    dcc_markdown("""

    These graphs are interactive and responsive. *Hover* over points to see their values, *click* on legend items to
    toggle traces, *click and drag* to zoom, *hold down shift and click and drag* to pan.

    """),
    Header("Markdown"),
    dcc_markdown("""
    While Dash exposes HTML through the `DashHtmlComponents` package, it can be tedious to write your
    copy in HTML. For writing blocks of text, you can use the `dcc_markdown` component in the `DashCoreComponents` package.
    """),
    getting_started_layout_5.source_code,
    Example(getting_started_layout_5.layout),
    Header("Core Components"),
    dcc_markdown("""
    The `DashCoreComponents` package includes a set of higher level components like
    dropdowns, graphs, markdown blocks, and more. Like all Dash components, they are described
    entirely declaratively. Every option that is configurable is available as a keyword
    argument to the component.
    """),
    getting_started_layout_6.source_code,
    Example(getting_started_layout_6.layout),
    dcc_markdown("""
    The next part of the Dash tutorial covers how to make these apps interactive.

    [Dash Tutorial Part 3: Basic Callbacks](/basic-callbacks)
    """),

    html_hr(),
    dcc_markdown("[Back to the table of contents](/)")

end

end
