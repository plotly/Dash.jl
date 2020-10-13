# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1('dcc.Checklist'),
    rc.Markdown(
    '''
    `dcc.Checklist` is a component for rendering a set of checkboxes.
    See also <dccLink href="/dash-core-components/radioitems" children="RadioItems"/>
    for selecting a single option at a time or
    <dccLink href="/dash-core-components/dropdown" children="Dropdown"/> for
    a more compact view.
    '''
    ),

    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Checklist(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montréal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    value=['NYC', 'MTL']
)''', style=styles.code_container),

    rc.ComponentBlock('''import dash_core_components as dcc

dcc.Checklist(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montréal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    value=['NYC', 'MTL'],
    labelStyle={'display': 'inline-block'}
)''', style=styles.code_container),

    html.H2('dcc.Checklist Properties'),
    rc.ComponentReference('Checklist')
])
