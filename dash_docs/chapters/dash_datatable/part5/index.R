library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  example1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part5/examples/example1.R'),
  example2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part5/examples/example2.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# DataTable - Typing

This section will provide an overview of the DataTable's
capabilities for typing, formatting, presentation, and user input processing.

## Typing

The DataTable provides support for per-column typing and allows for
data validation and coercion behaviors to be
configured on a per-column basis, so as to fit the needs of various usage scenarios.

The following types are currently supported:

- `numeric`: includes both integers and floats

- `text`: string, sequence of characters

- `datetime`: string in the form 'YYYY-MM-DD HH:MM:SS.ssssss' or some truncation thereof

- `any`: any type of data

Additional types and specialized sub-types will be added in the future.

By default, the column type is `any`.

## Presentation

The DataTable provides multiple presentation schemes that can vary
depending on the column's type.

The following types are supported by all types:

- `input`: a text input field

- `dropdown`: see [DataTable Dropdowns] for more details
Additional presentations will be added in the future.

By default, the column presentation is `input`.

## User Input Processing

The DataTable provides a configurable input processing system that can accept,
reject or apply a default value when an input is provided.
It can be configured to validate or coerce the input to make it fit
with the expected data type.
Specific validation cases can be configured on a per-column basis.

See the table's [reference]
`on_change.action`, `on_change.failure` and `validation` column
nested properties for details.

## Formatting

The DataTable provides a configurable data formatting system that modifies
how the data is presented to the user.

The formatting can be configured by:

- explicitly writing the column `format` nested property

- using preconfigured Format Templates (only in Python at the moment)

- using the general purpose Format object

At the moment, only `type = 'numeric'` formatting can be configured.

## Examples

### DataTable with template formatting

This table contains two columns formatted by templates.
The `Variation (%)` column is further configured by changing the
sign behavior so that both the \"+\" and \"-\" sign are visible.
              "),

    examples$example1$source_code,
    examples$example1$layout,

    dccMarkdown("
### DataTable with Formatting

This table contains columns with type `numeric` and `datetime`.
The \"max\" columns have the default behavior and will not allow for
invalid data to be passed in. The \"min\" columns are more permissive.
The \"Min Temperature (F)\" column will default invalid entries to
`None` and display \"N/A\".
The \"Min Temperature (Date)\" column will not try to
validate or coerce the data.

Both temperature columns are using the manual configuration to
create the desired formatting.
              "),

    examples$example2$source_code,
    examples$example2$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
