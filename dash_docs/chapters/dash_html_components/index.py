# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html
from dash_docs import styles
from dash_docs import reusable_components as rc

layout = html.Div(children=[

    rc.Markdown('''
    # Dash HTML Components

    Dash is a web application framework that provides pure Python abstraction
    around HTML, CSS, and JavaScript.

    Instead of writing HTML or using an HTML templating engine,
    you compose your layout using Python structures with the
    `dash-html-components` library.

    The source for this library is on GitHub: [plotly/dash-html-components](https://github.com/plotly/dash-html-components).

    Here is an example of a simple HTML structure:
    '''),

    rc.Markdown('''
    ```py
    import dash_html_components as html

    html.Div([
        html.H1('Hello Dash'),
        html.Div([
            html.P('Dash converts Python classes into HTML'),
            html.P('This conversion happens behind the scenes by Dash\'s JavaScript front-end')
        ])
    ])
    ```
    ''', style=styles.code_container),
    html.Div(
        'which gets converted (behind the scenes) into the '
        'following HTML in your web-app:'
    ),
    rc.Markdown('''
    ```html
    <div>
        <h1>Hello Dash</h1>
        <div>
            <p>Dash converts Python classes into HTML</p>
            <p>This conversion happens behind the scenes by Dash's JavaScript front-end</p>
        </div>
    </div>
    ```
    ''', style=styles.code_container),
    rc.Markdown('''
    If you're not comfortable with HTML, don't worry!
    You can get 95% of the way there with just a few elements
    and attributes.
    Dash's <dccLink href="/dash-core-components" children="core component library"/> also supports
    [Markdown](http://commonmark.org/help).
    '''),

    rc.Markdown('''
    ```py
    import dash_core_components as dcc

    dcc.Markdown(\'\'\'
    #### Dash and Markdown

    Dash supports [Markdown](http://commonmark.org/help).

    Markdown is a simple way to write and format text.
    It includes a syntax for things like **bold text** and *italics*,
    [links](http://commonmark.org/help), inline `code` snippets, lists,
    quotes, and more.
    \'\'\')
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    #### Dash and Markdown

    Dash supports [Markdown](http://commonmark.org/help).

    Markdown is a simple way to write and format text.
    It includes a syntax for things like **bold text** and *italics*,
    [links](http://commonmark.org/help), inline `code` snippets, lists,
    quotes, and more.''', className='example-container'),

    rc.Markdown('''
    If you're using HTML components, then you also have access to
    properties like `style`, `class`, and `id`.
    All of these attributes are available in the Python classes.

    The HTML elements and Dash classes are mostly the same but there are
    a few key differences:
    - The `style` property is a dictionary
    - Properties in the `style` dictionary are camelCased
    - The `class` key is renamed as `className`
    - Style properties in pixel units can be supplied as just numbers without the `px` unit

    Let's take a look at an example.
    '''),

    rc.Markdown('''
    ```py
    import dash_html_components as html

    html.Div([
        html.Div('Example Div', style={'color': 'blue', 'fontSize': 14}),
        html.P('Example P', className='my-class', id='my-p-element')
    ], style={'marginBottom': 50, 'marginTop': 25})
    ```
    ''', style=styles.code_container),

    html.Div('That Dash code will render this HTML markup:'),

    rc.Markdown('''
    ```html
    <div style="margin-bottom: 50px; margin-top: 25px;">

        <div style="color: blue; font-size: 14px">
            Example Div
        </div>

        <p class="my-class", id="my-p-element">
            Example P
        </p>

    </div>
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    Note: If you need to directly render a string of raw, unescaped HTML, you can use the `DangerouslySetInnerHTML` component which is provided by the [dash-dangerously-set-inner-html](https://github.com/plotly/dash-dangerously-set-inner-html) library.`
    '''),

    rc.Markdown('''
    ## Full elements reference:
    '''),
    html.Ul([
        html.Li(dcc.Link(
            'html.{}'.format(component),
            href='/dash-html-components/{}'.format(component.lower())
        ))
        for component in sorted(dir(html))
        if not component.startswith('_') and
        component[0].upper() == component[0]
    ])
])
