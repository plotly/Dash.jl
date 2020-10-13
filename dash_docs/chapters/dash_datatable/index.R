library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
#components <- new.env()
#source('dash_docs/components.R', local=components)

examples <- list(
  quickStart = utils$LoadExampleCode('dash_docs/chapters/dash_datatable/examples/quickStart.R')
)

layout <- htmlDiv(
  list(
    htmlH1("Dash DataTable"),
    htmlIframe(
      src = "https://ghbtns.com/github-btn.html?user=plotly&repo=dash-table&type=star&count=true&size=large",
      width = "160px",
      height = "30px",
      style = list(border = 'none')
    ),
    dccMarkdown("
    > *Dash DataTable is an interactive table component designed for viewing,
    > editing, and exploring large datasets.*
    >
    > *DataTable is rendered with standard,
    > semantic HTML* `<table/>` *markup, which makes it accessible,
    > responsive, and easy to style.*
    >
    > *7 months in the making, this is the most complex Dash component that Plotly has written,
    > all from the ground-up using React and TypeScript.
    > DataTable was designed with a featureset that allows
    > that Dash users to create complex, spreadsheet driven applications with no compromises.
    > We're excited to continue to work with users and companies that
    > [invest in DataTable's future](https://plotly.com/products/consulting-and-oem/?_ga=2.1935537.1022559183.1559571095-1541667138.1549398001).*
    >
    > *DataTable is in* `Alpha`.* This is more of a statement on the DataTable API rather than on its features.
    > The table currently works beautifully and is already used in production at F500 companies.
    > However, we expect to make a few more breaking changes to its API and behavior within the next couple of months.
    > Once the community feels good about its API, we'll lock it down and we'll commit to reducing the frequency of
    > breaking changes. Please subscribe to
    > [dash-table#207](https://github.com/plotly/dash-table/issues/207) and
    > the [CHANGELOG.md](https://github.com/plotly/dash-table/blob/master/CHANGELOG.md) to
    > stay up-to-date with any breaking changes.*
    >
    > *So, check out DataTable and let us know what you think. Or even better,
    > share your DataTable Dash apps on the
    > [community forum](https://community.plotly.com/t/show-and-tell-community-thread/7554?_ga=2.70598800.1022559183.1559571095-1541667138.1549398001)!*
    >
    > -- chriddyp
    "),

    components$Header("Quickstart"),
    examples$quickStart$source,
    examples$quickStart$layout,

    components$Header("Dash DataTable User Guide"),
    components$Chapter(
    "Part 1: Sizing",
    "datatable/sizing",
    "
    All about sizing the DataTable. Examples include:
    - Setting the width and the height of the table
    - Responsive table design
    - Setting the widths of individual columns
    - Handling long text
    - Fixing rows and columns
    "
    ),
    components$Chapter(
    "Part 2: Styling",
    "datatable/style",
    "
    The style of the DataTable is highly customizable.
    This chapter includes examples for:
    - Conditional formatting
    - Displaying multiple rows of headers
    - Highlighting rows, columns, and cells
    - Styling the table as a list view
    - Changing the colors (including a dark theme!)
    The sizing API for the table has been particularly tricky for us to
    nail down, so be sure to read this chapter to understand the nuances,
    limitations, and the APIs that we're exploring.
    "
    ),
    components$Chapter(
    "Part 3: Sorting, Filtering, Selecting and Paging",
    "datatable/interactivity",
    "
    The DataTable is interactive.
    This chapter demonstrates the interactive features of the table and
    how to wire up these interations to R callbacks.
    These actions include:
    - Paginating
    - Selecting Rows
    - Sorting Columns
    - Filtering Data
    "
    ),
    components$Chapter(
    "Part 4: Sorting, Filtering, Selecting and Paginating with R",
    "datatable/callbacks",
    "
    In this part of the documentation, the paginating, sorting, and filtering were done entirely clientside (in the browser).
    This means that you need to load all of the data into the table up-front. If your data file is large,
    then this can be prohibitively slow.

    In this chapter, you'll learn how to write your own filtering, sorting, and paging backends in R with Dash.
    We'll do the data processing with `dplyr` but you could write your own routines with SQL or even generate the data on the fly!
    "
    ),
    components$Chapter(
    "Part 5: Typing",
    "datatable/typing",
    "
    In this chapter, you'll learn how to configure the table to
    - assign the column type
    - change the data presentation
    - change the data formatting
    - validate or coerce user data input
    - apply default behavior for valid and invalid data
    "
    ),
    components$Chapter(
    "Part 6: Editable Tables",
    "datatable/editable",
    "
    The DataTable is editable. Like a spreadsheet,
    it can be used as an input for controlling models with a variable number of inputs.

    This chapter includes recipes for:
    - Determining which cell has changed
    - Filtering out null values
    - Adding or removing columns
    - Adding or removing rows
    - Ensuring that a minimum set of rows are visible
    - Running computations on certain columns or cells
    "
    ),
    components$Chapter(
    "Part 7: Rendering Cells as Dropdowns",
    "datatable/dropdowns",
    "
    Cells can be rendered as editable dropdowns.
    This is our first step in bringing a full typing system to the table.
    Rendering cells as dropdowns introduces some complexity in the markup,
    so there are a few limitations that you should be aware of.
    "
    ),
    components$Chapter(
    "Part 8: Virtualization",
    "datatable/virtualization",
    "
    Examples using DataTable virtualization.
    "
    ),
    components$Chapter(
    "Part 9: Filtering Syntax",
    "datatable/filtering",
    "
    An explanation and examples of filtering syntax for both frontend and backend filtering in the DataTable.
    "
    ),
    components$Chapter(
    "Part 10: Table Reference",
    "datatable/reference",
    "
    The full list of Table properties and their settings can be achieved by
    `help('dashDataTable')` or https://dash.plotly.com/datatable/reference
    "
    ),

    components$Header("Roadmap, Sponsorships, and Contact"),
    dccMarkdown("
    Immediately, we're working on stability, virtualization,
    and a first-class data type system.
    Check out [our roadmap project board](https://github.com/orgs/plotly/projects/12)
    to see what's coming next.

    Many thanks to all of our customers
    who have sponsored the development of this table.
    Interested in steering the roadmap?
    [Get in touch](https://plotly.com/products/consulting-and-oem/?_ga=2.243244741.679498514.1560782796-1541667138.1549398001)
    "),

    htmlHr(),
    dccMarkdown("[Back to the Table of Contents](/)")
  )
)
