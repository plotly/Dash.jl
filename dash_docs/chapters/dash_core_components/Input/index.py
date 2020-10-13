# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1('Input Examples and Reference'),
    html.H2('Supported Input Types'),
    rc.Syntax(examples['input_all_types.py'][0]),
    rc.Example(examples['input_all_types.py'][1]),
    html.Br(),
    html.H2('Debounce delays the Input processing'),
    rc.Syntax(examples['input-basic.py'][0]),
    rc.Example(examples['input-basic.py'][1]),
    html.Br(),
    html.H2('Number Input'),
    rc.Markdown("""

    _Fixed and enhanced in Dash v1.1.0_

    Number type is now close to native HTML5 `input` behavior across
    browsers. We also apply a strict number casting in callbacks:
    valid number converts into corresponding number types, and invalid number
    converts into None. E.g.
    `dcc.Input(id='range', type='number', min=2, max=10, step=1)` typing 3 and
    11 will return respectively integer three and None in Python callbacks.

    ### Important Notice re Integer vs Float

    There is a limitation when converting numbers like 1.0 or 0.0, the
    corresponding number type in callbacks is **Integer** instead of **Float**.
    Please add extra guard casting like `float()` within callbacks if needed.
    """),
    rc.Syntax(examples['input_number_type.py'][0]),
    rc.Example(examples['input_number_type.py'][1]),
    html.Br(),
    html.H2('Input Properties'),
    rc.ComponentReference('Input')
])
