# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([
    html.H1('dcc.Interval'),
    rc.Markdown(
    '''
    `dcc.Interval` is a component that will fire a callback periodically.
    Use `dcc.Interval` to update your app in realtime without needing to
    refresh the page or click on any buttons.

    See also the <dccLink href="/live-updates" children="live updates"/>
    chapter for other examples and strategies.
    '''
    ),

    html.H2('dcc.Interval Properties'),
    rc.ComponentReference('Interval')
])
