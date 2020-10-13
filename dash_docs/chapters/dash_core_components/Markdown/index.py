# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1("Markdown Examples and Reference"),
    html.H2("Headers"),
    rc.ComponentBlock("""import dash_core_components as dcc

dcc.Markdown('''

# This is an <h1> tag

## This is an <h2> tag

###### This is an <h6> tag
''')"""),
    html.H2("Emphasis"),
    rc.ComponentBlock("""import dash_core_components as dcc

dcc.Markdown('''
*This text will be italic*

_This will also be italic_


**This text will be bold**

__This will also be bold__

_You **can** combine them_
''')"""),
    html.Hr(),
    html.H2("Lists"),
    rc.ComponentBlock("""import dash_core_components as dcc

dcc.Markdown('''
* Item 1
* Item 2
  * Item 2a
  * Item 2b
''')"""),
    html.Hr(),
    html.H2("Block Quotes"),
    rc.ComponentBlock("""import dash_core_components as dcc

dcc.Markdown('''
>
> Block quotes are used to highlight text.
>

''')"""),
    html.Hr(),
    html.H2("Links"),
    rc.ComponentBlock("""import dash_core_components as dcc

dcc.Markdown('''
[Dash User Guide](/)
''')"""),
    html.Hr(),
    html.H2("Inline Code"),
    html.P("Any block of text surrounded by ` ` will rendered as inline-code. "),
    # Don't use ComponentBlock for markdown block quotes... too complicated to
    # get all the nested quotes right!
    rc.Markdown("""
    ````py
    import dash_core_components as dcc

    dcc.Markdown('''

    Inline code snippet: `True`

    Block code snippet:
    ```py
    import dash

    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    ```
    ''')
    ````
    """),
    html.Div(rc.Markdown('''

    Inline code snippet: `True`

    Block code snippet:
    ```py
    import dash

    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    ```
    '''), className='example-container'),

    rc.Markdown('''

    Only certain languages are supported by default in
    `dcc.Markdown`. For more details about how to customize the
    languages and colour schemes, please see ["Syntax Highlighting
    With
    Markdown"](https://dash.plot.ly/external-resources#md-syntax-highlight).
    '''),

    html.H2('dcc.Markdown Properties'),
    rc.ComponentReference('Markdown')
])
