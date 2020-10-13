import dash_html_components as html
import dash_core_components as dcc
import dash_table

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc


examples = tools.load_examples(__file__)

Display = rc.CreateDisplay({
    'dash_table': dash_table,
})


layout = html.Div([

    rc.Markdown(
        '''
        # Editable DataTable

        The DataTable is editable. Like a spreadsheet, it can be used
        as an input for controlling models with a variable number
        of inputs.

        This chapter includes recipes for:

        - Reading the contents of the DataTable
        - Filtering out null values
        - Uploading data
        - Determining which cell has changed
        - Adding or removing columns
        - Adding or removing rows
        - Clearable, deletable, renamable, and hideable columns
        - Export DataTable
        '''
    ),

    rc.Markdown('***'),

    rc.Markdown(
        '''
        ## Predefined Columns

        In this example, we initialize a table with 10 blank rows and
        a few predefined columns. To retrieve the data, just listen to the
        `data` property.

        A few notes:
        - If you copy and paste data that is larger than the rows, then the
        table will expand to contain the contents.
        Try it out by [copying and pasting this dataset](https://docs.google.com/spreadsheets/d/1MWj7AjngD_fH7vkVhEMIRo51Oty295kE36-DFnQElrg/edit?usp=sharing).
        - Unlike other spreadsheet programs, the DataTable has a fixed number of
        rows. So, if your model has an arbitrary number of parameters
        (rows or columns), we recommend initializing your table with a
        large number of empty rows and columns.
        - When copying data from the table to an external spreadsheet or
        between two tables in different tabs, you can choose to include column headers
        by adding `include_headers_on_copy_paste=True`. However, headers are ignored
        when copying between two tables in the same tab.
        '''
    ),

    rc.Markdown('''
    # Editable DataTable

    The DataTable is editable. Like a spreadsheet, it can be used
    as an input for controlling models with a variable number
    of inputs.

    This chapter includes recipes for:

    - Reading the contents of the DataTable
    - Filtering out null values
    - Uploading data
    - Determining which cell has changed
    - Adding or removing columns
    - Adding or removing rows
    - Clearable, deletable, renamable, and hideable columns
    - Export DataTable

    ***

    ## Predefined Columns

    In this example, we initialize a table with 10 blank rows and
    a few predefined columns. To retrieve the data, just listen to the
    `data` property.

    A few notes:
    - If you copy and paste data that is larger than the rows, then the
    table will expand to contain the contents.
    Try it out by [copying and pasting this dataset](https://docs.google.com/spreadsheets/d/1MWj7AjngD_fH7vkVhEMIRo51Oty295kE36-DFnQElrg/edit?usp=sharing).
    - Unlike other spreadsheet programs, the DataTable has a fixed number of
    rows. So, if your model has an arbitrary number of parameters
    (rows or columns), we recommend initializing your table with a
    large number of empty rows and columns.
    - When copying data from the table to an external spreadsheet or
    between two tables in different tabs, you can choose to include column headers
    by adding `include_headers_on_copy_paste=True`. However, headers are ignored
    when copying between two tables in the same tab.
    '''),

    rc.Markdown(
        examples['editing_simple.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['editing_simple.py'][1],
        className='example-container'
    ),

    rc.Markdown('''
    ## Integration with Dash loading states

    As of table version 4.3.0, Dash loading states also have some
    control over whether the table is editable. If the `data` property
    is loading (e.g., while retrieving data from a server), you will
    be unable to edit the cells and the dropdowns. This avoids cases
    in which the edited value (input from the user) conflicts with the
    value that is returned by the server.

    In the example below, you can use the dropdown to choose to load
    either the `style_cell` property or the `data` property. When you
    select the property, there will be a simulated delay (to mimic a
    delay you might get when communicating with a server). Although
    this isn't the case in the example, you can also use the
    `.dash-loading` CSS selector to apply specific styling while the
    table is waiting.

    If you select `style_cell`, you'll be able to edit the cell as the
    value is loading; if you select `data`, you won't. Try it out
    yourself!

    '''),

    rc.Markdown(
        examples['editing_loading_state.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_loading_state.py'][1],
        className='example-container'
    ),


    rc.Markdown('''
    ## Filtering out Empty Cells
    The DataTable will always return all of the cells in the table, even
    if the cells haven't been filled out. So, you'll likely want to filter
    out the empty values.

    When you clear a cell, the DataTable will set its contents to `''`
    (emtpy string). So, for consistency, we recommend initializing your
    empty data with `''`.

    > Heads up! In the future, when we introduce proper data types,
    > we may initialize empty data as something other than `''`. For example,
    > if the column is numerical, we'll want to avoid having any `''` in the
    > data and we may initialize emty data to `None` instead.

    In this example, we prune away any rows that have empty cells in them.
    This is just one way to prune data; you may want to clean your data
    differently in your application.

    '''),

    rc.Markdown(
        examples['editing_prune_empty_cells.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_prune_empty_cells.py'][1],
        className='example-container'
    ),


    rc.Markdown('''
    ## Uploading Data

    A nice recipe is to tie the
    <code><dccLink href="/dash-core-components/upload" children="dcc.Upload"/></code>
    with the Table component. After the user has uploaded the data, they
    could edit the contents or rename the rows.

    Here's an example that creates a simple "x-y" plotter: upload a CSV
    with two columns of data and we'll plot it.
    Try it out by [downloading this file](https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv)
    and then uploading it.
    '''
    ),

    rc.Markdown(
        examples['editing_uploading.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_uploading.py'][1],
        className='example-container'
    ),

    rc.Markdown(
    '''
    ## Adding or removing columns

    In the DataTable, we've provided a built-in UI for _deleting_ columns
    but not for adding columns. We recommend using an external button to
    add columns.

    This is a simple example that plots the data in the spreadsheet as a
    heatmap. Try adding or removing columns!
    '''),

    rc.Markdown(
        examples['editing_columns.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_columns.py'][1],
        className='example-container'
    ),

    rc.Markdown(
    '''
    ## Adding or removing rows

    Similarly as columns, the DataTable has a built-in UI for removing rows
    but not for adding rows. You can add rows to the table through an
    external button.
    '''
    ),

    rc.Markdown(
        examples['editing_rows_and_columns.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_rows_and_columns.py'][1],
        className='example-container'
    ),

    rc.Markdown(
    '''
    ## Updating Columns of the Same Table

    One neat application of DataTable is being able to update the table itself
    when you edit cells.

    One of the limitations in Dash is that a callback's `Output` can't be
    the same as the `Input` (circular dependencies aren't supported yet).
    So, we couldn't have `Output('table', 'data')` _and_
    `Input('table', 'data')` in the same `@app.callback`.

    However, we can work around this by using `State('table', 'data')`
    and triggering the callback with `Input('table', 'data_timestamp')`.

    This example mimics a traditional spreadsheet like excel by computing
    certain columns based off of other other columns.
    '''
    ),

    rc.Markdown(
        examples['editing_updating_self.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['editing_updating_self.py'][1],
        className='example-container'
    ),

    rc.Markdown(
    '''
    ## Modify the data table content

    Columns in the table can be hidden, deleted, cleared, and renamed. Each of these actions
    are represented by a small icon in the column headers. If there is more than one header row,
    you can choose where the icons appear. If you want to override these icons, you can do so
    by using table css selectors, as demonstrated by the example.

    When the clear or delete action is performed, the associated filters are also cleared.
    Hiding or deleting can only be done if there are more than one column left in the
    table after the action is performed.

    In this example, we have included a variety of column actions. Try:

    - Clear the first column: the content is cleared (or multiple columns when headers are merged)
    without deleting the column itself.
    - Delete the second column: column is deleted from the table and can't be seen again unless the
    page is refreshed.
    - Rename the third column: the content of selected column headers is edited.
    - Hide the fourth column: the entire column is hidden from view and can be made visible again
    through the toggle columns button.

    '''
    ),

    Display(
        '''
        dash_table.DataTable(
            columns=[
                {"name": ["", "Year"], "id": "year", "clearable": "first" },
                {"name": ["City", "Montreal"], "id": "montreal", "deletable": [False, True]},
                {"name": ["City", "Toronto"], "id": "toronto", "renamable": True },
                {"name": ["City", "Ottawa"], "id": "ottawa", "hideable": "last"},
                {"name": ["City", "Vancouver"], "id": "vancouver", "clearable": True, "renamable": True, "hideable": True, "deletable": True },
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
            css=[
                {"selector": ".column-header--delete svg", "rule": 'display: "none"'},
                {"selector": ".column-header--delete::before", "rule": 'content: "X"'}
            ]
        )
        '''),

    rc.Markdown(
    '''
    ## Export Data Table
    The table data can be exported either as csv or xlsx file. You can customize table
    headers in the export file. Headers can be column ids, names or as displayed.
    The difference between `export_headers: name` and `export_headers: display` is that you have
    the option to download the table with merged headers if your table headers are merged.
    Finally, if an action was performed on columns (cleared, deleted,hidden, sorted, filtered), then
    the downloaded table will display the current view.

    - Note that `display` mode is only supported for `export_format: xlsx` due to the fact that
    headers in csv files can not be merged.
    '''
    ),

    Display(
        '''
        dash_table.DataTable(
            columns=[
                {"name": ["", "Year"], "id": "year" },
                {"name": ["City", "Montreal"], "id": "montreal", "deletable": [False, True]},
                {"name": ["City", "Toronto"], "id": "toronto", "renamable": True },
                {"name": ["City", "Ottawa"], "id": "ottawa", "hideable": "last"},
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
            export_format='xlsx',
            export_headers='display',
            merge_duplicate_headers=True
        )
        '''),

])
