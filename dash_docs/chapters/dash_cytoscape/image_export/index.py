import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([

    rc.Markdown('''
    # Exporting Images in JPG, PNG and SVG

    Starting from v0.2.0, you can now export your cytoscape graphs using callbacks.
    The following app shows this new feature in action:
    '''),

    rc.Markdown(
        examples['usage-image-export.py'][0],
        style=styles.code_container
    )
])
