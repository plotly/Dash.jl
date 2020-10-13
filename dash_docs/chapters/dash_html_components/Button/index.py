# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(children=[
    html.H1('Button Examples and Reference'),
    html.H2('Button Basic Example'),
    rc.Markdown("An example of a default button without any extra properties \
    and `n_clicks` in the callback. `n_clicks` is an integer that represents \
    that number of times the button has been clicked. Note that the original \
    value is `None`."),
    rc.Syntax(examples['button_basic.py'][0]),
    rc.Example(examples['button_basic.py'][1]),
    html.Br(),
    html.H2(['Determining which Button Changed with ', html.Code('callback_context')]),
    rc.Markdown("This example utilizes the `dash.callback_context` property, \
    to determine which input was changed."),
    rc.Syntax(examples['button_ctx.py'][0]),
    rc.Example(examples['button_ctx.py'][1]),
    html.Br(),
    html.H2('Button Properties'),
    rc.ComponentReference('Button', html)
])
