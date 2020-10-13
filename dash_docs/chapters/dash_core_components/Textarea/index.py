# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H3('dcc.Textarea Documentation'),
    dcc.Markdown(
    '''
    `dcc.Textarea` is a wrapper around the [<textarea/> HTML component](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea).

    It is like a `dcc.Input` except that allows for multiple lines of text.
    '''
    ),
    html.H2('Simple dcc.Textarea Example'),

    rc.Syntax(examples['textarea_basic.py'][0]),
    rc.Example(examples['textarea_basic.py'][1]),

    html.H2('Update dcc.Textarea callback on button press'),


    rc.Syntax(examples['textarea_state.py'][0]),
    rc.Example(examples['textarea_state.py'][1]),

    html.H2('dcc.Textarea Properties'),
    rc.ComponentReference('Textarea')
])
