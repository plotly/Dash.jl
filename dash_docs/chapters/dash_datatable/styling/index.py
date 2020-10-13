from collections import OrderedDict
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd

import dash_table
from dash_docs import reusable_components as rc

data = OrderedDict(
    [
        ("Date", ["2015-01-01", "2015-10-24", "2016-05-10", "2017-01-10", "2018-05-10", "2018-08-15"]),
        ("Region", ["Montreal", "Toronto", "New York City", "Miami", "San Francisco", "London"]),
        ("Temperature", [1, -20, 3.512, 4, 10423, -441.2]),
        ("Humidity", [10, 20, 30, 40, 50, 60]),
        ("Pressure", [2, 10924, 3912, -10, 3591.2, 15]),
    ]
)

df = pd.DataFrame(data)

data_election = OrderedDict(
    [
        (
            "Date",
            [
                "July 12th, 2013 - July 25th, 2013",
                "July 12th, 2013 - August 25th, 2013",
                "July 12th, 2014 - August 25th, 2014",
            ],
        ),
        (
            "Election Polling Organization",
            ["The New York Times", "Pew Research", "The Washington Post"],
        ),
        ("Rep", [1, -20, 3.512]),
        ("Dem", [10, 20, 30]),
        ("Ind", [2, 10924, 3912]),
        (
            "Region",
            [
                "Northern New York State to the Southern Appalachian Mountains",
                "Canada",
                "Southern Vermont",
            ],
        ),
    ]
)

df_election = pd.DataFrame(data_election)
df_long = pd.DataFrame(
    OrderedDict([(name, col_data * 10) for (name, col_data) in data.items()])
)
df_long_columns = pd.DataFrame(
    {
        "This is Column {} Data".format(i): [1, 2]
        for i in range(10)
    }
)

Display = rc.CreateDisplay({
    'dash_table': dash_table,
    'df': df,
    'df_election': df_election,
    'df_long': df_long,
    'df_long_columns': df_long_columns,
    'pd': pd
})


