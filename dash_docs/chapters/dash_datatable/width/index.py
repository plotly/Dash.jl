from collections import OrderedDict
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd

import dash_table
from dash_docs import reusable_components as rc
from dash_docs import datasets

Display = rc.CreateDisplay({
    'dash_table': dash_table,
    'html': html,
    'df': datasets.df_regions,
    'df_regions': datasets.df_regions,
    'df_election': datasets.df_election,
    'df_long': datasets.df_long,
    'df_long_columns': datasets.df_long_columns,
    'df_15_columns': datasets.df_15_columns,
    'df_moby_dick': datasets.df_moby_dick,
    'df_numeric': datasets.df_numeric,
    'pd': pd
})


layout = html.Div(
    children=[

        html.H1('DataTable Width & Column Width'),

        html.H2('Default Width'),
        rc.Markdown(
        '''
        By default, the table will expand to the width of its container.
        The width of the columns is determined automatically in order to
        accommodate the content in the cells.
        '''
        ),
        Display(
        '''
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns]
        )
        '''
        ),

        html.Hr(),

        rc.Markdown(
        '''
        The default styles work well for a small number of columns and short
        text. However, if you are rendering a large number of columns or
        cells with long contents, then you'll need to employ one of the
        following overflow strategies to keep the table within its container.
        '''
        ),

        rc.Markdown(
        '''
        ## Wrapping onto Multiple Lines

        If your cells contain contain text with spaces, then you can overflow
        your content into multiple lines.
        '''
        ),

        Display(
        '''
        dash_table.DataTable(
            style_cell={
                'whiteSpace': 'normal',
                'height': 'auto',
            },
            data=df_election.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df_election.columns]
        )
        '''),

        rc.Markdown(
        '''
        `style_cell` updates the styling for the data cells & the header cells.
        To specify header styles, use `style_header`.
        To specify data cell styles, use `style_data`.

        This example keeps the header on a single line while wrapping the data cells.
        '''
        ),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            style_data={
                'whiteSpace': 'normal',
                'height': 'auto',
            },
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns]
        )
        '''),

        rc.Markdown(
        '''
        ### Denser Multi-Line Cells with Line-Height

        If you are displaying lots of text in your cells, then you may want to
        make the text appear a little more dense by shortening up the line-height.
        By default (as above), it's around 22px. Here, it's 15px.
        '''
        ),
        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            style_data={
                'whiteSpace': 'normal',
                'height': 'auto',
                'lineHeight': '15px'
            },
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns]
        )
        '''),

        rc.Markdown(
        '''
        ### Wrapping onto Multiple Lines while Constraining the Height of Cells

        If your text is really long, then you can constrain the height of the
        cells and display a tooltip when hovering over the cell.
        '''
        ),
        Display(
        """
        df = df_moby_dick # no-display
        result = dash_table.DataTable(
            style_data={
                'whiteSpace': 'normal',
            },
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            css=[{
                'selector': '.dash-spreadsheet td div',
                'rule': '''
                    line-height: 15px;
                    max-height: 30px; min-height: 30px; height: 30px;
                    display: block;
                    overflow-y: hidden;
                '''
            }],
            tooltip_data=[
                {
                    column: {'value': str(value), 'type': 'markdown'}
                    for column, value in row.items()
                } for row in df.to_dict('rows')
            ],
            tooltip_duration=None,

            style_cell={'textAlign': 'left'} # left align text in columns for readability
        )
        """),

        rc.Markdown(
        '''
        Hover over the cells to see the tooltip.

        Why the `css`? Fixed height cells are tricky because, [by CSS 2.1 rules](https://www.w3.org/TR/CSS21/tables.html#height-layout),
        the height of a table cell is "the minimum height required by the content".
        So, here we are setting the height of the cell indirectly
        by setting the div _within_ the cell.

        In this example, we display two lines of data by setting the `line-height`
        to be 15px and the height of each cell to be 30px.
        The second sentence is cut off.

        There are a few **limitations** with this method:

        1. It is not possible to display ellipses with this method.
        2. It is not possible to set a max-height. All of the cells need to be
        the same height.

        Subscribe to [plotly/dash-table#737](https://github.com/plotly/dash-table/issues/737) for updates or other workarounds
        on this issue.
        '''
        ),

        rc.Markdown(
        """
        ## Overflowing Into Ellipses

        Alternatively, you can keep the content on a single line but display
        a set of ellipses if the content is too long to fit into the cell.

        Here, `max-width` is set to 0. It could be any number, the only
        important thing is that it is supplied. The behaviour will be
        the same whether it is 0 or 50.

        If you want to just hide the content instead of displaying ellipses,
        then set `textOverflow` to `'clip'` instead of `'ellipsis'`.
        """
        ),
        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell={
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
                'maxWidth': 0
            }
        )
        '''),

        rc.Markdown(
        '''
        > In the example above, ellipsis are not displayed for the header.
        > We consider this a bug, subscribe to [plotly/dash-table#735](https://github.com/plotly/dash-table/issues/735) for updates.
        '''),

        rc.Markdown(
        '''
        ### Ellipses & Tooltips

        If you are display text data that is cut off by ellipses, then you can
        include tooltips so that the full text appears on hover.

        By setting `tooltip_duration` to `None`, the tooltip will persist
        as long as the mouse pointer is above the cell, and it will disappear
        when the pointer moves away. You can override this by passing in
        a number in milliseconds (e.g. 2000 if you want it to disappear after
        two seconds).
        '''
        ),
        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell={
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
                'maxWidth': 0,
            },
            tooltip_data=[
                {
                    column: {'value': str(value), 'type': 'markdown'}
                    for column, value in row.items()
                } for row in df.to_dict('rows')
            ],
            tooltip_duration=None
        )
        '''),

        rc.Markdown(
        '''
        ## Horizontal Scroll

        Instead of trying to fit all of the content in the container, you could
        overflow the entire container into a scrollable container.
        '''
        ),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_table={'overflowX': 'auto'},
        )
        '''),

        rc.Markdown(
        '''
        Note how we haven't explicitly set the width of the individual columns
        yet. The widths of the columns have been computed dynamically depending
        on the width of the table and the width of the cell's contents.
        In the example above, by providing a scrollbar, we're effectively
        giving the table as much width as it needs in order to fit the entire
        width of the cell contents on a single line.

        '''
        ),

        rc.Markdown('### Horizontal Scroll with Fixed-Width Columns & Cell Wrapping'),

        rc.Markdown(
        '''
        Alternatively, you can fix the width of each column by adding `width`.
        In this case, the column's width will be constant, even if its contents
        are shorter or wider.
        '''
        ),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_table={'overflowX': 'auto'},
            style_cell={
                'height': 'auto',
                # all three widths are needed
                'minWidth': '180px', 'width': '180px', 'maxWidth': '180px',
                'whiteSpace': 'normal'
            }
        )
        '''),

        rc.Markdown('### Horizontal Scroll with Fixed-Width & Ellipses'),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_table={'overflowX': 'auto'},
            style_cell={
                # all three widths are needed
                'minWidth': '180px', 'width': '180px', 'maxWidth': '180px',
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
            }
        )
        '''),

        rc.Markdown(
        '''
        ### Horizontal Scrolling via Fixed Columns

        You can also add a horizontal scrollbar to your table by fixing
        the leftmost columns with `fixed_columns`.
        '''
        ),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_columns={'headers': True, 'data': 1},
            style_table={'minWidth': '100%'}
        )
        '''),

        rc.Markdown(
        '''
        Here is the same example but with *fixed-width cells & ellipses*.
        '''
        ),

        Display(
        '''
        df = df_election # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_columns={ 'headers': True, 'data': 1 },
            style_table={'minWidth': '100%'},
            style_cell={
                # all three widths are needed
                'minWidth': '180px', 'width': '180px', 'maxWidth': '180px',
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
            }
        )
        '''),


        rc.Markdown("## Setting Column Widths"),

        rc.Markdown(
        '''
        ### Percentage Based Widths

        The widths of individual columns can be supplied through the
        `style_cell_conditional` property. These widths can be specified as
        percentages or fixed pixels.
        '''
        ),

        Display(
        '''
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell_conditional=[
                {'if': {'column_id': 'Date'},
                 'width': '30%'},
                {'if': {'column_id': 'Region'},
                 'width': '30%'},
            ]
        )
        '''),

        Display(
        '''
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell_conditional=[
                {'if': {'column_id': 'Date'},
                 'width': '30%'},
                {'if': {'column_id': 'Region'},
                 'width': '30%'},
            ]
        )
        '''),

        rc.Markdown(
        '''
        By default, the column width is the maximum of the percentage given
        and the width of the content. So, if the content in the column is wide,
        the column may be wider than the percentage given. This prevents overflow.

        In the example below, note the first column is actually wider than 10%;
        if it were shorter, the text "New York City" would overflow.
        '''
        ),

        Display(
        '''
        html.Div([
            html.Div('10%', style={'backgroundColor': 'hotpink', 'color': 'white', 'width': '10%'}),
            dash_table.DataTable(
                data=df.to_dict('records'),
                columns=[{'id': c, 'name': c} for c in df.columns if c != 'Date'],
                style_cell_conditional=[
                    {'if': {'column_id': 'Region'},
                     'width': '10%'}
                ]
            )
        ])
        '''),

        rc.Markdown(
        '''
        To force columns to be a certain width (even if that causes overflow)
        use `table-layout: fixed`.

        ### Percentage Based Widths and `table-layout: fixed`
        If you want all columns to have the same percentage-based width,
        use `style_data` and `table-layout: fixed`.
        '''
        ),

        Display(
        '''
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],

            css=[{'selector': 'table', 'rule': 'table-layout: fixed'}],
            style_cell={
                'width': '{}%'.format(len(df.columns)),
                'textOverflow': 'ellipsis',
                'overflow': 'hidden'
            }
        )
        '''),

        rc.Markdown(
        '''
        Setting consistent percentage-based widths is a good option if you are using
        `virtualization`, sorting (`sort_action`), or `filtering` (`filter_action`).
        Without fixed column widths, the table will dynamically resize the
        columns depending on the width of the data that is displayed.

        **Limitations**

        1. Percentage-based widths is not available with `fixed_rows` & `table-layout: fixed`.
        See [plotly/dash-table#745](https://github.com/plotly/dash-table/issues/748)
        2. Percentage-based widths with `fixed_rows` and without `table-layout: fixed`
        has some issues when resizing the window. See [plotly/dash-table#747](https://github.com/plotly/dash-table/issues/747)
        '''
        ),

        rc.Markdown(
        '''
        ### Individual Column Widths with Pixels

        In this example, we set three columns to have fixed-widths. The remaining
        two columns will be take up the remaining space.
        '''),

        Display(
        '''
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell_conditional=[
                {'if': {'column_id': 'Temperature'},
                 'width': '130px'},
                {'if': {'column_id': 'Humidity'},
                 'width': '130px'},
                {'if': {'column_id': 'Pressure'},
                 'width': '130px'},
            ]
        )
        '''),

        rc.Markdown(
        '''
        ### Overriding a Single Column's Width

        You can set the width of all of the columns with `style_data` and
        override a single column with `style_cell_conditional`.
        '''
        ),

        Display(
        '''
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_data={
                'width': '100px',
                'maxWidth': '100px',
                'minWidth': '100px',
            },
            style_cell_conditional=[
                {
                    'if': {'column_id': 'Region'},
                    'width': '250px'
                },
            ],
            style_table={
                'overflowX': 'auto'
            }
        )
        '''),

    ]
)
