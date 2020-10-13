# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(children=[
    html.H1('Dropdown Examples and Reference'),
    html.Hr(),
    html.H3('Default Dropdown'),
    html.P("An example of a default dropdown without \
            any extra properties."),
    rc.Markdown(
        examples['dropdown.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['dropdown.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Multi-Value Dropdown'),
    rc.Markdown("A dropdown component with the `multi` property set to `True` \
                  will allow the user to select more than one value \
                  at a time."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    value=['MTL', 'NYC'],
    multi=True
)''', style=styles.code_container),
    html.Hr(),

    html.H3('Disable Search'),
    rc.Markdown("The `searchable` property is set to `True` by default on all \
            `Dropdown` components. To prevent searching the dropdown \
            value, just set the `searchable` property to `False`. \
            Try searching for 'New York' on this dropdown below and compare \
            it to the other dropdowns on the page to see the difference."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    searchable=False
)''', style=styles.code_container),
    html.Hr(),

    html.H3('Dropdown Clear'),
    rc.Markdown("The `clearable` property is set to `True` by default on all \
            `Dropdown` components. To prevent the clearing of the selected dropdown \
            value, just set the `clearable` property to `False`"),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'},
    ],
    value='MTL',
    clearable=False
)''', style=styles.code_container),

    html.Hr(),
    html.H3('Placeholder Text'),
    rc.Markdown("The `placeholder` property allows you to define \
                 default text shown when no value is selected."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    placeholder="Select a city",
)''', style=styles.code_container),

    html.Hr(),
    html.H3('Disable Dropdown'),
    rc.Markdown("To disable the dropdown just set `disabled=True`."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    disabled=True
)''', style=styles.code_container),

    html.Hr(),
    html.H3('Disable Options'),
    rc.Markdown("To disable a particular option inside the dropdown \
                 menu, set the `disabled` property in the options."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Dropdown(
    options=[
        {'label': 'New York City', 'value': 'NYC', 'disabled': True},
        {'label': 'Montreal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF', 'disabled': True}
    ],
)''', style=styles.code_container),

    html.H3('Dynamic Options'),
    html.P("This is an example on how to update the options on the server \
           depending on the search terms the user types. For example purpose \
           the options are empty on first load, as soon as you start typing \
           they will be loaded with the corresponding values."),
    rc.Markdown(
        examples['dropdown_dynamic_options.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['dropdown_dynamic_options.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3("Dropdown Properties"),
    rc.ComponentReference('Dropdown')
])
