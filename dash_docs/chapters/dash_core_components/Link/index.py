# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1('dcc.Link'),
    rc.Markdown('To learn more about links, see the chapter on <dccLink href="/urls" children="Dash URLs"/>.'),
    html.H3('Link Properties'),
    rc.ComponentReference('Link')
])
