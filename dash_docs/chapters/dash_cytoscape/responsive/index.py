import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([

    rc.Markdown('''
    # Building responsive Cytoscape graphs

    Starting from v0.2.0, you can make your cytoscape graph responsive:

    ```
    cyto.Cytoscape(
        id='cytoscape',
        ...,
        responsive=True
    )
    ```

    The following app shows this new feature in action:
    '''),


    rc.Markdown(
        examples['usage-responsive-graph.py'][0],
        style=styles.code_container
    )
])


