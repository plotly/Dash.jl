# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(children=[
    html.H1('dcc.LogoutButton'),
    dcc.Markdown('''
    `dcc.LogoutButton` is no longer recommended.
    See `html.Button` or `html.A` instead.
    '''),
])
