# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([
    html.H1('dcc.ConfirmDialogProvider Documentation'),
    rc.Markdown('''
    Send a <dccLink href="/dash-core-components/confirmdialog" children="ConfirmDialog"/> when the user
    clicks the children of this component, usually a button.
    '''),
    rc.Syntax(examples['confirm_provider.py'][0]),
    rc.Example(examples['confirm_provider.py'][1]),

    html.H1('dcc.ConfirmDialogProvider Reference'),
    rc.ComponentReference('ConfirmDialogProvider')
])
