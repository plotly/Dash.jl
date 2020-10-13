# -*- coding: utf-8 -*-
import dash
import dash_html_components as html
import dash_table
from dash_table.Format import Format, Scheme, Sign, Symbol
import pandas as pd
from collections import OrderedDict

app = dash.Dash(__name__)

df_typing_formatting = pd.DataFrame(OrderedDict([
    ('city', ['NYC', 'Montreal', 'Los Angeles']),
    ('max', [108, 99, 111]),
    ('max_date', ['1926-07-22', '1975-08-01', '1939-09-20']),
    ('min', [-15, -36, 28]),
    ('min_date', ['1934-02-09', '1957-01-15', '1913-01-07'])
]))

app.layout = html.Div([
    dash_table.DataTable(
        id='typing_formatting',
        data=df_typing_formatting.to_dict('rows'),
        columns=[{
            'id': 'city',
            'name': 'City',
            'type': 'text'
        }, {
            'id': 'max',
            'name': u'Max Temperature (˚F)',
            'type': 'numeric',
            'format': Format(
                precision=0,
                scheme=Scheme.fixed,
                symbol=Symbol.yes,
                symbol_suffix=u'˚F'
            ),
            # equivalent manual configuration
            # 'format': {
            #     'locale': {
            #         'symbol': ['', '˚F']
            #     },
            #     'specifier': '$.0f'
            # }
        }, {
            'id': 'max_date',
            'name': 'Max Temperature (Date)',
            'type': 'datetime'
        }, {
            'id': 'min',
            'name': u'Min Temperature (˚F)',
            'type': 'numeric',
            'format': Format(
                nully='N/A',
                precision=0,
                scheme=Scheme.fixed,
                sign=Sign.parantheses,
                symbol=Symbol.yes,
                symbol_suffix=u'˚F'
            ),
            # equivalent manual configuration
            # 'format': {
            #     'locale': {
            #         'symbol': ['', '˚F']
            #     },
            #     'nully': 'N/A'
            #     'specifier': '($.0f'
            # }
            'on_change': {
                'action': 'coerce',
                'failure': 'default'
            },
            'validation': {
                'default': None
            }
        }, {
            'id': 'min_date',
            'name': 'Min Temperature (Date)',
            'type': 'datetime',
            'on_change': {
                'action': 'none'
            }
        }],
        editable=True,
        style_table={'overflowX': 'scroll'}
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
