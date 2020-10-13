library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  backendFiltering = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part9/examples/backendFiltering.R'),
  frontedFiltering = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part9/examples/frontedFiltering.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# DataTable Filtering

As discussed in the [interactivity chapter],
`DataTable` includes filtering capabilities.
Users can turn on filtering options by defining the `filtering` attribute.
`filter_action = 'native'` will initiate clientside (front-end) filtering.
If the DataTable is quite large, clientside filtering will likely become slow.
Using the back-end filtering option: `filter_action='custom'` will allow serverside filtering.

## Filtering Syntax

To filter on a column you can enter either an operator and a value (for example `> 5000`)
or just a value (`5000`) to use the default operator for that column's data type.

Simple strings can be entered plain:

- `= Asia` in the \"continent\" column

- `B` in the \"country\" column matches all countries that contain a capital B

But if you have spaces or special characters (including `-`, particularly in dates)
you need to wrap them in quotes. Single quotes ', double quotes `\"`, or backticks ` all work.

- `= \"Bosnia and Herzegovina\"`

- `>='2008-12-01'`

If you have quotes in the string, you can use a different quote, or escape the quote character.
So `eq \"Say 'Yes!'\"` and `=\"Say 'Yes!'\"` are the same.

Numbers can be entered plain (previously they needed to be wrapped in `num()`):

- `> 5000` in the \"gdpPercap\" column

- `< 80` in the \"lifeExp\" column

## Operators

Many operators have two forms: a symbol (`=`) and a word (`eq`) that can be used interchangeably.

+ `= eq` (Default operator for `number` columns): Are the two numbers equal? Regardless of type, will first try to convert both sides to numbers and compare the numbers.
If either cannot be converted to a number, looks for an exact match.

+ `contains` (Default operator for `text` and `any` columns): Does the text value contain the requested substring? May match the beginning, end, or anywhere in the middle.
The match is case-sensitive and exact.

+ `datestartswith` (Default operator for `datetime` columns): Does the datetime start with the given parts?
Enter a partial datetime, this will match any date that has at least as much precision
and starts with the same pieces. For example, `datestartswith '2018-03-01'` will match
`'2018-03-01 12:59'` but not `'2018-03'` even though we interpret `'2018-03-01'` and
`'2018-03'` both to mean the first instant of March, 2018.

+ `> gt` `< lt` `>= ge` `<= le` `!= ne`: Comparison: greater than, less than, greater or equal, less or equal, and not equal.
Two strings compare by their dictionary order,
with numbers and most symbols coming before letters,
and uppercase coming before lowercase.

## Frontend Filtering Example:
                "),

    examples$frontedFiltering$source_code,
    examples$frontedFiltering$layout,

    dccMarkdown("
## Back-end Filtering

For large dataframes, you can perform the filtering in R instead of the default clientside filtering.
You can find more information on performing operations in R in the
[DataTable - R Callbacks](/datatable/Part4).

The syntax is (now) the same as front-end filtering,
but it's up to the developer to implement the logic to apply these filters on the R side.
In the future we may accept any filter strings,
to allow you to write your own expression query language.

> Note: we're planning on adding a structured query object to make it easier and
> more robust to manage back-end filter logic.
> Follow [dash-table#169](https://github.com/plotly/dash-table/issues/169) for updates.

Example:
                "),

    examples$backendFiltering$source_code,
    examples$backendFiltering$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")
  )
)
