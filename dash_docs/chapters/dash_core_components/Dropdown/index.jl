module chapters_dash_core_components_dropdown

using Dash, DashHtmlComponents, DashCoreComponents, Chain, Pkg

include("../../../utils.jl")

export examples

examples_path = joinpath(@__DIR__, "examples")

dropdown2 = LoadExampleCode(string(examples_path, "/default.jl"))

dropdown3 = LoadExampleCode(string(examples_path, "/multi.jl"))

dropdown4 = LoadExampleCode(string(examples_path, "/searchable.jl"))

dropdown5 = LoadExampleCode(string(examples_path, "/clearable.jl"))

dropdown6 = LoadExampleCode(string(examples_path, "/placeholder.jl"))

dropdown7 = LoadExampleCode(string(examples_path, "/disabled.jl"))

dropdown8 = LoadExampleCode(string(examples_path, "/disabled_options.jl"))

dropdown9 = LoadExampleCode(string(examples_path, "/dynamic_options.jl"))

examples = [dropdown2]

app =  dash()
dropdown2.callback!(app)

app.layout = html_div() do

    html_h1("Dropdown Examples and Reference"),

    dcc_markdown("
    For production Dash apps, the Dash Core Components styling & layout should be managed with Dash Enterprise [Design Kit](https://plotly.com/dash/design-kit).
    "),

    html_h3("Default Dropdown"),

    html_div("An example of a default dropdown without any extra properties."),

    dropdown2.source_code,
    dropdown2.layout,

    html_h3("Multi-value dropdown"),

    dcc_markdown("A dropdown component with the `multi` property set to `true` will allow the user to select more than one value at a time."),


    dropdown3.source_code,
    dropdown3.layout,



    html_h3("Disable Search"),

    dcc_markdown("The `searchable` property is set to `true` by default on all Dropdown components. To prevent searching the dropdown value, just set the `searchable` property to `false`. Try searching for 'New York' on this dropdown below and compare it to the other dropdowns on the page to see the difference."),

    dropdown4.source_code,
    dropdown4.layout,



    html_h3("Dropdown Clear"),

    dcc_markdown("The `clearable` property is set to `true` by default on all Dropdown components. To prevent the clearing of the selected dropdown value, just set the `clearable` property to `false."),

    dropdown5.source_code,
    dropdown5.layout,


    html_h3("Placeholder Text"),

    dcc_markdown("The `placeholder` property allows you to define default text shown when no value is selected."),

    dropdown6.source_code,
    dropdown6.layout,


    html_h3("Disable Dropdown"),

    dcc_markdown("To disable the dropdown just set `disabled=True.`"),

    dropdown7.source_code,
    dropdown7.layout,

    html_h3("Disable Options"),

    dcc_markdown("To disable a particular option inside the dropdown menu, set the `disabled property` in the options."),

    dropdown8.source_code,
    dropdown8.layout,

    html_h3("Dyanmic Options"),

    dcc_markdown("This is an example on how to update the options on the server depending on the search terms the user types. For example purpose the options are empty on first load, as soon as you start typing they will be loaded with the corresponding values."),

    dropdown9.source_code,
    dropdown9.layout


end

end
