# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([
    html.H1('ConfirmDialog component'),
    rc.Markdown('''
    ConfirmDialog is used to display the browser's native "confirm" modal,
    with an optional message and two buttons ("OK" and "Cancel").
    This ConfirmDialog can be used in conjunction with buttons when the user
    is performing an action that should require an extra step of verification.

    See <dccLink href="/dash-core-components/confirmdialogprovider" children="dcc.ConfirmDialogProvider"/>
    for an easier way to display an alert when clicking on an item.
    '''),
    rc.Syntax(examples['confirm.py'][0]),
    rc.Example(examples['confirm.py'][1]),

    html.H2('dcc.ConfirmDialog Properties'),
    rc.ComponentReference('ConfirmDialog')
])
