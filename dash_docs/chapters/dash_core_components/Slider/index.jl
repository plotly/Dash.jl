module chapters_dash_core_components_slider

using Dash, DashHtmlComponents, DashCoreComponents

include("../../../utils.jl")

export examples

examples_path = joinpath(@__DIR__, "examples")

slider1 = LoadExampleCode(string(examples_path, "/basic_slider.jl"))

slider2 = LoadExampleCode(string(examples_path, "/marks_steps.jl"))


examples = [slider1]

app =  dash()
slider1.callback!(app)

app.layout = html_div() do

    html_h1("Slider Examples and Reference"),

    html_h3("Simple Slider Example"),

    html_div("An example of a basic slider tied to a callback."),

    slider1.source_code,
    slider1.layout,

    html_h3("Marks and Steps"),

    html_div("If slider `marks` are defined and `step` is set to `nothing` then the slider will only be able to select values that have been predefined by the `marks`. Note that the default is `step=1`, so you must explicitly specify `nothing` to get this behavior. `marks` is a `Dict` where the keys represent the numerical values and the values represent their labels."),

    slider2.source_code,
    slider2.layout

end

end
