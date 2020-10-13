import dash_html_components as html
import dash_table
from dash_docs import reusable_components as rc


layout = html.Div([
    html.H1(html.Code('dash_table.DataTable')),
    rc.ComponentReference('DataTable', dash_table)
])
