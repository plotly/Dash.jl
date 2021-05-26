module chapters_dash_core_components

using Dash, DashHtmlComponents, DashCoreComponents, Chain, Pkg

function get_pkg_version(name::AbstractString)
    @chain Pkg.dependencies() begin
        values
        [x for x in _ if x.name == name]
        only
        _.version
    end
end

include("../../utils.jl")

export examples

examples_path = joinpath(@__DIR__, "examples")

dropdown1 = LoadExampleCode(string(examples_path, "/dropdown_index_example.jl"))

slider1 = LoadExampleCode(string(examples_path, "/slider.jl"))

slider2 = LoadExampleCode(string(examples_path, "/slider_with_marks.jl"))


examples = [dropdown1]

app =  dash()
dropdown1.callback!(app)

n = get_pkg_version("DashCoreComponents")

app.layout = html_div() do

    html_h1("Dash Core Components"),

    dcc_markdown("
    Dash ships with supercharged components for interactive user interfaces. A core set of components, written and maintained by the Dash team, is available in the `DashCoreComponents` library.

    For production Dash apps, the Dash Core Components styling & layout should be managed with Dash Enterprise [Design Kit](https://plotly.com/dash/design-kit).

    The source is on GitHub at [plotly/dash-core-components](https://github.com/plotly/dash-core-components).

    These docs are using version $n.
    "),

    html_a(html_h3("Dropdown"), href="/dash_core_components/dropdown"),

    dropdown1.source_code,
    dropdown1.layout,

    html_a(html_h3("Slider"), href="/dash_core_components/slider"),

    slider1.source_code,
    slider1.layout,

    slider2.source_code,
    slider2.layout

    # html_h3("RangeSlider"),



    # html_h3("Input"),



    # html_h3("Textare"),


    # html_h3("Checkboxes"),


    # html_h3("Radio Items"),


    # html_h3("Button"),



    # html_h3("DatePickerSingle"),



    # html_h3("DatePickerRange"),




    # html_h3("Markdown"),


    # html_h3("Upload Component"),




    # html_h3("Download Component"),




    # html_h3("Tabs"),



    # html_h3("Graphs"),



    # html_h3("Confirm Dialog"),



    # html_h3("Store"),



    # html_h3("Logout Button"),



    # html_h3("Loading component"),



    # html_h3("Location")

end

end
