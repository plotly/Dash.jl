# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1('dcc.Tab Reference'),
    rc.Markdown('''
    The `dcc.Tab` and `dcc.Tabs` components can be used to create tabbed sections in your app.
    The `Tab` component controls the style and value of the individual tab
    and the `Tabs` component hold a collection of `Tab` components.

    See complete examples in the [dcc.Tabs](/dash-core-components/tabs) chapter.
    '''),

    html.H2('Tab properties'),
    rc.ComponentReference('Tab')
])
