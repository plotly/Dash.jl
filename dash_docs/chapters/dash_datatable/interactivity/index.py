import dash_html_components as html
import dash_core_components as dcc

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(
    [

        rc.Markdown("""
        # DataTable Interactivity

        `DataTable` includes several features for modifying and transforming
        the view of the data. These include:

        - Sorting by column (`sort_action='native'`)
        - Filtering by column (`filter_action='native'`)
        - Editing the cells (`editable=True`)
        - Deleting rows (`row_deletable=True`)
        - Deleting columns (`columns[i].deletable=True`)
        - Selecting rows (`row_selectable='single' | 'multi'`)
        - Selecting columns (`column_selectable='single' | 'multi'` and `columns[i].selectable=True`)
        - Paging front-end (`page_action='native'`)
        - Hiding columns (`hidden_columns=[]`)

        A quick note on filtering. We have defined our own
        syntax for performing filtering operations. Here are some
        examples for this particular dataset:

        - Enter `Asia` in the "continent" column
        - Enter `> 5000` in the "gdpPercap" column
        - Enter `< 80` in the `lifeExp` column

        > Note: simple strings can be entered plain, but if you have
        > spaces or special characters (including `-`, particularly in dates)
        > you need to wrap them in quotes.
        > Single quotes `'`, double quotes `"`, or backticks `\\`` all work.
        > <dccLink href="/datatable/filtering" children="Full filter syntax reference"/>
        """),

        rc.Markdown("""
        By default, these transformations are done clientside.
        Your Dash callbacks can respond to these modifications
        by listening to the `data` property as an `Input`.

        Note that if `data` is an `Input` then the entire
        `data` will be passed over the network: if your dataframe is large,
        then this will become slow. For large dataframes, you can perform the
        <dccLink href="/datatable/callbacks" children="sorting or filtering in Python instead"/>.
        """),

        rc.Markdown(
            examples['interactivity_connected_to_graph.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['interactivity_connected_to_graph.py'][1],
            className='example-container'
        ),

        rc.Markdown("""
        ## Row IDs

        When using transformations - sorting, filtering, pagination - it can be
        difficult to match up rows - visible rows, selected rows, active rows -
        to the original data, because row indices may not have their original
        meaning. To simplify this logic we've added support for **Row IDs**.
        Each row of data can have an `'id'` key, which should contain a string
        or a number.
        If you want to display these values you can include a column with
        `id='id'`, but normally they stay hidden.
        All properties that list certain rows by index also have variants
        listing row IDs:
        - `derived_virtual_indices` / `derived_virtual_row_ids`: the order of
        rows across all pages (for front-end paging) after filtering and
        sorting.
        - `derived_viewport_indices` / `derived_viewport_row_ids`: the order of
        rows on the currently visible page.
        - `selected_rows` / `selected_row_ids`: when `row_selectable` is
        enabled and there is a checkbox next to each row, these are the
        selected rows. Note that even filtered-out or paged-out rows can remain
        selected.
        - `derived_virtual_selected_rows` / `derived_virtual_selected_row_ids`:
        the set of selected rows after filtering and sorting, across all pages
        - `derived_viewport_selected_rows` /
        `derived_viewport_selected_row_ids`: the set of selected rows on the
        currently visible page.

        Often several of these properties contain the same data, but in other
        cases it's important to choose the right one for the specific user
        interaction you have in mind. Do you want to respond to selected rows
        even when they're not on the current page? Even when they're filtered
        out?

        There are also properties that reference specific cells in the table.
        Along with the row and column indices, these include the row and
        column IDs of the cell:
        - `active_cell`: this is the data cell the user has put the cursor on,
        by clicking and/or arrow keys. It's a dictionary with keys:
            - `row`: the row index (integer) - may be affected by sorting,
            filtering, or paging transformations.
            - `column`: the column index (integer)
            - `row_id`: the `id` field of the row, which always stays with it
            during transformations.
            - `column_id`: the `id` field of the column.
        - `start_cell`: if the user selects multiple cells, by shift-click or
        shift-arrow-keys, this is where the selection was initiated. Has the
        same form as `active_cell`, and usually the same value although after
        selecting a region the user can change `active_cell` by pressing
        `<tab>` or `<enter>` to cycle through the selected cells.
        - `end_cell`: the corner of the selected region opposite `start_cell`.
        Also has the same form as `active_cell`.
        - `selected_cells`: an array of dicts, each one with the form of
        `active_cell`, listing each selected cell.

        Here's the same example, plus active cell highlighting, implemented
        using row IDs.
        One advantage here is that we don't need to pass the entire data set
        back, we can just pass the IDs.
        Even the full set of IDs is only necessary in order to sync with
        sorting and filtering.
        """),

        rc.Markdown(
            examples['interactivity_row_ids.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['interactivity_row_ids.py'][1],
            className='example-container'
        ),
    ]
)
