library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  columnDropdowns = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part7/examples/columnDropdowns.R'),
  rowDropdowns = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part7/examples/rowDropdowns.R')
)

layout <- htmlDiv(
  list(

    dccMarkdown("
# DataTable Dropdowns

The DataTable includes support for per-column and per-cell dropdowns.
In future releases, this will be tightly integrated with a more formal typing system.

For now, use the dropdown renderer as a way to limit the options available
when editing the values with an editable table.

## DataTable with Per-Column Dropdowns
                "),

    examples$columnDropdowns$source_code,
    examples$columnDropdowns$layout,

    dccMarkdown("
## DataTable with Per-Row Dropdowns
                "),

    examples$rowDropdowns$source_code,
    examples$rowDropdowns$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