layout = html.Div(
    children=[
        rc.Markdown("""
        # Styling the DataTable

        ## Default Styles

        By default, the DataTable has grey headers and borders
        around each cell. It resembles a spreadsheet and the headers are
        clearly defined.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
        )
        """),

        rc.Markdown("""
        ## Column Alignment

        When displaying numerical data, it's a good practice to use
        monospaced fonts, to right-align the data, and to provide the same
        number of decimals throughout the column.

        > To learn about formatting numbers and dates, see the
        > <dccLink href="/datatable/typing" children="data types section"/>

        For textual data, left-aligning the text is usually easier to read.

        In both cases, the column headers should have the same alignment
        as the cell content.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell={'textAlign': 'left'},
            style_cell_conditional=[
                {
                    'if': {'column_id': 'Region'},
                    'textAlign': 'left'
                }
            ]
        )
        """),

        rc.Markdown("""
        ## Styling the Table as a List

        The gridded view is a good default view for an editable table as it
        looks and feels like a spreadsheet.
        If your table isn't editable, then in many cases it can look cleaner
        without the vertical grid lines.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_cell_conditional=[
                {
                    'if': {'column_id': c},
                    'textAlign': 'left'
                } for c in ['Date', 'Region']
            ],

            style_as_list_view=True,
        )
        """),

        rc.Markdown("""
        ## List Style with Minimal Headers

        In some contexts, the grey background can look a little heavy.
        You can lighten this up by giving it a white background and
        a bold text.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_as_list_view=True,
            style_cell={'padding': '5px'},
            style_header={
                'backgroundColor': 'white',
                'fontWeight': 'bold'
            },
            style_cell_conditional=[
                {
                    'if': {'column_id': c},
                    'textAlign': 'left'
                } for c in ['Date', 'Region']
            ],
        )
        """),

        rc.Markdown("""
        ## Striped Rows

        When you're viewing datasets where you need to compare values within
        individual rows, it can sometimes be helpful to give the rows
        alternating background colors.
        We recommend using colors that are faded so as to
        not attract too much attention to the stripes.

        Notice the three different groups you can style: "cell" is the whole
        table, "header" is just the header rows, and "data" is just the data rows.
        To use even/odd or other styling based on `row_index` you must use
        `style_data_conditional`.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],

            style_cell_conditional=[
                {
                    'if': {'column_id': c},
                    'textAlign': 'left'
                } for c in ['Date', 'Region']
            ],
            style_data_conditional=[
                {
                    'if': {'row_index': 'odd'},
                    'backgroundColor': 'rgb(248, 248, 248)'
                }
            ],
            style_header={
                'backgroundColor': 'rgb(230, 230, 230)',
                'fontWeight': 'bold'
            }
        )
        """),

        rc.Markdown("""
        ## Multi-Headers

        Multi-headers are natively supported in the `DataTable`.
        Just set `name` inside `columns` as a list of strings instead of a
        single string and toggle `merge_duplicate_headers=True`.
        `DataTable` will check the neighbors of each header row and, if they
        match, will merge them into a single cell automatically.
        """),
        Display("""
        dash_table.DataTable(
            columns=[
                {"name": ["", "Year"], "id": "year"},
                {"name": ["City", "Montreal"], "id": "montreal"},
                {"name": ["City", "Toronto"], "id": "toronto"},
                {"name": ["City", "Ottawa"], "id": "ottawa"},
                {"name": ["City", "Vancouver"], "id": "vancouver"},
                {"name": ["Climate", "Temperature"], "id": "temp"},
                {"name": ["Climate", "Humidity"], "id": "humidity"},
            ],
            data=[
                {
                    "year": i,
                    "montreal": i * 10,
                    "toronto": i * 100,
                    "ottawa": i * -1,
                    "vancouver": i * -10,
                    "temp": i * -100,
                    "humidity": i * 5,
                }
                for i in range(10)
            ],
            merge_duplicate_headers=True,
        )
        """),

        rc.Markdown("""
        ## Dark Theme with Cells

        You have full control over all of the elements in the table.
        If you are viewing your table in an app with a dark background,
        you can provide inverted background and font colors.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],

            style_header={'backgroundColor': 'rgb(30, 30, 30)'},
            style_cell={
                'backgroundColor': 'rgb(50, 50, 50)',
                'color': 'white'
            },
        )
        """),

        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],

            style_as_list_view=True,
            style_header={'backgroundColor': 'rgb(30, 30, 30)'},
            style_cell={
                'backgroundColor': 'rgb(50, 50, 50)',
                'color': 'white'
            },
        )
        """),

        rc.Markdown("""
        ## Conditional Formatting

        See the new [conditional formatting chapter](/datatable/conditional-formatting).

        ## Styles Priority

        There is a specific order of priority for the style\_\* properties.
        If there are multiple style_* props, the one with higher priority will
        take precedence. Within each prop, rules for higher indices will be
        prioritized over those for lower indices. Previously applied styles of equal
        priority win over later ones (applied top to bottom, left to right).

        These are the priorities of style_* props, in decreasing order:

            1. style_data_conditional
            2. style_data
            3. style_filter_conditional
            4. style_filter
            5. style_header_conditional
            6. style_header
            7. style_cell_conditional
            8. style_cell
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_header={ 'border': '1px solid black' },
            style_cell={ 'border': '1px solid grey' },
        )
        """),

        rc.Markdown("""
        ## Adding Borders

        Customize the table borders by adding `border` to style_* props.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[{'id': c, 'name': c} for c in df.columns],
            style_data={ 'border': '1px solid blue' },
            style_header={ 'border': '1px solid pink' },
        )
        """),

        rc.Markdown("""
        ## Styling Editable Columns

        Editable columns can be styled using  `column_editable` in
        style_header_conditional, style_filter_conditional, and
        style_data_conditional props.
        """),
        Display("""
        dash_table.DataTable(
            data=df.to_dict('records'),
            columns=[
                {'id': c, 'name': c, 'editable': (c == 'Humidity')}
                for c in df.columns
            ],
            style_data_conditional=[{
                'if': {'column_editable': False},
                'backgroundColor': 'rgb(30, 30, 30)',
                'color': 'white'
            }],
            style_header_conditional=[{
                'if': {'column_editable': False},
                'backgroundColor': 'rgb(30, 30, 30)',
                'color': 'white'
            }],
        )
        """)
    ]
)
