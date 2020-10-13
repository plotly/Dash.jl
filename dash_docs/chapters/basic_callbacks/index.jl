module chapters_callbacks

using Dash, DashHtmlComponents, DashCoreComponents

include("../../utils.jl")

export examples

examples_path = joinpath(@__DIR__, "examples")

hello_slider = LoadExampleCode(string(examples_path, "/hello-slider.jl"))

multi_inputs = LoadExampleCode(string(examples_path, "/multi-inputs.jl"))

multi_outputs = LoadExampleCode(string(examples_path, "/multi-outputs.jl"))

simple_callback = LoadExampleCode(string(examples_path, "/simple-callback.jl"))

basic_input = LoadExampleCode(string(examples_path, "/basic-input.jl"))

basic_state = LoadExampleCode(string(examples_path, "/basic-state.jl"))

callback_chain = LoadExampleCode(string(examples_path, "/getting-started-callback-chain.jl"))

examples = [hello_slider, multi_inputs, multi_outputs, simple_callback, basic_input, basic_state, callback_chain]

app =  dash()
basic_input.callback!(app)
basic_state.callback!(app)
callback_chain.callback!(app)
hello_slider.callback!(app)
multi_inputs.callback!(app)
multi_outputs.callback!(app)
simple_callback.callback!(app)


