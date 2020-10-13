library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  addRemoveColumns = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/addRemoveColumns.R'),
  addRemoveRows = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/addRemoveRows.R'),
  filteringOutEmptyCells = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/filteringOutEmptyCells.R'),
  predefinedColumns = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/predefinedColumns.R'),
  updatingColumnsofSameTable = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/updatingColumnsofSameTable.R'),
  uploadData = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part6/examples/uploadData.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# Editable DataTable

The DataTable is editable. Like a spreadsheet, it can be used as an input for controlling models with a variable number of inputs.

This chapter includes recipes for:

- Reading the contents of the DataTable

- Filtering out null values

- Uploading data

- Determining which cell has changed

- Adding or removing columns

- Adding or removing rows
                "),

    htmlHr(),

    dccMarkdown("
## Predefined Columns

In this example, we initialize a table with 10 blank rows and a few predefined columns.
To retrieve the data, just listen to the `data` property.

A few notes:

- If you copy and paste data that is larger than the rows,
then the table will expand to contain the contents.
Try it out by [copying and pasting this dataset](https://docs.google.com/spreadsheets/d/1MWj7AjngD_fH7vkVhEMIRo51Oty295kE36-DFnQElrg/edit#gid=0).

- Unlike other spreadsheet programs,
the DataTable has a fixed number of rows.
So, your model has an arbitrary number of parameters (rows or columns),
we recommend initializing your table with a large number of empty rows and columns.
                "),


    examples$predefinedColumns$source_code,
    examples$predefinedColumns$layout,

    dccMarkdown("
## Filtering out Empty Cells

The DataTable will always return all of the cells in the table,
even if the cells haven't been filled out. So, you'll likely want to filter out the empty values.

When you clear a cell, the DataTable will set its contents to `''` (emtpy string).
So, for consistency, we recommend initializing your empty data with `''`.

> Heads up! In the future, when we introduce proper data types,
> we may initialize empty data as something other than `''`.
> For example, if the column is numerical, we'll want to avoid having any `''` in the data
> and we may initialize emty data to `None` instead.

In this example, we prune away any rows that have empty cells in them.
This is just one way to prune data, you may want to clean your data differently in your application.
                "),

    examples$filteringOutEmptyCells$source_code,
    examples$filteringOutEmptyCells$layout,

    dccMarkdown("
## Uploading Data

A nice recipe is to tie the `dccUpload` with the Table component. After the user has uploaded the data,
they could edit the contents or rename the rows.

Here's an example that creates a simple \"x-y\" plotter:
upload a CSV with two columns of data and we'll plot it.
Try it out by [downloading this file](https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv)
and then uploading it.
                "),

    examples$uploadData$source_code,
    examples$uploadData$layout,

    dccMarkdown("
## Adding or removing columns

In the DataTable, we've provided a built-in UI for deleting columns but not for adding columns.
We recommend using an external button to add columns.

This is a simple example that plots the data in the spreadsheet as a heatmap. Try adding or removing columns!
                "),

    examples$addRemoveColumns$source_code,
    examples$addRemoveColumns$layout,

    dccMarkdown("
## Adding or removing rows

Similarly as columns, the DataTable has a built-in UI for removing rows
(however, there is currently no corresponding UI for adding rows).
You can add rows to the table through an external button.
                "),

    examples$addRemoveRows$source_code,
    examples$addRemoveRows$layout,

    dccMarkdown("
## Updating Columns of the Same Table

One neat application of DataTable is being able to update the table itself when you edit cells.

One of the limitations in Dash is that a callback's `output` can't be the same as
the `input` (circular dependencies aren't supported yet).
So, we couldn't have `output('table', 'data')` and `input('table', 'data')` in the same `app$callback`.

However, we can work around this by using `state('table', 'data')` and
triggering the callback with `input('table', 'data_timestamp')`.

This example mimics a traditional spreadsheet like excel by
computing certain columns based off of other other columns.
                "),

    examples$updatingColumnsofSameTable$source_code,
    examples$updatingColumnsofSameTable$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
