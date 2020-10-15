# initialize outermost container Dash app
include("app.jl");

using Pkg
Pkg.develop(path="./dash-user-guide-components")

using Dash, DashCoreComponents, DashHtmlComponents, DashUserGuideComponents, Match

# Load Chapter, Example, Header, Section, Syntax components
map(include, filter(x->occursin(r".jl$", x), readdir("dash_docs/reusable_components/", join=true)));

# Load chapter container Dash apps
include("dash_docs/chapters/whats_dash/introduction.jl");
include("dash_docs/chapters/installation/index.jl");
include("dash_docs/chapters/getting_started/index.jl");
include("dash_docs/chapters/basic_callbacks/index.jl");
include("dash_docs/chapters/graph_crossfiltering/index.jl");
include("dash_docs/chapters/sharing_data/index.jl");
include("dash_docs/chapters/faq_gotchas/index.jl");
include("dash_docs/chapters/deployment/index.jl");

for example in chapters_callbacks.examples
    example.callback!(app)
end

for example in chapters_interactive_graphing.examples
    example.callback!(app)
end

for example in chapters_sharing_data.examples
    example.callback!(app)
end

header = html_div(
    children = (
        html_div(
            style = Dict("height" => "95%"),
            className = "container-width",
            children = (
                html_div(
                    children = (
                        html_span("📣 Welcome! Dash for Julia is New! Read "),
                        html_a("the community announcement", className = "link", href="https://community.plotly.com/t/welcome-to-dash-julia/46056"),
                        html_span(" regarding the current status of the project.")
                    ),
                    style = Dict("background-color" => "#80CFBE", "text-align" => "center", "color" => "#000000")),
                html_a(
                    html_img(
                        style = Dict("height" => "100%", "padding-left" => "80px"),
                        src = "https://dash.plotly.com/assets/images/logo-plotly.png"
                        ),
                        href = "https://plotly.com/products/dash",
                        className = "logo-link"
                        ),
                        html_div(
                            children = (
                                html_a("pricing", className = "link", href = "https://plotly.com/dash"),
                                html_a("user guide", className = "link", href = "/"),
                                html_a("plotly", className = "link", href = "https://plotly.com")
                                ),
                            className = "links"
                        )
                    )
        )
    ),
    className = "header"
);

app.layout = html_div() do
    html_div(id = "wait-for-layout"),
    dcc_location(id = "url", refresh=false),
    header,
    html_div(
        className = "content-wrapper",
        children = (
            html_div(
                (
                    html_div(id = "backlinks-top", className = "backlinks"),
                    html_div(
                        html_div(id = "chapter", className = "content"), # the children of this component is the layout of a dash app, based on URL
                        className = "content-container",
                        style = Dict("margin" => "70px")
                    ),
                    html_div(id = "backlinks-bottom", className = "backlinks")
                ),
                className = "rhs-content container-width"
            ),
            dugc_pagemenu(id = "pagemenu")
        )
    )
end;

callback!(app,
    Output("chapter", "children"),
    Output("pagemenu", "dummy2"),
    Input("url", "pathname")) do pathname
       get_content(pathname) = @match pathname begin
            "/introduction" => chapters_whats_dash.app.layout
            "/installation" => chapters_installation.app.layout
            "/getting-started" => chapters_getting_started.app.layout
            "/basic-callbacks" => chapters_callbacks.app.layout
            "/interactive-graphing" => chapters_interactive_graphing.app.layout
            "/sharing-data-between-callbacks" => chapters_sharing_data.app.layout
            "/deployment" => chapters_deployment.app.layout
            "/faqs" => chapters_faq_gotchas.app.layout
            _ => html_div() do
                html_br(),
                html_h1("Dash for Julia User Guide"),
                Section(
                    "What's Dash?",
                    (
                        Chapter(
                            "Introduction",
                            "/introduction",
                            "A quick paragraph about Dash and a link to the talk at Plotcon that started it all."
                        ),
                        Chapter(
                            "Announcement Essay",
                            "https://medium.com/plotly/dash-is-react-for-python-r-and-julia-c75822d1cc24",
                            "Our extended essay on Dash. An extended discussion of Dash's architecture and our motivation behind the project."
                        ),
                        Chapter(
                            "Dash App Gallery",
                            "https://dash.plotly.com/gallery",
                            "A glimpse into what's possible with Dash."
                        ),
                        Chapter(
                            "Dash Club",
                            "https://plot.us12.list-manage.com/subscribe?u=28d7f8f0685d044fb51f0d4ee&id=0c1cb734d7",
                            "A fortnightly email newsletter by chriddyp, the creator of Dash."
                        )
                    )
                ),
                Section(
                "Dash Tutorial",
                (
                    Chapter(
                        "Part 1. Installation",
                        "/installation",
                        "How to install and upgrade Dash libraries with the Pkg package manager."
                    ),
                    Chapter(
                        "Part 2. The Dash Layout",
                        "/getting-started",
                        "The Dash `layout` describes what your app will look like and is composed of a set of declarative Dash components."
                    ),
                    Chapter(
                        "Part 3. Basic Callbacks",
                        "/basic-callbacks",
                        "Dash apps are made interactive through Dash Callbacks:
                        R functions that are automatically called whenever an input component's property changes. Callbacks can be chained,
                        allowing one update in the UI to trigger several updates across the app."
                    ),
                    Chapter(
                        "Part 4. Interactive Graphing and Crossfiltering",
                        "/interactive-graphing",
                        "Bind interactivity to the Dash `Graph` component whenever you hover, click, or
                        select points on your chart."
                    ),
                    Chapter(
                        "Part 5. Sharing Data Between Callbacks",
                        "/sharing-data-between-callbacks",
                        "`global` variables will break your Dash apps. However, there are other ways
                        to share data between callbacks. This chapter is useful for callbacks that
                        run expensive data processing tasks or process large data."
                    ),
                    Chapter(
                        "Part 6. FAQs and Gotchas",
                        "/faqs",
                        "If you have read through the rest of the tutorial and still have questions
                        or are encountering unexpected behaviour, this chapter may be useful."
                        )
                    )
                ),
                Section(
                    "Production",
                    (
                        Chapter(
                            "Deployment",
                            "/deployment",
                            ""
                        )
                    )
                )
            end
        end
    return get_content(pathname), ""
end;

callback!(
    ClientsideFunction("clientside", "pagemenu"),
    app,
    Output("pagemenu", "dummy"),
    Input("chapter", "children")
)

port = parse(Int64, ENV["PORT"])

print("Binding to PORT $(port)...")

run_server(app, "0.0.0.0", port)
