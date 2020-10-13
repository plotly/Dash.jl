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
        rc.Markdown(
        '''
        # DataTable Height

        By default, the table's height will expand in order
        to render up to 250 rows.
        After 250 rows, the table will display a **pagination** UI
        which enables viewing of up to 250 rows at a time.
        '''
        ),

        rc.Markdown(
        '''
        ## Setting Table Height with Pagination

        If you are using pagination, you can control the height by displaying
        fewer rows at a time. Instead of 250 rows, you could display
        10 rows at a time. By default and without wrapping,
        each row takes up 30px. So 10 rows with one header would set the
        table to be 330px tall. The pagination UI itself is around 60px tall.
        '''),

        Display(
        '''
        df = df_long # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            page_size=10
        )
        '''),

        rc.Markdown(
        '''
        <blockquote>
        In this example, the pagination is done natively in the browser:
        all of the data are sent up front to the browser and
        Dash renders new pages as you click on the buttons. You can also
        do pagination in the backend so that only 10 rows are sent to the
        browser at a time (lowering network costs and memory). This is a good
        strategy if you have more than 10,000-50,000 rows.
        <dccLink children="Learn about backend pagination" href="/datatable/callbacks"/>.
        </blockquote>
        '''
        ),

        rc.Markdown(
        '''
        ## Setting Table Height with Vertical Scroll

        If the table contains less than roughly 1000 rows,
        one option is to remove pagination,
        constrain the height, and display a vertical scrollbar.

        '''),

        Display(
        '''
        df = df_long # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            page_action='none',
            style_table={'height': '300px', 'overflowY': 'auto'}
        )
        '''),

        rc.Markdown(
        '''
        **Limitations**

        If you have more than 1000 rows, then the browser will slow
        down when trying to render the table. With more than 1000 rows, we
        recommend switching to browser or server pagination (as above) or
        virtualization (as below).
        '''
        ),

        rc.Markdown(
        '''
        ### Vertical Scroll With Pagination

        If you have more than ~1000 rows, then you could keep pagination at
        the bottom of the table, constrain the height, and display a
        vertical scrollbar.
        '''),

        Display(
        '''
        df = df_long # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            page_size=20,  # we have less data in this example, so setting to 20
            style_table={'height': '300px', 'overflowY': 'auto'}
        )
        '''),

        rc.Markdown(
        '''
        ### Vertical Scroll With Fixed Headers

        You can also fix headers so that the table content scrolls but the
        headers remain visible.
        '''),

        Display(
        '''
        df = df_long # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_rows={'headers': True},
            style_table={'height': 400}  # defaults to 500
        )
        '''),

        rc.Markdown(
        '''
        **Limitations**


        1. Percentage-based column widths is not available with `fixed_rows` & `table-layout: fixed`.
        See [plotly/dash-table#745](https://github.com/plotly/dash-table/issues/748)
        2. Percentage-based widths with `fixed_rows` and without `table-layout: fixed`
        has some issues when resizing the window. See [plotly/dash-table#747](https://github.com/plotly/dash-table/issues/747)
        3. If <dccLink children="filtering" href="/datatable/filtering"/> is enabled, then horizontal
        scroll does not work with wide tables. [plotly/dash-table#746](https://github.com/plotly/dash-table/issues/746)
        4. If a column header is wider than the data within that column and the
            table's container isn't wide enough to display the headers,
            then the column will be as wide as the data and the header text
            will either be truncated (most browsers) or overflow onto the next column (Firefox).
            This is a bug ([plotly/dash-table#432](https://github.com/plotly/dash-table/issues/432)).
            The current workaround is to hide the overflow or
            <dccLink children="fix the width of the columns in pixels" href="/datatable/width"/>.
            When using this workaround, you may run into a few of these issues:

            1. In those scenarios where the header is cut off, it is not possible
            to set ellipses within the header. For updates, see [plotly/dash-table#735](https://github.com/plotly/dash-table/issues/735)
            2. When the text is truncated, it is useful to display tooltips displaying the
            entire text. It is not yet possible to add tooltips to headers.
            For updates, see [plotly/dash-table#295](https://github.com/plotly/dash-table/issues/295)
            3. If the header text is truncated, then the header overflow is visible.
            The current workaround is to hide the overflow with `overflow: 'hidden'`.
        '''
        ),

        rc.Markdown(
        '''
        **Example of the wide-header limitation**

        If the headers are wider than the cells and the table's
        container isn't wide enough to display all of the headers,
        then the column headers will be truncated on most browsers or
        will overflow on Firefox.
        '''
        ),

        Display(
        '''
        df = df_numeric # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_rows={'headers': True}
        )
        '''),

        rc.Markdown(
        '''
        **Workaround Option 1: Hiding the header overflow for Firefox users**

        (If you are not on Firefox, then this example will look the same as above)
        '''),

        Display(
        '''
        df = df_numeric # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_rows={'headers': True},
            style_header={
                'overflow': 'hidden',
                'textOverflow': 'ellipsis',
                'maxWidth': 0,
            },
        )
        '''),

        rc.Markdown(
        '''
        **Workaround Option 2: Fixing the width of the columns**
        '''),

        Display(
        '''
        df = df_numeric # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            fixed_rows={'headers': True},
            style_cell={
                'minWidth': 95, 'maxWidth': 95, 'width': 95
            }
        )
        '''),

        rc.Markdown(
        '''
        ### Vertical Scroll with Virtualization

        As mentioned above, the browser has difficulty rendering thousands of
        rows in a table. By rendering rows _on the fly_ as you scroll,
        virtualization works around rendering performance issues
        inherent with the web browser.

        All of the data for your table will still be sent over the network
        to the browser, so if you are displaying more than 10,000-100,000 rows
        you may consider using <dccLink href="/datatable/callbacks" children="backend pagination"/>
        to reduce the volume of data that is transferred over the network
        and associated memory usage.
        '''),

        Display(
        '''
        df = df_numeric # no-display
        result = dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            virtualization=True,
            fixed_rows={'headers': True},
            style_cell={'minWidth': 95, 'width': 95, 'maxWidth': 95},
            style_table={'height': 300}  # default is 500
        )
        '''),

        rc.Markdown(
        '''
        **Limitations**

        1. With virtualization, the browser doesn't know the width of the columns
        in advance; it can only determine the width of the columns when they
        are rendered. So, your columns may change size as you scroll unless
        you <dccLink href="/datatable/width" children="fix the column widths"/>.
        2. Since, with virtualization, we're rendering rows _on the fly_ as we scroll,
        the rendering performance will be slower than the browser-optimized
        native vertical scrolling. If you scroll quickly, you may notice that
        table appears momentarily blank until rendering has completed.
        3. The same `fixed_rows` limitations exist as mentioned above.
        '''
        ),

    ]
)
