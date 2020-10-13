# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs.tools import load_examples
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = load_examples(__file__)

layout = html.Div([

    rc.Markdown('''
    # Basic Dash Callbacks

    <blockquote>
    This is the 3rd chapter of the <dccLink children="Dash Tutorial" href="/"/>.
    The <dccLink href="/layout" children="previous chapter"/> covered the Dash app <code>layout</code>
    and the <dccLink href="/interactive-graphing" children="next chapter"/> covers interactive graphing.
    Just getting started? Make sure to <dccLink href="/installation" children="install the necessary dependencies"/>.
    </blockquote>
    '''),

    rc.Markdown('''

        In the <dccLink href="/layout" children="previous chapter"/> we learned that the `app.layout` describes what the app
        looks like and is a hierarchical tree of components.
        The `dash_html_components` library provides classes for all of the HTML
        tags, and the keyword arguments describe the HTML attributes like
        `style`, `className`, and `id`. The `dash_core_components` library
        generates higher-level components like controls and graphs.

        This chapter describes how to make your
        Dash apps using callback functions: Python functions that are automatically called by Dash whenever an input component's property changes.

        Let's get started with a simple example of an interactive Dash app.

    '''),

    html.H4('''
    Simple Interactive Dash App
    ''', id='simple-dash-app'),

    rc.Markdown(
        examples['getting_started_interactive_simple.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['getting_started_interactive_simple.py'][1], className="example-container"),

    rc.Markdown('''
    Let's break down this example:

    1. The "inputs" and "outputs" of our application's interface are described
       declaratively as the arguments of the `@app.callback` decorator.
    '''),

    html.Details(open=False, children=[
        html.Summary('Learn more about using the `@app.callback` decorator.'),
        rc.Markdown('''
        a. By writing this decorator, we're telling Dash to call this function for us whenever the value of the "input" component (the text box) changes in order to update the children of the "output" component on the page (the HTML div).

        b. You can use any name for the function that is wrapped by the `@app.callback` decorator. The convention is that the name describes the callback output(s).

        c. You can use any name for the function arguments, but you must use the same names inside the callback function as you do in its definition, just like in a regular Python function. The arguments are positional: first the `Input` items and then any `State` items are given in the same order as in the decorator.

        d. You must use the same `id` you gave a Dash component in the `app.layout` when referring to it as either an input or output of the `@app.callback` decorator.

        e. The `@app.callback` decorator needs to be directly above the callback function declaration. If there is a blank line between the decorator and the function definition, the callback registration will not be successful.

        f. If you're curious about what the decorator syntax means under the hood, you can read [this StackOverflow answer](https://stackoverflow.com/questions/739654/how-to-make-a-chain-of-function-decorators/1594484#1594484) and learn more about decorators by reading [PEP 318 -- Decorators for Functions and Methods](https://www.python.org/dev/peps/pep-0318/#current-syntax).
        ''', style={'marginTop': 10}),
    ], style={'marginBottom': 25}),


    rc.Markdown('''
    2. In Dash, the inputs and outputs of our application are simply the
       properties of a particular component. In this example,
       our input is the "`value`" property of the component that has the ID
       "`my-input`". Our output is the "`children`" property of the
       component with the ID "`my-output`".
    3. Whenever an input property changes, the function that the
       callback decorator wraps will get called automatically.
       Dash provides the function with the new value of the input property as
       an input argument and Dash updates the property of the output component
       with whatever was returned by the function.
    4. The `component_id` and `component_property` keywords are optional
       (there are only two arguments for each of those objects).
       They are included in this example for clarity but will be omitted in the rest of the documentation for the sake of brevity and readability.
    5. Don't confuse the `dash.dependencies.Input` object and the
       `dash_core_components.Input` object. The former is just used in these
       callbacks and the latter is an actual component.
    6. Notice how we don't set a value for the `children` property of the
       `my-output` component in the `layout`. When the Dash app starts, it
       automatically calls all of the callbacks with the initial values of the
       input components in order to populate the initial state of the output
       components. In this example, if you specified something like
       `html.Div(id='my-output', children='Hello world')`, it would get
       overwritten when the app starts.

    It's sort of like programming with Microsoft Excel:
    whenever an input cell changes, all of the cells that depend on that cell
    will get updated automatically. This is called "Reactive Programming".

    Remember how every component was described entirely through its set of
    keyword arguments? Those properties are important now.
    With Dash interactivity, we can dynamically update any of those properties
    through a callback function. Frequently we'll update the `children` of a
    component to display new text or the `figure` of a `dcc.Graph` component
    to display new data, but we could also update the `style` of a component or
    even the available `options` of a `dcc.Dropdown` component!

    ***

    Let's take a look at another example where a `dcc.Slider` updates a
    `dcc.Graph`.
    '''),

    html.H4('''
    Dash App Layout With Figure and Slider
    ''', id='dash-app-with-slider'),

    rc.Markdown(
        examples['getting_started_graph.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['getting_started_graph.py'][1], className="example-container", style={
        'paddingLeft': '20px',
        'paddingRight': '35px',
        'paddingBottom': '30px'
    }),

    rc.Markdown('''
    In this example, the `"value"` property of the `Slider` is the input of the
    app and the output of the app is the `"figure"` property of the `Graph`.
    Whenever the `value` of the `Slider` changes, Dash calls the callback
    function `update_figure` with the new value. The function filters the
    dataframe with this new value, constructs a `figure` object,
    and returns it to the Dash application.

    There are a few nice patterns in this example:

    1. We're using the [Pandas](http://pandas.pydata.org/) library for
       importing and filtering datasets in memory.
    2. We load our dataframe at the start of the app:
       `df = pd.read_csv('...')`.
       This dataframe `df` is in the global state of the app and can be
       read inside the callback functions.
    3. Loading data into memory can be expensive. By loading querying data at
       the start of the app instead of inside the callback functions, we ensure
       that this operation is only done when the app server starts. When a user
       visits the app or interacts with the app, that data (the `df`)
       is already in memory.
       If possible, expensive initialization (like downloading or querying
       data) should be done in the global scope of the app instead of within
       the callback functions.
    4. The callback does not modify the original data, it just creates copies
       of the dataframe by filtering through pandas filters.
       This is important: *your callbacks should never mutate variables
       outside of their scope*. If your callbacks modify global state, then one
       user's session might affect the next user's session and when the app is
       deployed on multiple processes or threads, those modifications will not
       be shared across sessions.
    5. We are turning on transitions with `layout.transition` to give an idea
       of how the dataset evolves with time: transitions allow the chart to
       update from one state to the next smoothly, as if it were animated.

    '''),

    html.H4('''
    Dash App With Multiple Inputs
    ''', id='dash-app-multiple-inputs'),

    rc.Markdown('''

    In Dash, any "`Output`" can have multiple "`Input`" components.
    Here's a simple example that binds five Inputs
    (the `value` property of 2 `Dropdown` components,
    2 `RadioItems` components, and 1 `Slider` component)
    to 1 Output component (the `figure` property of the `Graph` component).
    Notice how the `app.callback` lists all five `dash.dependencies.Input`
    inside a list in the second argument.

    '''),

    rc.Markdown(
        examples['getting_started_multiple_viz.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['getting_started_multiple_viz.py'][1], className="example-container", style={
        'padding-right': '35px',
        'padding-bottom': '30px'
    }),

    rc.Markdown('''

    In this example, the `update_graph` function gets called whenever the
    `value` property of the `Dropdown`, `Slider`, or `RadioItems` components
    change.

    The input arguments of the `update_graph` function are the new or current
    value of each of the `Input` properties, in the order that they were
    specified.

    Even though only a single `Input` changes at a time (a user can only change
    the value of a single Dropdown in a given moment), Dash collects the
    current state of all of the specified `Input` properties and passes them
    into your function for you. Your callback functions are always guaranteed
    to be passed the representative state of the app.

    Let's extend our example to include multiple outputs.

    '''),

    html.H4('''
    Dash App With Multiple Outputs
    ''', id='dash-app-multiple-outputs'),

    rc.Markdown('''

    *New in dash 0.39.0*

    So far all the callbacks we've written only update a
    single `Output` property. We can also update several at once: put all the
    properties you want to update as a list in the decorator, and return that
    many items from the callback. This is particularly nice if two outputs
    depend on the same computationally intense intermediate result, such as a
    slow database query.
    '''),

    rc.Markdown(
        examples['getting_started_multiple_outputs_1.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['getting_started_multiple_outputs_1.py'][1], className="example-container"),

    rc.Markdown('''
    A word of caution: it's not always a good idea to combine Outputs, even if
    you can:

    - If the Outputs depend on some but not all of the same Inputs, keeping
      them separate can avoid unnecessary updates.
    - If they have the same Inputs but do independent computations with these
      inputs, keeping the callbacks separate can allow them to run in parallel.

    '''),

    html.H4('''
    Dash App With Chained Callbacks
    ''', id='dash-app-chained-callbacks'),

    rc.Markdown('''

    You can also chain outputs and inputs together: the output of one callback
    function could be the input of another callback function.

    This pattern can be used to create dynamic UIs where one input component
    updates the available options of the next input component.
    Here's a simple example.
    '''),

    rc.Markdown(
        examples['getting_started_callback_chain.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['getting_started_callback_chain.py'][1], className="example-container"),

    rc.Markdown(u'''
    The first callback updates the available options in the second `RadioItems`
    component based off of the selected value in the first `RadioItems`
    component.

    The second callback sets an initial value when the `options` property
    changes: it sets it to the first value in that `options` array.

    The final callback displays the selected `value` of each component.
    If you change the `value` of the countries `RadioItems` component, Dash
    will wait until the `value` of the cities component is updated
    before calling the final callback. This prevents your callbacks from being
    called with inconsistent state like with `"America"` and `"Montréal"`.

    '''),

    html.H4('''
    Dash App With State
    ''', id='dash-app-state'),

    rc.Markdown('''

    In some cases, you might have a "form"-type pattern in your
    application. In such a situation, you might want to read the value
    of the input component, but only when the user is finished
    entering all of his or her information in the form.

    Attaching a callback to the input values directly can look like
    this:

    '''),

    rc.Markdown(
        examples['basic-input.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['basic-input.py'][1], className="example-container"),

    rc.Markdown('''
        In this example, the callback function is fired whenever any of the
        attributes described by the `dash.dependencies.Input` change.
        Try it for yourself by entering data in the inputs above.

        `dash.dependencies.State` allows you to pass along extra values without
        firing the callbacks. Here's the same example as above but with the
        `dcc.Input` as `dash.dependencies.State` and a button as
        `dash.dependencies.Input`.
    '''),

    rc.Markdown(
        examples['basic-state.py'][0],
        style=styles.code_container
    ),

    html.Div(examples['basic-state.py'][1], className="example-container"),

    rc.Markdown('''
        In this example, changing text in the `dcc.Input` boxes won't fire
        the callback but clicking on the button will. The current values of
        the `dcc.Input` values are still passed into the callback even though
        they don't trigger the callback function itself.

        Note that we're triggering the callback by listening to the
        `n_clicks` property of the `html.Button` component. `n_clicks` is a
        property that gets incremented every time the component has been
        clicked on. It is available in every component in the
        `dash_html_components` library.

    '''),

    html.H4('''
    Summary
    ''', id='basic-callbacks-summary'),

    rc.Markdown('''

    We've covered the fundamentals of callbacks in Dash.
    Dash apps are built off of a set
    of simple but powerful principles: declarative UIs that are customizable
    through reactive and functional Python callbacks.
    Every element attribute of the declarative components can be updated
    through a callback and a subset of the attributes, like the `value`
    properties of the `dcc.Dropdown`, are editable by the user in the
    interface.

    ***

    '''),

    rc.Markdown('''
        The next part of the Dash tutorial covers interactive graphing.
    '''),

    dcc.Link(
        'Dash Tutorial Part 4: Interactive Graphing',
        href=tools.relpath("/interactive-graphing")
    )


])
