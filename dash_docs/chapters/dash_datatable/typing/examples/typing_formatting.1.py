# -*- coding: utf-8 -*-
import dash
import dash_html_components as html
import dash_table
import dash_table.FormatTemplate as FormatTemplate
from dash_table.Format import Sign
import pandas as pd
from collections import OrderedDict

app = dash.Dash(__name__)

df_typing_formatting = pd.DataFrame(OrderedDict([
    ('city', ['Vancouver', 'Toronto', 'Calgary', 'Ottawa', 'Montreal', 'Halifax', 'Regina', 'Fredericton']),
    ('average_04_2018', [1092000, 766000, 431000, 382000, 341000, 316000, 276000, 173000]),
    ('change_04_2017_04_2018', [0.143, -0.051, 0.001, 0.083, 0.063, 0.024, -0.065, 0.012]),
]))

app.layout = html.Div([
    dash_table.DataTable(
        id='typing_formatting_1',
        data=df_typing_formatting.to_dict('rows'),
        columns=[{
            'id': 'city',
            'name': 'City',
            'type': 'text'
        }, {
            'id': 'average_04_2018',
            'name': 'Average Price ($)',
            'type': 'numeric',
            'format': FormatTemplate.money(0)
        }, {
            'id': 'change_04_2017_04_2018',
            'name': 'Variation (%)',
            'type': 'numeric',
            'format': FormatTemplate.percentage(1).sign(Sign.positive)
        }],
        editable=True
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
