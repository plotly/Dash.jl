# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([
    html.H1('Location Component'),

    rc.Markdown('''
    The `dcc.Location` component represents the location or address bar in your web
    browser. Through its `href`, `pathname`, `search` and `hash` properties
    you can access different portions of the url that the app is loaded on.

    See the <dccLink href="/urls" children="URLs & Multipage Apps chapter"/>
    for more details.

    For example, given the url `http://127.0.0.1:8050/page-2?a=test#quiz`:

    - `href` = `"http://127.0.0.1:8050/page-2?a=test#quiz"`
    - `pathname` = `"/page-2"`
    - `search` = `"?a=test"`
    - `hash` = `"#quiz"`
    '''),

    rc.ComponentReference('Location')
])
