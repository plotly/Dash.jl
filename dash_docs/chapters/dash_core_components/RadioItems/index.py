# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1('dcc.RadioItems Examples & Documentation'),
    rc.Markdown(
    '''
    `dcc.RadioItems` is a component for rendering a set of checkboxes.
    See also <dccLink href="/dash-core-components/checklist" children="Checklist"/>
    for selecting multiple options at a time
    <dccLink href="/dash-core-components/dropdown" children="Dropdown"/> for
    a more compact view.
    '''
    ),

    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RadioItems(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montréal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    value='MTL'
)''', style=styles.code_container),

    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RadioItems(
    options=[
        {'label': 'New York City', 'value': 'NYC'},
        {'label': 'Montréal', 'value': 'MTL'},
        {'label': 'San Francisco', 'value': 'SF'}
    ],
    value='MTL',
    labelStyle={'display': 'inline-block'}
)''', style=styles.code_container),

    html.H2('RadioItems Properties'),
    rc.ComponentReference('RadioItems')
])
