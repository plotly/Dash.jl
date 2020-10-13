from textwrap import dedent

import dash_core_components as dcc
import dash_html_components as html
from dash_docs import styles
from dash_docs import reusable_components as rc

def CreateDisplay(scope):
    def Display(example_string):
        return html.Div([
            rc.Markdown(
                '```py \n' + dedent(example_string).strip() + '\n ```',
                style={'marginBottom': 10, 'borderLeft': 'thin #C8D4E3 solid'}
            ),
            html.Div(
                children=eval(dedent(example_string), scope),
                style={
                    'border': 'thin lightgrey solid',
                    'margin-top': '-10px',
                    'padding': '15px'
                }
            )
        ])
    return Display


def merge(*args):
    merged = {}
    for arg in args:
        for key in arg:
            merged[key] = arg[key]
    return merged


def section_title(title):
    return html.H4(title, style={"marginTop": "20px"})


def PythonSnippet(code):
    if code and code[0] == '\n':
        code = code[1:]

    return rc.Markdown(
        '```py \n' + dedent(code) + '\n ```',
        style=styles.code_container
    )
