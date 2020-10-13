library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

df <- data.frame(
  Date = c("2015-01-01", "2015-10-24", "2016-05-10", "2017-01-10", "2018-05-10", "2018-08-15"),
  Region = c("Montreal", "Toronto", "New York City", "Miami", "San Francisco", "London"),
  Temperature = c(1, -20, 3.512, 4, 10423, -441.2),
  Humidity = seq(10, 60, by = 10),
  Pressure = c(2, 10924, 3912, -10, 3591.2, 15)
)

examples <- list(
  example = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/example.R'),
  examplePseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/examplePseudo.R'),
  highlight1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlight1.R'),
  highlightPseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlightPseudo1.R'),
  highlight2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlight2.R'),
  highlightPseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlightPseudo2.R'),
  highlight3 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlight3.R'),
  highlightPseudo3 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlightPseudo3.R'),
  highlight4 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlight4.R'),
  highlightPseudo4 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/highlightPseudo4.R'),
  darkTheme1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/darkTheme1.R'),
  darkThemePseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/darkThemePseudo1.R'),
  darkTheme2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/darkTheme2.R'),
  darkThemePseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/darkThemePseudo2.R'),
  stripedRows1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stripedRows1.R'),
  stripedRowsPseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stripedRowsPseudo1.R'),
  stripedRows2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stripedRows2.R'),
  stripedRowsPseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stripedRowsPseudo2.R'),
  columnAlignment = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/columnAlignment.R'),
  columnAlignmentPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/columnAlignmentPseudo.R'),
  minimalHeaders = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/minimalHeaders.R'),
  minimalHeadersPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/minimalHeadersPseudo.R'),
  multiHeaders = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/multiHeaders.R'),
  multiHeadersPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/multiHeadersPseudo.R'),
  stylingAsList = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylingAsList.R'),
  stylingAsListPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylingAsListPseudo.R'),
  stylesPriority = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylesPriority.R'),
  stylesPriorityPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylesPriorityPseudo.R'),
  addingBorders = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/addingBorders.R'),
  addingBordersPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/addingBordersPseudo.R'),
  stylingEditable = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylingEditable.R'),
  stylingEditablePseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part2/examples/stylingEditablePseudo.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# Styling the DataTable

## Default Styles

By default, the DataTable has grey headers and borders around each cell.
It resembles a spreadsheet and the headers are clearly defined.
    "),

    examples$examplePseudo$source_code,
    examples$example$layout,

    dccMarkdown("
## Column Alignment

When displaying numerical data,
it's a good practice to use monospace fonts,
to right-align the data, and to provide the same number of decimals throughout the column.

> Note that it's not possible to modify the number of decimal places in CSS.
> The `dashTable` package will provide formatting options in the future;
> until then, you'll have to modify your data before displaying it.
> Relevant issue: https://github.com/plotly/dash-table/issues/189

For textual data, left-aligning the text is usually easier to read.

In both cases, the column headers should have the same alignment as the cell content.
                "),

    examples$columnAlignmentPseudo$source_code,
    examples$columnAlignment$layout,

    dccMarkdown("
## Styling the Table as a List

The gridded view is a good default view for an editable table, as it looks and feels like a spreadsheet. If your table isn't editable,
then in many cases it can look cleaner without the vertical grid lines.
                "),

    examples$stylingAsListPseudo$source_code,
    examples$stylingAsList$layout,

    dccMarkdown("
## List Style with Minimal Headers

In some contexts, the grey background can look a little heavy.
You can lighten this up by giving it a white background and bold text.
                "),

    examples$minimalHeadersPseudo$source_code,
    examples$minimalHeaders$layout,

    dccMarkdown("
## Striped Rows

When you're viewing datasets where you need to compare values within individual rows, it can sometimes be helpful to give the rows alternating background colors. We recommend
using colors that are faded, so as to not attract too much attention to the stripes.
                "),

    examples$stripedRowsPseudo1$source_code,
    examples$stripedRows1$layout,
    examples$stripedRowsPseudo2$source_code,
    examples$stripedRows2$layout,

    dccMarkdown("
## Multi-Headers

Multi-headers are natively supported in the `dashDataTable`.
Just set `name` inside `columns` as a list of strings instead of a single string and
toggle `merge_duplicate_headers = TRUE`.
`dashDataTable` will check the neighbors of each header row and,
if they match, will merge them into a single cell automatically.
                "),

    examples$multiHeadersPseudo$source_code,
    examples$multiHeaders$layout,

    dccMarkdown("
## Dark Theme with Cells

You have full control over all of the elements in the table. If you are viewing your table in an app with a dark background,
you can provide inverted background and font colors.
                "),

    examples$darkThemePseudo1$source_code,
    examples$darkTheme1$layout,
    examples$darkThemePseudo2$source_code,
    examples$darkTheme2$layout,

    dccMarkdown("
## Conditional Formatting - Highlighting Certain Rows

You can draw attention to specific rows by providing
a unique background color, bold text, or colored text.
                "),

    examples$highlightPseudo1$source_code,
    examples$highlight1$layout,
    examples$highlightPseudo2$source_code,
    examples$highlight2$layout,

    dccMarkdown("
## Conditional Formatting - Highlighting Certain Columns

Similarly, specific columns can be highlighted.
                "),

    examples$highlightPseudo3$source_code,
    examples$highlight3$layout,

    dccMarkdown("
## Conditional Formatting - Highlighting Cells

You can also highlight specific cells.
For example, you may want to highlight certain cells
that exceed a threshold or that match a filter elsewhere
in the app.

The `filter` keyword in
`style_data_conditional` uses the same filtering expression
language as the table's interactive filter UI.
See the [DataTable filtering chapter](/datatable/Part9) for more info.

> Please note that, the filtering expression language is subject to change.
> Please subscribe to
[dash-table#169](https://github.com/plotly/dash-table/issues/169) to stay updated.
                "),

    examples$highlightPseudo4$source_code,
    examples$highlight4$layout,

    dccMarkdown("
## Styles Priority

There are a specific order of priority for the style_* properties.
If there are multiple style_* props,
the one with higher priority will take precedence. Within each props,
rules for higher index will be priorized over lower index rules.
Previously applied styles of equal priority will win over later ones
(applied top to bottom, left to right)

These are the prorioty of style_* props in decreasing orders:
```
1. style_data_conditional
2. style_data
3. style_filter_conditional
4. style_filter
5. style_header_conditional
6. style_header
7. style_cell_conditional
8. style_cell
```
                "),

    examples$stylesPriorityPseudo$source_code,
    examples$stylesPriority$layout,

    dccMarkdown("
## Adding Borders

You can customize the table borders by adding `border` to style_* props.
                "),

    examples$addingBordersPseudo$source_code,
    examples$addingBorders$layout,

    dccMarkdown("
## Styling editable

Editable column can be styled using `column_editable` in style_header_conditional,
style_filter_conditional, style_data_conditional props.
See the [Editable DataTable chapter](/datatable/Part6) for more info.
                "),

    examples$stylingEditablePseudo$source_code,
    examples$stylingEditable$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
