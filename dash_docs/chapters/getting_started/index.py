# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles, tools
from dash_docs.tools import load_examples
from dash_docs import reusable_components as rc

import os

examples = load_examples(__file__)

layout = html.Div([


    rc.Markdown('''
    # Dash Layout

    <blockquote>
    This is the 2nd chapter of the <dccLink children="Dash Tutorial" href="/"/>.
    The <dccLink href="/installation" children="previous chapter"/> covered installation
    and the <dccLink href="/basic-callbacks" children="next chapter"/> covers Dash callbacks.
    </blockquote>
    '''),


    rc.Markdown('''

    This tutorial will walk you through a fundamental aspect of Dash apps, the
    app `layout`, through {} self-contained apps.

    '''.format(len(examples))),

    rc.Markdown('''
    ***

    Dash apps are composed of two parts. The first part is the "`layout`" of
    the app and it describes what the application looks like.
    The second part describes the interactivity of the application and will be
    covered in the <dccLink href="/basic-callbacks" children="next chapter"/>.

    Dash provides Python classes for all of the visual components of
    the application. We maintain a set of components in the
    `dash_core_components` and the `dash_html_components` library
    but you can also [build your own](https://github.com/plotly/dash-component-boilerplate)
    with JavaScript and React.js.

    Note: Throughout this documentation, Python code examples are meant to be saved as files and executed using `python app.py`. These examples are not intended to run in Jupyter notebooks as-is, although most can be modified slightly to function in that environment.

    '''),

    rc.Syntax(examples['getting_started_layout_1.py'][0], summary='''
        To get started, create a file named `app.py` with the following code:
    '''),
    rc.Markdown('''
    Run the app with

    ```
    $ python app.py
    ...Running on http://127.0.0.1:8050/ (Press CTRL+C to quit)
    ```

    and visit [http://127.0.0.1:8050/](http://127.0.0.1:8050/)
    in your web browser. You should see an app that looks like this.
    '''),

    rc.Example(examples['getting_started_layout_1.py'][1]),

    rc.Markdown(
    '''
    Note:

    1. The `layout` is composed of a tree of "components" like `html.Div`
        and `dcc.Graph`.
    2. The `dash_html_components` library has a component for every HTML
        tag. The `html.H1(children='Hello Dash')` component generates
        a `<h1>Hello Dash</h1>` HTML element in your application.
    3. Not all components are pure HTML. The `dash_core_components` describe
        higher-level components that are interactive and are generated with
        JavaScript, HTML, and CSS through the React.js library.
    4. Each component is described entirely through keyword attributes.
        Dash is _declarative_: you will primarily describe your application
        through these attributes.
    5. The `children` property is special. By convention, it's always the
        first attribute which means that you can omit it:
        `html.H1(children='Hello Dash')` is the same as `html.H1('Hello Dash')`.
        Also, it can contain a string, a number, a single component, or a
        list of components.
    6. The fonts in your application will look a little bit different than
        what is displayed here. This application is using a
        custom CSS stylesheet to modify the default styles of the elements.
        You can learn more in the <dccLink href="/external-resources" children="css tutorial"/>,
        but for now you can initialize your app with

    ```
    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    ```
    to get the same look and feel of these examples.

    ### Making your first change

    **New in dash 0.30.0 and dash-renderer 0.15.0**

    Dash includes "hot-reloading", this features is activated by default when
    you run your app with `app.run_server(debug=True)`. This means that Dash
    will automatically refresh your browser when you make a change in your code.

    Give it a try: change the title "Hello Dash" in your application or change the `x` or the `y` data. Your app should auto-refresh with your change.

    > Don't like hot-reloading? You can turn this off with `app.run_server(dev_tools_hot_reload=False)`.
    > Learn more in <dccLink href="/devtools" children="Dash Dev Tools documentation"/> Questions? See the [community forum hot reloading discussion](https://community.plotly.com/t/announcing-hot-reload/14177).

    #### More about HTML

    The `dash_html_components` library contains a component class for every
    HTML tag as well as keyword arguments for all of the HTML arguments.

    '''),

    rc.Syntax(examples['getting_started_layout_2.py'][0], summary='''
        Let's customize the text in our app by modifying the inline styles of the
        components. Create a file named `app.py` with the following code:
        '''),

    html.Div(examples['getting_started_layout_2.py'][1], className="example-container", style={
        'padding-right': '35px',
        'padding-bottom': '30px'
    }),



    rc.Markdown('''
        In this example, we modified the inline styles of the `html.Div`
        and `html.H1` components with the `style` property.

        `html.H1('Hello Dash', style={'textAlign': 'center', 'color': '#7FDBFF'})`
        is rendered in the Dash application as
        `<h1 style="text-align: center; color: #7FDBFF">Hello Dash</h1>`.

        There are a few important differences between the `dash_html_components`
        and the HTML attributes:

        1. The `style` property in HTML is a semicolon-separated string. In Dash,
           you can just supply a dictionary.
        2. The keys in the `style` dictionary are [camelCased](https://en.wikipedia.org/wiki/Camel_case).
           So, instead of `text-align`, it's `textAlign`.
        3. The HTML `class` attribute is `className` in Dash.
        4. The children of the HTML tag is specified through the `children` keyword
           argument. By convention, this is always the _first_ argument and
           so it is often omitted.


        Besides that, all of the available HTML attributes and tags are available
        to you within your Python context.

        ***

        #### Reusable Components

        By writing our markup in Python, we can create complex reusable
        components like tables without switching contexts or languages.

    '''.replace('   ', '')),

    rc.Syntax(
        examples['getting_started_table.py'][0],
        summary="""
            Here's a quick example that
            generates a `Table` from a Pandas dataframe. Create a file named `app.py` with the following code:
        """
    ),

    rc.Example(examples['getting_started_table.py'][1]),

    rc.Markdown('''
        #### More about Visualization

        The `dash_core_components` library includes a component called `Graph`.

        `Graph` renders interactive data visualizations using the open source
        [plotly.js](https://github.com/plotly/plotly.js) JavaScript graphing
        library. Plotly.js supports over 35 chart types and renders charts in
        both vector-quality SVG and high-performance WebGL.

        The `figure` argument in the `dash_core_components.Graph` component is
        the same `figure` argument that is used by `plotly.py`, Plotly's
        open source Python graphing library.
        Check out the [plotly.py documentation and gallery](https://plotly.com/python)
        to learn more.

    '''),

    rc.Syntax(examples['getting_started_viz.py'][0], summary='''
    Here's an example that creates a scatter plot from a Pandas dataframe. Create a file named `app.py` with the following code:
    '''),

    rc.Example(examples['getting_started_viz.py'][1]),

    rc.Markdown('''
        *These graphs are interactive and responsive.
         **Hover** over points to see their values,
         **click** on legend items to toggle traces,
         **click and drag** to zoom,
         **hold down shift, and click and drag** to pan.*

        #### Markdown

        While Dash exposes HTML through the `dash_html_components` library,
        it can be tedious to write your copy in HTML.
        For writing blocks of text, you can use the `Markdown` component in the
        `dash_core_components` library. Create a file named `app.py` with the following code:
    '''),

    rc.Syntax(examples['getting_started_markdown.py'][0]),

    rc.Example(examples['getting_started_markdown.py'][1]),

    rc.Markdown('''
        #### Core Components

        The `dash_core_components` includes a set of higher-level components like
        dropdowns, graphs, markdown blocks, and more.

        Like all Dash components, they are described entirely declaratively.
        Every option that is configurable is available as a keyword argument
        of the component.
    '''),

    html.P(['''
        We'll see many of these components throughout the tutorial.
        You can view all of the available components in the
    ''', dcc.Link(
        'Dash Core Components Gallery',
        href=tools.relpath('/dash-core-components')
    )]),

    rc.Syntax(
        examples['getting_started_core_components.py'][0],
        summary="Here are a few of the available components. Create a file named `app.py` with the following code:"),

    html.Div(examples['getting_started_core_components.py'][1], className="example-container"),

    rc.Markdown('''

        #### Calling `help`

        Dash components are declarative: every configurable aspect of these
        components is set during instantiation as a keyword argument.
        Call `help` in your Python console on any of the components to
        learn more about a component and its available arguments.

    '''),

    html.Div(
        rc.Markdown('''```python
>>> help(dcc.Dropdown)
class Dropdown(dash.development.base_component.Component)
|  A Dropdown component.
|  Dropdown is an interactive dropdown element for selecting one or more
|  items.
|  The values and labels of the dropdown items are specified in the `options`
|  property and the selected item(s) are specified with the `value` property.
|
|  Use a dropdown when you have many options (more than 5) or when you are
|  constrained for space. Otherwise, you can use RadioItems or a Checklist,
|  which have the benefit of showing the users all of the items at once.
|
|  Keyword arguments:
|  - id (string; optional)
|  - className (string; optional)
|  - disabled (boolean; optional): If true, the option is disabled
|  - multi (boolean; optional): If true, the user can select multiple values
|  - options (list; optional)
|  - placeholder (string; optional): The grey, default text shown when no option is selected
|  - value (string | list; optional): The value of the input. If `multi` is false (the default)
|  then value is just a string that corresponds to the values
|  provided in the `options` property. If `multi` is true, then
|  multiple values can be selected at once, and `value` is an
|  array of items with values corresponding to those in the
|  `options` prop.```'''), style=styles.code_container),

    rc.Markdown('''
        ### Summary

        The `layout` of a Dash app describes what the app looks like.
        The `layout` is a hierarchical tree of components.
        The `dash_html_components` library provides classes for all of the HTML
        tags and the keyword arguments describe the HTML attributes like `style`,
        `className`, and `id`.
        The `dash_core_components` library generates higher-level
          components like controls and graphs.

        For reference, see:
    '''),

    html.Ul([
        html.Li(
            dcc.Link(
                [html.Code('dash_core_components'), ' gallery'],
                href=tools.relpath('/dash-core-components')
            )
        ),
        html.Li(
            dcc.Link(
                [html.Code('dash_html_components'), ' gallery'],
                href=tools.relpath('/dash-html-components')
            )
        )
    ]),

    html.P('''
        The next part of the Dash tutorial covers how to make these apps
        interactive.
    '''),

    dcc.Link(
        'Dash Tutorial Part 3: Basic Callbacks',
        href=tools.relpath("/basic-callbacks")
    )

])