app.layout = html_div() do
    html_h1("Basic Dash Callbacks"),
    html_blockquote(dcc_markdown("This is the 3rd chapter of the [Dash Tutorial](/).
    The previous chapter covered the Dash app [layout](/getting-started) and the [next chapter](/state) covers an additional concept of callbacks
    known as `state`.")),
    dcc_markdown("
    In the [previous chapter](/getting-started) on the app `layout` we learned that the
    `app.layout` describes what the app looks like and is a hierarchical tree of components.
    The `DashHtmlComponents` package provides classes for all of the HTML tags, and the keyword
    arguments describe the HTML attributes like `style`, `className`, and `id`. The `DashCoreComponents`
    package generates higher level components like controls and graphs.

    This chapter describes how to make your Dash apps interactive.

    Let's get started with a simple example.
    "),

    simple_callback.source_code,
    simple_callback.layout,

    dcc_markdown("""
    Try typing in the text box. The `children` property of the output
    component updates right away. Let's break down what's happening here:

    1. The "inputs" and "outputs" of our application interface are described
    declaratively by the `callback!` function definition.

    2. In Dash, the inputs and outputs of our application are simply the
    properties of a particular component. In this example, our input is the `value`
    property of of the component with the ID `input`. Our output is the `children` property
    of the compnoent with the ID `output`.

    3. Whenever an input property changes, the callback function will be executed automatically.
    Dash provides the callback function with the new value of the input property as an input argument
    and Dash updates the property of the output component with whatever was returned by the callback
    function.

    4. Don't confuse the `Dash::Input` object with the `DashCoreComponents::Input` object. The former is just used to declare
    inputs of callback functions while the latter is an UI component which is used to render HTML input elements.

    5. Notice how we don't set a value for the `children` property of the `input` component in the `layout`. When
    the Dash app starts, it automatically calls all the callbacks with the initial values of the input componets in
    order to populate the initial state of the output components. In this example, if you specified something like
    `html_div(id=\"output\", children=\"hello world\")`, it would get overwritten when the app starts by what is
    returned by the callback function.

    It's sort of like programming with Microsoft Excel: whenever an input cell changes, all of the cells that
    depend on that cell will get updated automatically. This is called \"Reactive Programming\".

    Remember how every component was described entirely through its set of keyword arguments? Those properties are important now.
    With Dash's interactivity, we can dynamically update any of those properties through a callback function.
    Frequently we'll update the `children` of a component to display new text or the `figure` of a `Graph` component to
    display new data, but we could also update the `style` of a component or even the available `options` of a `Dropdown`
    component!
    """),
    html_hr(),
    dcc_markdown("""
    Let's take a look at another example where a `Slider` updates a `Graph`.

    ## Dash App Layout With Figure and Slider
    """),
    hello_slider.source_code,

    hello_slider.layout,

    dcc_markdown("""
    In this example, the `value` property of the `Slider` component is the input of the app and the output of the app is the `figure` property of the `Graph` component. When the `value` of the `Slider` changes, Dash calls the callback function with new value. The function filters the dataframe with this new value, constructs a `figure` object, and returns it to the Dash app.

    There are a few nice patterns in this example:

    1. We're using the `CSV` and `DataFrames` libraries to import and filter datasets in memory.

    2. We load our dataframe at the start of the app: `df = CSV.read("...")`. This dataframe `df` is in the global state of the app and can be read inside callback functions.

    3.Loading data into memory can be expensive. By loading data at the start of the app instead of inside callback functions, we ensure that this operation is only done with the app server starts. When a user visits the app or interacts with the app, the data (the `df`) is already in memory. If possible, expensive initialization (like downloading or querying data) should be done in the global scope of the app instead of within callback functions.

    4, The callback does not modify the original data, it just creates copies of the dataframe by filtering. This is important: *your callbacks should never mutate variables outside of their scope*. If your callbacks modify global state, then one user's session might affect the next user's session and when the app is deployed on a server with multiple processes or threads, those modifications will not be shared across sessions.

    5. We are turning on transitions with `layout.transition` to give an idea of how the dataset evolves with time: transitions allow the chart to update from one state to the next smoothly, as if it were animated.
    """),
    html_h1("Dash App With Multiple Inputs"),
    dcc_markdown("""
    In Dash, any `Output` can have multiple `Input` components.
    Here's a simple example that binds five Inputs (the `value` property of
    2 `Dropdown` components, 2 `RadioItems` components, and
    1 `Slider` component) to 1 Output component (the `figure` property of the `Graph` component).
    """),
    multi_inputs.source_code,

    multi_inputs.layout,
    dcc_markdown("""

    In this example, the callback function gets called whenever the `value`
    property of the `Dropdown`, `Slider`, or `RadioItems` components change.

    The input arguments of the callback function are the new or current value of
    each of the `Input` properties, in the order that they were specified.

    Even though only a single `Input` changes at a time (a user can only
    change the value of a single `Dropdown` at a given moment), Dash collects
    the current state of all of the specified `Input` properties and passes them
    into your callback function for you. Your callback functions are always
    guaranteed to have be passed the representative state of the app.

    Let's extend our example to include multiple outputs.
    """),
    html_h1("Dash App With Multiple Outputs"),
    dcc_markdown("""
    So far all the callbacks we've written only update a single Output property. We can also
    update several at once: put all the properties you want to update as inputs to the callback,
    and return that many items from the callback. This is particularly nice if two outputs depend
    on the same computationaly intense itermediate result, such as a slow database query.
    """),
    multi_outputs.source_code,

    multi_outputs.layout,
    dcc_markdown("""

    A word of caution: it's not always a good idea to combine Outputs, even if you can:
    - If the Outputs depend on some but not all of the same inputs, keeping them separate
    can avoid unneccessary updates.
    - If they have the same inputs but do independent computations with these same inputs,
    keeping the callbacks separate can allow them to run in parallel.
    """),
    html_h1("Dash App With Chained Callbacks"),
    dcc_markdown("""
    You can also chain outputs and inputs together: the output of one callback function could
    be the input of another callback function.

    This pattern can be used to create dynamic UIs where one input component updates the available
    options of the next input component. Here's a simple example:
    """),
    callback_chain.source_code,

    callback_chain.layout,

    dcc_markdown("""

    The first callback updates the available options in the second
    `RadioItems` component.

    The second callback sets an initial value when the `options` property
    changes: it sets it to the first value in that `options` array.

    The final callback displays the selected `value` of each component. If you
    change the `value` of the countries `RadioItems` component, Dash will wait until
    the `value` of the cities component is updated before calling the final callback.
    This prevents your callbacks from being called with inconsistent state like with
    "America" and "Montreal".
    """),
    html_h1("Dash Apps With State"),
    dcc_markdown("""
    In some cases, you might have a "form"-type pattern in your appliication.
    In such a situation, you might want to read the value of the input component,
    but only when the user is finished entering all of his or her information in
    the form.

    Attaching a callback to the input values directly can look like this:
    """),
    basic_input.source_code,

    basic_input.layout,
    dcc_markdown("""

    In this example, the callback function is fired whenever any of the attributes
    described by the `Input` change. Try it for yourself by entering data in the inputs
    above.

    `State` allows you pass along extra values without firing the callbacks. Here's the same
    example as above but with the `Input` as `State` and a button as an `Input`.
    """),
    basic_state.source_code,

    basic_state.layout,
    dcc_markdown("""

    In this example, changing text in the `Input` boxes won't fire the callback but clicking on the button will.
    The current values of the `Input` values are still passed into the callback even though they don't trigger the
    callback function itself.

    Note that we're triggering the callback by listening to the `n_clicks` property of the `Button` component. `n_clicks`
    is a property that gets incremented every time the component has been clicked on. It is available in
    every component in the `DashHtmlComponents` components library.
    """),
    html_h1("Summary"),
    dcc_markdown("""
    We've covered the fundamentals of callback functions in Dash. Dash apps are built on a set of
    simple but powerful principles: declarative UIs that are customizable through
    reaction and functional Julia callbacks. Every element attribute of the
    declarative components can be updated through a callback and a subset of the
    attributes, like the `value` property of a `Dropdown`, are editable by the user
    in the interface.
    """),
    dcc_markdown("""
    The next part of the Dash  tutorial covers interactive graphing.

    [Dash Tutorial Part 4: Interactive Graphing](/interactive-graphing)
    """)
end

end
