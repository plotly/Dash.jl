library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  backendPaging = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/backendPaging.R'),
  backendPagingWithSorting = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/backendPagingWithSorting.R'),
  backendPagingWithMultiSorting = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/backendPagingWithMultiSorting.R'),
  backendPagingWithFiltering = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/backendPagingWithFiltering.R'),
  backendPagingWithFilteringMultiSorting = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/backendPagingWithFilteringMultiSorting.R'),
  filteringSortingwithGraph = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/part4/examples/filteringSortingwithGraph.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# DataTable - R Callbacks

## Backend Paging

With backend paging, we can load data into our table progressively.
Instead of loading all of the data at once,
we'll only load data as the user requests it
when they click on the \"previous\" and \"next\" buttons.

Since backend paging integrates directly with your Dash callbacks,
you can load your data from any R data source.
              "),

    examples$backendPaging$source_code,
    examples$backendPaging$layout,

    htmlHr(),

    dccMarkdown("
With backend paging, we can have front-end sorting and filtering,
but it will only filter and sort the data that exists on the page.

This should be avoided.
Your users might expect that sorting and filtering is
happening on the entire dataset and, with large pages,
might not be aware that this is only occuring on the current page.

Instead, we recommend implementing sorting and filtering on the backend as well.
ie, on the entire dataset.

**Note for returning users - changed property names:**

- Sorted fields are now in `sort_by`, not `sorting_settings`

- The filter string is now in `filter`, not `filtering_settings`

## Backend Paging with Sorting
              "),

    examples$backendPagingWithSorting$source_code,
    examples$backendPagingWithSorting$layout,


    dccMarkdown("
## Backend Paging with Multi-Column Sorting

`dashDataTable` also supports sorting by multiple columns.
This is useful when you have categorical columns with repeated values and
you're interested in seeing the sorted values for each category.

In this example, try sorting by continent and then any other column.
              "),

    examples$backendPagingWithMultiSorting$source_code,
    examples$backendPagingWithMultiSorting$layout,

    dccMarkdown("
## Backend Paging with Filtering

DataTable's front-end filtering has its own filtering expression language.

Currently, backend filtering must parse the same filtering language.
If you write an expression that is not \"valid\" under the filtering language,
then it will not be passed to the backend.

This limitation will be removed in the future to allow you to
write your own expression query language.

In this example, we've written a Pandas backend for the filtering language.
It supports `eq`, `<`, and `>`. For example, try:

- Enter `eq Asia` in the \"continent\" column

- Enter `> 5000` in the \"gdpPercap\" column

- Enter `< 80` in the \"lifeExp\" column

> Note that unlike the front-end filtering,
> our back-end filtering expression language doesn't require or support `num()` or
> wrapping items in double quotes (\").
> We will improve this syntax in the future, follow [dash-table#169](https://github.com/plotly/dash-table/issues/169) for more.

              "),
    examples$backendPagingWithFiltering$source_code,
    examples$backendPagingWithFiltering$layout,

    dccMarkdown("
## Backend Paging with Filtering and Multi-Column Sorting
              "),

    examples$backendPagingWithFilteringMultiSorting$source_code,
    examples$backendPagingWithFilteringMultiSorting$layout,

    dccMarkdown("
## Connecting Backend Paging with a Graph

This final example ties it all together:
the graph component displays the current page of the `data`.
              "),

    examples$filteringSortingwithGraph$source_code,
    examples$filteringSortingwithGraph$layout,

    htmlHr(),
    dccMarkdown("[Back to DataTable Documentation](/datatable)"),
    dccMarkdown("[Back to Dash Documentation](/)")

  )
)
