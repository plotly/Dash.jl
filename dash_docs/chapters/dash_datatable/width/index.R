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

df_election <- data.frame(
  Date = c("July 12th, 2013 - July 25th, 2013",
           "July 12th, 2013 - August 25th, 2013",
           "July 12th, 2014 - August 25th, 2014"),
  Election_Polling_Organization = c("The New York Times", "Pew Research", "The Washington Post"),
  Rep = c(1, -20, 3.512),
  Dem = c(10,20,30),
  Ind = c(2, 10924, 3912),
  Region = c("Northern New York State to the Southern Appalachian Mountains",
             "Canada",
             "Southern Vermont")
)

df_long <- df[rep(1:6, 10),]

examples <- list(
  example1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/example.R'),
  examplePseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/examplePseudo.R'),
  multipleLines = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/multipleLines.R'),
  multipleLinesPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/multipleLinesPseudo.R'),
  ellipses = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/ellipses.R'),
  ellipsesPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/ellipsesPseudo.R'),
  horizontalScroll1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScroll1.R'),
  horizontalScrollPseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScrollPseudo1.R'),
  horizontalScroll2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScroll2.R'),
  horizontalScrollPseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScrollPseudo2.R'),
  horizontalScroll3 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScroll3.R'),
  horizontalScrollPseudo3 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScrollPseudo3.R'),
  horizontalScroll4 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScroll4.R'),
  horizontalScrollPseudo4 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScrollPseudo4.R'),
  horizontalScroll5 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScroll5.R'),
  horizontalScrollPseudo5 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/horizontalScrollPseudo5.R'),
  fixedColumns1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedColumns1.R'),
  fixedColumnsPseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedColumnsPseudo1.R'),
  fixedColumns2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedColumns2.R'),
  fixedColumnsPseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedColumnsPseudo2.R'),
  individualColumnWidths1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/individualColumnWidths1.R'),
  individualColumnWidthsPseudo1 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/individualColumnWidthsPseudo1.R'),
  individualColumnWidths2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/individualColumnWidths2.R'),
  individualColumnWidthsPseudo2 = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/individualColumnWidthsPseudo2.R'),
  verticalScrolling = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/verticalScrolling.R'),
  verticalScrollingPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/verticalScrollingPseudo.R'),
  fixedRows = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedRows.R'),
  fixedRowsPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/fixedRowsPseudo.R'),
  maxHeight = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/maxHeight.R'),
  maxHeightPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/maxHeightPseudo.R'),
  height = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/height.R'),
  heightPseudo = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/width/examples/heightPseudo.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# DataTable Sizing

## Default Styles

By default, the table will expand to the width of its container.
The width of the columns is determined automatically in order to accommodate the content in the cells.
                "
    ),

    examples$examplePseudo1$source_code,
    examples$example1$layout,

    dccMarkdown("
> The examples on this page are rendered with a few different dataframes that have different sizes
> and shapes. In particular,
> some of the dataframes have a large number of columns or have cells with long contents.
> If you'd like to follow along on your own machine,
> then open up the menu below to copy and paste the code behind these datasets.
                "),

    htmlHr(),
    dccMarkdown("
The default styles work well for a small number of columns and short text.
However, if you are rendering a large number of columns or cells with long contents,
then you'll need to employ one of the following \"overflow strategies\" to keep the table within its container.

View Datasets
                "),

    dccMarkdown("
```
df_election <- data.frame(
  Date = c('July 12th, 2013 - July 25th, 2013',
           'July 12th, 2013 - August 25th, 2013',
           'July 12th, 2014 - August 25th, 2014'),
  Election_Polling_Organization = c('The New York Times',
                                    'Pew Research',
                                    'The Washington Post'),
  Rep = c(1, -20, 3.512),
  Dem = c(10,20,30),
  Ind = c(2, 10924, 3912),
  Region = c('Northern New York State to the Southern Appalachian Mountains',
             'Canada',
             'Southern Vermont')
)
```
              "),
  dccMarkdown("
## Overflow Strategies - Wrapping onto Multiple Lines

If your cells contain contain text with spaces,
then you can overflow your content into multiple lines.

> We find that this interface is a little too complex.
> We're looking at simplifying this in this issue: https://github.com/plotly/dash-table/issues/188
                "),
  examples$multipleLinesPseudo$source_code,
  examples$multipleLines$layout,

  dccMarkdown("
## Overflow Strategies - Overflowing Into Ellipses

Alternatively, you can keep the content on a single line but display a set of
ellipses if the content is too long to fit into the cell.

If you want to just hide the content instead of displaying ellipses,
then set `textOverflow` to `'clip'` instead of `'ellipsis'`.
                "),
  examples$ellipsesPseudo$source_code,
  examples$ellipses$layout,

  dccMarkdown("
## Overflow Strategies - Horizontal Scroll

Instead of trying to fit all of the content in the container,
you could change the container by making it scrollable.
                "),

  examples$horizontalScrollPseudo1$source_code,
  examples$horizontalScroll1$layout,

  dccMarkdown("
Note how we haven't explicitly set the widths of the individual columns yet.
The widths of the columns have been computed dynamically; they depend
on the width of the table and the width of the cells' contents.
In the example above, by providing a scrollbar,
we're effectively giving the table as much width as needs it in order to
fit the entire width of the cell contents on a single line.

We can combine some of these strategies by bounding the `maxWidth` of
a column and overflowing into multiple lines (or ellipses)
if the content exceeds that width while rendering the table
within a scrollable horizontal container.
If the contents of each cell within the column don't exceed the `maxWidth`,
then the column will only take up the necessary amount of horizontal space.
              "),

  examples$horizontalScrollPseudo2$source_code,
  examples$horizontalScroll2$layout,

  dccMarkdown("
Here is the same example but with fixed-width cells & ellipses.
  "),

  examples$horizontalScrollPseudo3$source_code,
  examples$horizontalScroll3$layout,

  dccMarkdown("
Alternatively, you can fix the width of each column by adding `width`.
In this case, the column's width will be constant, even if its contents are shorter or wider.
              "),

  examples$horizontalScrollPseudo4$source_code,
  examples$horizontalScroll4$layout,

  examples$horizontalScrollPseudo5$source_code,
  examples$horizontalScroll5$layout,

  dccMarkdown("
## Horizontal Scrolling via Fixed Columns

You can also add a horizontal scrollbar to your table by
fixing the leftmost columns with `fixed_columns`.
              "),

  examples$fixedColumnsPseudo1$source_code,
  examples$fixedColumns1$layout,

  examples$fixedColumnsPseudo2$source_code,
  examples$fixedColumns2$layout,

  dccMarkdown("
## Individual Column Widths

The widths of individual columns can be supplied through the `style_cell_conditional` property.
These widths can be specified as percentages or fixed pixels.
You can supply the widths for all of the columns or just a few of them.

View Datasets
              "),

  dccMarkdown("
```R
df <- data.frame(
  Date = c('2015-01-01', '2015-10-24', '2016-05-10',
           '2017-01-10', '2018-05-10', '2018-08-15'),
           Region = c('Montreal', 'Toronto', 'New York City',
                      'Miami', 'San Francisco', 'London'),
                      Temperature = c(1, -20, 3.512, 4, 10423, -441.2),
                      Humidity = seq(10, 60, by = 10),
                      pressure = c(2, 10924, 3912, -10, 3591.2, 15)
)
```
                       "),

examples$individualColumnWidthsPseudo1$source_code,
examples$individualColumnWidths1$layout,

examples$individualColumnWidthsPseudo2$source_code,
examples$individualColumnWidths2$layout,

dccMarkdown("
## Table Height and Vertical Scrolling

By default, the table's height will expand in order to render all of the rows.

You can constrain the height of the table
by setting a `maxHeight` and adding a scrollbar with
`overflowY = 'scroll'`. With `maxHeight`, the table's contents
will only become scrollable if the contents are taller than that height.

View Datasets"),

dccMarkdown("
```
df_long <- df[rep(1:6, 10),]
```
              "),

examples$verticalScrollingPseudo$source_code,
examples$verticalScrolling$layout,

dccMarkdown("
## Vertical Scrolling via Fixed Rows

In the example above, the headers become hidden when you scroll down.

You can keep these headers visible by supplying `fixed_rows = list(headers = TRUE, data = 0)`.

> Note that fixing rows introduces some changes to
> the underlying markup of the table and may impact the way
> that your columns are rendered or sized.
> In particular, you'll need to set an explicit pixel-based widths
> for each of the columns. For more information, subscribe to [`dash-table#201`](https://github.com/plotly/dash-table/issues/201).
              "),

examples$fixedRowsPseudo$source_code,
examples$fixedRows$layout,

dccMarkdown("
## Height vs Max Height
With `max-height`, if the table's contents are shorter than the
`max-height`, then the container will have the height of the table (plus any padding or margins you may have added).
If you want a container with a constant height
no matter the contents, then use `height`.

Here, we're setting max-height to 300, which corresponds to the height of the pink line.
Note how the table renders shorter than this line.
              "),

htmlDiv(
  style = list(width = 5,
               height = 300,
               backgroundColor = "hotpink")
),

examples$maxHeightPseudo$source_code,
examples$maxHeight$layout,

dccMarkdown("
Here, we are using the `height` property with the same content.
Note how the table's container takes up all 300px.
            "),
examples$heightPseudo$source_code,
examples$height$layout,

htmlHr(),
dccMarkdown("[Back to DataTable Documentation](/datatable)"),
dccMarkdown("[Back to Dash Documentation](/)")
  )
)
