
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([

    rc.Markdown('''
    # DataTable Dropdowns

    The DataTable includes support for per-column and
    per-cell dropdowns. In future releases, this will
    be tightly integrated with a more formal typing system.

    For now, use the dropdown renderer as a way to limit the
    options available when editing the values with an editable table.

    '''),

    html.H2('DataTable with Per-Column Dropdowns'),
    rc.Markdown(
        examples['dropdown_per_column.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['dropdown_per_column.py'][1],
        className='example-container'
    ),

    html.H2('DataTable with Per-Row Dropdowns'),
    rc.Markdown(
        examples['dropdown_per_row.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['dropdown_per_row.py'][1],
        className='example-container'
    ),

])
