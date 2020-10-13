#!/usr/bin/env python
# -*- coding: utf-8 -*-
from collections import OrderedDict
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import numpy as np
import os

import dash_table
from dash_docs import reusable_components as rc
from dash_docs import tools

from dash_docs import datasets
from .heatmap_recipe import discrete_background_color_bins
discrete_background_color_bins_string = tools.read_file(os.path.join(
    os.path.dirname(__file__),
    'heatmap_recipe.py'
))
from .databars_recipes import data_bars, data_bars_diverging
databars_string = tools.read_file(os.path.join(
    os.path.dirname(__file__),
    'databars_recipes.py'
))

Display = rc.CreateDisplay({
    'discrete_background_color_bins': discrete_background_color_bins,
    'data_bars': data_bars,
    'data_bars_diverging': data_bars_diverging,
    'dash_table': dash_table,
    'html': html,
    'df_regions': datasets.df_regions,
    'df_election': datasets.df_election,
    'df_long': datasets.df_long,
    'df_long_columns': datasets.df_long_columns,
    'df_wide': datasets.df_wide,
    'df_gapminder': datasets.df_gapminder,
    'df_with_none': datasets.df_with_none,
    'pd': pd
})


layout = html.Div(
    children=[

        rc.Markdown("""
        # Conditional Formatting

        Conditional formatting is provided through the `style_data_conditional`
        property. The `if` keyword provides a set of conditional formatting
        statements and the rest of the keywords are camelCased CSS properties.

        The `if` syntax supports several operators, `row_index`, `column_id`,
        `filter_query`, `column_type`, `column_editable`, and `state`.

        `filter_query` is the most flexible option when dealing with data.

        Here is an example of all operators:
        """),

        Display("""
        df = df_regions # no-display
        df['id'] = df.index
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[
                {'name': 'Date', 'id': 'Date', 'type': 'datetime', 'editable': False},
                {'name': 'Delivery', 'id': 'Delivery', 'type': 'datetime'},
                {'name': 'Region', 'id': 'Region', 'type': 'text'},
                {'name': 'Temperature', 'id': 'Temperature', 'type': 'numeric'},
                {'name': 'Humidity', 'id': 'Humidity', 'type': 'numeric'},
                {'name': 'Pressure', 'id': 'Pressure', 'type': 'any'},
            ],
            editable=True,
            style_data_conditional=[
                {
                    'if': {
                        'column_id': 'Region',
                    },
                    'backgroundColor': 'dodgerblue',
                    'color': 'white'
                },
                {
                    'if': {
                        'filter_query': '{Humidity} > 19 && {Humidity} < 41',
                        'column_id': 'Humidity'
                    },
                    'backgroundColor': 'tomato',
                    'color': 'white'
                },

                {
                    'if': {
                        'column_id': 'Pressure',

                        # since using .format, escape { with {{
                        'filter_query': '{{Pressure}} = {}'.format(df['Pressure'].max())
                    },
                    'backgroundColor': '#85144b',
                    'color': 'white'
                },

                {
                    'if': {
                        'row_index': 5,  # number | 'odd' | 'even'
                        'column_id': 'Region'
                    },
                    'backgroundColor': 'hotpink',
                    'color': 'white'
                },

                {
                    'if': {
                        'filter_query': '{id} = 4',  # matching rows of a hidden column with the id, `id`
                        'column_id': 'Region'
                    },
                    'backgroundColor': 'RebeccaPurple'
                },

                {
                    'if': {
                        'filter_query': '{Delivery} > {Date}', # comparing columns to each other
                        'column_id': 'Delivery'
                    },
                    'backgroundColor': '#3D9970'
                },

                {
                    'if': {
                        'column_editable': False  # True | False
                    },
                    'backgroundColor': 'rgb(240, 240, 240)',
                    'cursor': 'not-allowed'
                },

                {
                    'if': {
                        'column_type': 'text'  # 'text' | 'any' | 'datetime' | 'numeric'
                    },
                    'textAlign': 'left'
                },

                {
                    'if': {
                        'state': 'active'  # 'active' | 'selected'
                    },
                   'backgroundColor': 'rgba(0, 116, 217, 0.3)',
                   'border': '1px solid rgb(0, 116, 217)'
                }

            ]
        )
        del df['id']  # no-display
        """),

        rc.Markdown(
        '''
        Notes:
        - `filter_query` supports different operators depending on the data type
        of the column:

          - `=`, `>`, `>=`, `<`, `<=`, and `contains` are supported by
          all data types (`numeric`, `text`, `datetime`, and `any`)
          - With `contains`, the right-hand-side needs to be a string,
          so `{Date} contains "01"` will work but `{Date} contains 1` will not.
          - `datestartswith` is supported by `datetime`
          - `is nil` is supported by all data types
          - `is blank` is supported by all data types

        - A column's default data type is `any`
        - `column_type` refers to the data type of the column (`numeric`, `text`, `datetime`, and `any`)
        - `column_editable` can be equal to `True` or `False` (new in Dash 1.12.0)
        - `state` can be equal to `'active'` or `'selected'` (new in Dash 1.12.0). Use this to change 
           the default pink background and border colors for selected and active cells.
        - `row_index` is absolute - if you filter or sort your table,
           the 5th row will remain highlighted. Try sorting the columns and
           notice how "San Francisco" remains highlighted but "London" does not.
        - `column_id`, `row_index`, and `header_index` can be equal to a scalar
        (as above) or a _list of values_. For example, `'column_id': ['Region', 'Pressure']`
        is valid (new in Dash 1.12.0). `DataTable` filtering & conditional formatting
        performs faster when specified a list of values vs a list of separate `if` blocks.
        - Note `'filter_query': '{Delivery} > {Date}'`: Filter queries can compare columns
        to each other!
        - `id` is a special hidden column that can be used as an alternative
        to `row_index` for highlighting data by index. Since each row has a
        unique `id`, the conditional formatting associated with this `id`
        will remain associated with that data after sorting and filtering.
        - `RebeccaPurple`, `hotpink`, `DodgerBlue`... These are
        [named CSS colors](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#Color_keywords).
        We recommend avoiding the common color names like
        `red`, `blue`, `green`  as they look very outdated. For other color
        suggestions, see [http://clrs.cc/](http://clrs.cc/).
        - Since we're using `.format`, we escape `{` with `{{` and `}` with `}}`.
        - To highlight a row, omit `column_id`. To highlight a particular cell, include `column_id`.
        - `style_cell_conditional` (all cells, including headers),
        `style_header_conditional` (header cells),
        `style_filter_conditional` (filter input boxes)
        are alternative keywords that can be used for filtering other parts of the table.
        - Limitation - If the table is editable, then the maximum value could change
        if the user edits the table. Since this example hard codes the
        maximum value in the filter expression, the highlighting value
        would no longer be highlighted. As a workaround, you could update
        `style_data_conditional` via a callback whenever `derived_virtual_data` changes.
        This limitation applies for any conditional formatting with hardcoded
        numbers computed from an expression in Python
        (including many of the examples below!).
        See [plotly/dash-table#755](https://github.com/plotly/dash-table/issues/755) for updates.
        '''
        ),

        rc.Markdown(
        '''
        ## Alternative Highlighting Styles

        Instead of highlighting the background cell, you can change the color
        of the text, bold the text, add underlines, or style it using any
        other css property.
        '''
        ),

        Display("""
        from dash_table.Format import Format, Sign

        df = df_regions # no-display

        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[
                {"name": i, "id": i} for i in df.columns
            ],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{Humidity} > 19 && {Humidity} < 41',
                        'column_id': 'Humidity'
                    },
                    'color': 'tomato',
                    'fontWeight': 'bold'
                },
                {
                    'if': {
                        'filter_query': '{Pressure} > 19',
                        'column_id': 'Pressure'
                    },
                    'textDecoration': 'underline'
                }
            ]
        )
        """),

        rc.Markdown(
        '''
        ### Special characters like emoji, stars, checkmarks, circles

        You can copy and paste emoji unicode characters directly into your code.
        We recommend copying values from emojipedia, e.g.
        [https://emojipedia.org/star/](https://emojipedia.org/star/).

        New unicode emoji characters are released every year and may not be
        available in the character sets of your audience's machines.
        The appearance of these icons differs on most operating systems.

        You may need to place `# -*- coding: utf-8 -*-` at the top of your code.
        '''
        ),

        Display("""
        # -*- coding: utf-8 -*-
        df = df_regions # no-display

        df['Rating'] = df['Humidity'].apply(lambda x:
            '⭐⭐⭐' if x > 30 else (
            '⭐⭐' if x > 20 else (
            '⭐' if x > 10 else ''
        )))
        df['Growth'] = df['Temperature'].apply(lambda x: '↗️' if x > 0 else '↘️')
        df['Status'] = df['Temperature'].apply(lambda x: '🔥' if x > 0 else '🚒')
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {"name": i, "id": i} for i in df.columns
            ],
        )

        del df['Status']  # no-display
        del df['Growth']  # no-display
        del df['Rating']  # no-display
        """),

        rc.Markdown(
        '''
        ## Filtering & Conditional Formatting Recipes

        ### Highlighting the max value in a column
        '''),
        Display("""
        df = df_regions # no-display

        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {"name": i, "id": i} for i in df.columns
            ],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{{Pressure}} = {}'.format(df['Pressure'].max()),
                        'column_id': 'Pressure'
                    },
                    'backgroundColor': '#FF4136',
                    'color': 'white'
                },
            ]
        )
        """),

        rc.Markdown('### Highlighting a row with the min value'),

        Display("""
        df = df_regions # no-display

        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {"name": i, "id": i} for i in df.columns
            ],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{{Temperature}} = {}'.format(df['Temperature'].min()),
                    },
                    'backgroundColor': '#FF4136',
                    'color': 'white'
                },
            ]
        )
        """),

        rc.Markdown('''
        ### Highlighting the top three or bottom three values in a column
        '''),

        Display("""
        df = df_regions # no-display

        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {"name": i, "id": i} for i in df.columns
            ],
            style_data_conditional=(
                [
                    {
                        'if': {
                            'filter_query': '{{Temperature}} = {}'.format(i),
                            'column_id': 'Temperature',
                        },
                        'backgroundColor': '#0074D9',
                        'color': 'white'
                    }
                    for i in df['Temperature'].nlargest(3)
                ] +
                [
                    {
                        'if': {
                            'filter_query': '{{Pressure}} = {}'.format(i),
                            'column_id': 'Pressure',
                        },
                        'backgroundColor': '#7FDBFF',
                        'color': 'white'
                    }
                    for i in df['Pressure'].nsmallest(3)
                ]
            )
        )
        """),

        rc.Markdown('''
        ### Highlighting the max value in every row
        '''),
        Display(
        """
        def highlight_max_row(df):
            df_numeric_columns = df.select_dtypes('number').drop(['id'], axis=1)
            return [
                {
                    'if': {
                        'filter_query': '{{id}} = {}'.format(i),
                        'column_id': col
                    },
                    'backgroundColor': '#3D9970',
                    'color': 'white'
                }
                # idxmax(axis=1) finds the max indices of each row
                for (i, col) in enumerate(
                    df_numeric_columns.idxmax(axis=1)
                )
            ]

        df = df_wide # no-display
        df['id'] = df.index
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns if i != 'id'],
            style_data_conditional=highlight_max_row(df)
        )

        del df['id']  # no-display
        """
        ),

        rc.Markdown('''
        ### Highlighting the top two values in a row
        '''),

        Display(
        '''
        def style_row_by_top_values(df, nlargest=2):
            numeric_columns = df.select_dtypes('number').drop(['id'], axis=1).columns
            styles = []
            for i in range(len(df)):
                row = df.loc[i, numeric_columns].sort_values(ascending=False)
                for j in range(nlargest):
                    styles.append({
                        'if': {
                            'filter_query': '{{id}} = {}'.format(i),
                            'column_id': row.keys()[j]
                        },
                        'backgroundColor': '#39CCCC',
                        'color': 'white'
                    })
            return styles

        df = df_wide  # no-display
        df['id'] = df.index
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns if i != 'id'],
            style_data_conditional=style_row_by_top_values(df)
        )

        del df_wide['id']  # no-display
        '''),

        rc.Markdown('''
        ### Highlighting the maximum value in the table
        '''),

        Display(
        '''
        def style_table_by_max_value(df):
            if 'id' in df:
                numeric_columns = df.select_dtypes('number').drop(['id'], axis=1)
            else:
                numeric_columns = df.select_dtypes('number')
            max_across_numeric_columns = numeric_columns.max()
            max_across_table = max_across_numeric_columns.max()
            styles = []
            for col in max_across_numeric_columns.keys():
                if max_across_numeric_columns[col] == max_across_table:
                    styles.append({
                        'if': {
                            'filter_query': '{{{col}}} = {value}'.format(
                                col=col, value=max_across_table
                            ),
                            'column_id': col
                        },
                        'backgroundColor': '#39CCCC',
                        'color': 'white'
                    })
            return styles


        df = df_wide  # no-display
        df['id'] = df.index
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns if i != 'id'],
            style_data_conditional=style_table_by_max_value(df)
        )

        del df_wide['id']  # no-display
        '''),

        rc.Markdown('''
        ### Highlighting a range of values
        '''),

        Display(
        '''
        df = df_wide  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{2018} >= 5 && {2018} < 10',
                        'column_id': '2018'
                    },
                    'backgroundColor': '#B10DC9',
                    'color': 'white'
                }
            ]
        )
        '''),

        Display(
        '''
        df = df_wide  # no-display

        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{{{col}}} >= 5 && {{{col}}} < 10'.format(col=col),
                        'column_id': col
                    },
                    'backgroundColor': '#B10DC9',
                    'color': 'white'
                } for col in df.columns
            ]
        )
        '''),
        rc.Markdown(
        '''
        _Let's break down `{{{col}}}`. We want the final expression to look something like
        `{2017} > 5 & {2017} < 10` where 2017 is the name of the column.
        Since we're using `.format()`, we need to escape the brackets,
        so `{2017}` would be `{{2017}}`. Then, we need to replace `2017` with `{col}`
        for the find-and-replace, so `{{2017}}` becomes `{{{col}}}.format(col=col)`_
        '''
        ),

        rc.Markdown('''
        ### Highlighting top 10% or bottom 10% of values by column
        '''),
        Display(
        '''
        df = df_wide  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{{{}}} >= {}'.format(col, value),
                        'column_id': col
                    },
                    'backgroundColor': '#B10DC9',
                    'color': 'white'
                } for (col, value) in df.quantile(0.9).iteritems()
            ]
        )
        '''),

        Display(
        '''
        df = df_wide  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns if i != 'id'],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{{{}}} <= {}'.format(col, value),
                        'column_id': col
                    },
                    'backgroundColor': '#B10DC9',
                    'color': 'white'
                } for (col, value) in df.quantile(0.1).iteritems()
            ]
        )
        '''),

        rc.Markdown('''
        ### Highlighting values above average and below average
        '''),

        rc.Markdown('Here, the highlighting is done _per column_'),
        Display(
        '''
        df = df_regions # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=(
                [
                    {
                        'if': {
                            'filter_query': '{{{}}} > {}'.format(col, value),
                            'column_id': col
                        },
                        'backgroundColor': '#3D9970',
                        'color': 'white'
                    } for (col, value) in df.quantile(0.1).iteritems()
                ] +
                [
                    {
                        'if': {
                            'filter_query': '{{{}}} <= {}'.format(col, value),
                            'column_id': col
                        },
                        'backgroundColor': '#FF4136',
                        'color': 'white'
                    } for (col, value) in df.quantile(0.5).iteritems()
                ]
            )
        )
        '''),

        rc.Markdown('Here, the highlighting is done _per table_'),
        Display(
        '''
        def highlight_above_and_below_max(df):
            df_numeric_columns = df.select_dtypes('number').drop(['id'], axis=1)
            mean = df_numeric_columns.mean().mean()
            return (
                [
                    {
                        'if': {
                            'filter_query': '{{{}}} > {}'.format(col, mean),
                            'column_id': col
                        },
                        'backgroundColor': '#3D9970',
                        'color': 'white'
                    } for col in df_numeric_columns.columns
                ] +
                [
                    {
                        'if': {
                            'filter_query': '{{{}}} <= {}'.format(col, mean),
                            'column_id': col
                        },
                        'backgroundColor': '#FF4136',
                        'color': 'white'
                    } for col in df_numeric_columns.columns
                ]
            )

        df = df_wide  # no-display
        df['id'] = df.index
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns if 'id' not in df],
            style_data_conditional=highlight_above_and_below_max(df)
        )
        del df_wide['id'] # no-display
        '''),

        rc.Markdown('### Highlighting None, NaN, or empty string values'),

        rc.Markdown('''
        Three filter queries help with empty or blank values:
        - `{my_column} is nil` will match `None` values
        - `{my_column} is blank` will match `None` values and empty strings
        - `{my_column} = ""` will match empty strings
        '''),

        Display(
        '''
        df = df_with_none
        result = html.Div([
            html.Pre(repr(df)),
            dash_table.DataTable(
                data=df.to_dict('records'),
                columns=[{'name': i, 'id': i} for i in df.columns],
                style_data_conditional=(
                    [
                        {
                            'if': {
                                'filter_query': '{{{}}} is blank'.format(col),
                                'column_id': col
                            },
                            'backgroundColor': 'tomato',
                            'color': 'white'
                        } for col in df.columns
                    ]
                )
            )
        ])
        '''
        ),

        rc.Markdown('''
        ### Displaying special values for `NaN` or `None` values
        '''),

        Display(
        '''
        from dash_table.Format import Format

        df = df_with_none
        result = html.Div([
            html.Pre(repr(df)),
            dash_table.DataTable(
                data=df.to_dict('records'),
                columns=[
                    {
                        'name': i,
                        'id': i,
                        'type': 'numeric',
                        'format': Format(
                            nully='N/A'
                        )
                    } for i in df.columns
                ],
                editable=True
            )
        ])
        '''
        ),

        rc.Markdown('''
        Limitations:
        - `Format(nully=)` does not yet match for empty strings, only
        `None` values. See [plotly/dash-table#763](https://github.com/plotly/dash-table/issues/763)
        for updates.
        - `'type': 'numeric'` needs to be set, see [plotly/dash-table#762](https://github.com/plotly/dash-table/issues/762)
        for updates.

        An alternative method would be to fill in e.g. 'N/A' in the data before rendering:
        '''),

        Display(
        '''
        from dash_table.Format import Format
        df = df_with_none
        df = df.fillna('N/A').replace('', 'N/A')
        result = html.Div([
            html.Pre(repr(df)),
            dash_table.DataTable(
                data=df.to_dict('records'),
                columns=[{'name': i, 'id': i} for i in df.columns],
                editable=True,
                style_data_conditional=[
                    {
                        'if': {
                            'filter_query': '{{{col}}} = "N/A"'.format(col=col),
                            'column_id': col
                        },
                        'backgroundColor': 'tomato',
                        'color': 'white'
                    } for col in df.columns
                ]
            )
        ])
        '''
        ),

        rc.Markdown(
        '''
        Limitation: If your table is editable, then if a user deletes the
        contents of a cell, 'N/A' will no longer be displayed.
        This is unlike the example with `Format` where the `DataTable` will
        automatically display `N/A` for any empty cells, even after editing.
        '''
        ),

        rc.Markdown('''
        ### Highlighting text that contains a value
        '''),

        Display(
        '''
        df = df_regions  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {'name': i, 'id': i} for i in df.columns
            ],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{Region} contains "New"'
                    },
                    'backgroundColor': '#0074D9',
                    'color': 'white'
                }
            ]
        )
        '''
        ),

        rc.Markdown('''
        ### Highlighting text that equals a value
        '''),

        Display(
        '''
        df = df_regions  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {'name': i, 'id': i} for i in df.columns
            ],
            style_data_conditional=[
                {
                    'if': {
                        'filter_query': '{Region} = "San Francisco"'
                    },
                    'backgroundColor': '#0074D9',
                    'color': 'white'
                }
            ]
        )
        '''
        ),

        rc.Markdown('''
        ### Highlighting cells by value with a colorscale like a heatmap
        '''),

        rc.Markdown(
        '''
        This recipe shades cells with `style_data_conditional` and creates a
        legend with HTML components. You'll need to `pip install colorlover`
        to get the colorscales.
        '''
        ),

        rc.Syntax(discrete_background_color_bins_string),

        Display(
        '''
        df = df_wide  # no-display
        (styles, legend) = discrete_background_color_bins(df)

        result = html.Div([
            html.Div(legend, style={'float': 'right'}),
            dash_table.DataTable(
                data=df.to_dict('records'),
                sort_action='native',
                columns=[{'name': i, 'id': i} for i in df.columns],
                style_data_conditional=styles
            ),
        ])
        '''
        ),

        rc.Markdown('''
        ### Highlighting with a colorscale on a single column
        '''),

        Display(
        '''
        df = df_wide  # no-display
        (styles, legend) = discrete_background_color_bins(df_wide, columns=['2018'])

        result = html.Div([
            legend,
            dash_table.DataTable(
                data=df.to_dict('records'),
                sort_action='native',
                columns=[{'name': i, 'id': i} for i in df.columns],
                style_data_conditional=styles
            )
        ])
        '''
        ),

        rc.Markdown('''
        ### Displaying data bars

        These recipes display a creative use of background `linear-gradient`
        colors to display horizontal bar charts within the table.
        Your mileage may vary! Feel free to modify these recipes for your own
        use.
        '''),

        rc.Syntax(databars_string),

        Display(
        '''
        df = df_gapminder[:500]  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=(
                data_bars(df, 'lifeExp') +
                data_bars(df, 'gdpPercap')
            ),
            style_cell={
                'width': '100px',
                'minWidth': '100px',
                'maxWidth': '100px',
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
            },
            page_size=20
        )
        '''
        ),

        rc.Markdown('''
        ### Data bars without text

        Display the data bars without text by creating a new column and making
        the text transparent.
        '''),

        Display(
        '''
        df_gapminder['gdpPercap relative values'] = df_gapminder['gdpPercap']
        df = df_gapminder[:500]  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=(
                data_bars(df, 'gdpPercap relative values') + [{
                    'if': {'column_id': 'gdpPercap relative values'},
                    'color': 'transparent'
                }]
            ),
            style_cell={
                'width': '100px',
                'minWidth': '100px',
                'maxWidth': '100px',
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
            },
            page_size=20
        )

        del df['gdpPercap relative values'] # no-display
        '''
        ),

        rc.Markdown('''
        ### Diverging data bars

        The `data_bars_diverging` function splits up the data into two quadrants
        by the midpoint.
        Alternative representations of data bars may split up the data by
        positive and negative numbers or by the average values.
        Your mileage may vary! Feel free to modify the `data_bars_diverging`
        function to your own visualization needs. If you create something new,
        please share your work on the [Dash Community Forum](https://community.plotly.com/tag/show-and-tell).
        '''),

        Display(
        '''
        df = df_gapminder[:500]  # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            sort_action='native',
            columns=[{'name': i, 'id': i} for i in df.columns],
            style_data_conditional=(
                data_bars_diverging(df, 'lifeExp') +
                data_bars_diverging(df, 'gdpPercap')
            ),
            style_cell={
                'width': '100px',
                'minWidth': '100px',
                'maxWidth': '100px',
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
            },
            page_size=20
        )
        '''
        ),

        rc.Markdown('''
        ### Highlighting dates
        '''),
        Display(
        '''
        df = df_regions # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {'name': i, 'id': i}
                if i != 'Date' else
                {'name': 'Date', 'id': 'Date', 'type': 'datetime'}
                for i in df.columns
            ],
            style_data_conditional=[{
                'if': {'filter_query': '{Date} datestartswith "2015-10"'},
                'backgroundColor': '#85144b',
                'color': 'white'
            }]
        )
        '''
        ),

    ]
)
