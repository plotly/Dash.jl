library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  virtualization = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part8/examples/virtualization.R')
)

layout <- htmlDiv(
  list(

    dccMarkdown("
# Virtualization

In addition to pagination, `DataTable` also has virtualization capabilities for viewing large datasets.
Virtualization saves browser resources while still permitting the user to scroll through
the entire dataset. It achieves this by only a rendering a subset of the data at any instant.

The virtualization backend makes a few assumptions about the style of your `DataTable`
which must be adhered to in order to ensure that the table scrolls smoothly.

- the width of the columns is fixed

- the height of the rows is always the same

- runtime styling changes will not affect width and height compared to the table's first rendering

The example below prevents runtime style changes by fixing the column widths and
setting the white-space CSS property in the cells to normal.
                "),

    examples$virtualization$source_code,
    examples$virtualization$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
