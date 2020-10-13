library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  button = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Button/examples/button.R'),
  tabs = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabs.R')
)

titleLink <- function(componentName) {
  return(htmlH2(dccLink(
    paste(componentName),
    href=paste('/dash-core-components/', tolower(componentName), sep='')
  )))
}

referenceLink <- function(componentName, Title) {
  return(dccLink(
    paste(Title),
    href=paste('/dash-core-components/', tolower(componentName), sep='')
  ))
}

layout <- htmlDiv(list(

htmlH1('Dash Core Components'),

dccMarkdown(
  " Dash ships with supercharged components for interactive user interfaces.
        A core set of components, written and maintained by the Dash team,
  is available in the `dashCoreComponents` package.
  The source is on GitHub at [plotly/dash-core-components](https://github.com/plotly/dash-core-components).
```{r}
install.packages('dashCoreComponents')
```
  "
),

htmlDiv(titleLink('Dropdown')),
utils$LoadAndDisplayComponent(
'library(dashCoreComponents)

dccDropdown(
  options=list(
    list(label = "New York City", value = "NYC"),
    list(label = "Montréal", value = "MTL"),
    list(label = "San Francisco", value = "SF")
  ),
  value="MTL"
)
'
),


utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)

dccDropdown(
  options=list(
    list(label = "New York City", value = "NYC"),
    list(label = "Montréal", value = "MTL"),
    list(label = "San Francisco", value = "SF")
  ),
  value = "MTL",
  multi = TRUE
)
  '
),
htmlBr(),
htmlDiv(referenceLink('Dropdown', 'More Dropdown Examples and Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('Slider')),
htmlDiv(list(utils$LoadAndDisplayComponent2(
  '
library(dashCoreComponents)
dccSlider(
  min = -5,
  max = 10,
  step = 0.5,
  value = -3,
)
  '
),

utils$LoadAndDisplayComponent2(
  '
library(dashCoreComponents)
dccSlider(
  min = 0,
  max = 9,
  marks = lapply(1:10, function(x){paste("Label", x)}),
  value = 5,
)
  '
)
), style = list('padding' = '5px',
                'margin' = '0 auto')),

htmlBr(),
htmlDiv(referenceLink('Slider', 'More Slider Examples and Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('RangeSlider')),
htmlDiv(list(utils$LoadAndDisplayComponent2(
  '
library(dashCoreComponents)
dccRangeSlider(
  count = 1,
  min = -5,
  max = 10,
  step = 0.5,
  value = list(-3, 7)
)
  '
),

htmlDiv(list(utils$LoadAndDisplayComponent2(
  '
library(dashCoreComponents)
dccRangeSlider(
  marks = setNames(lapply(-5:6, function(x) 
    paste("Label", x)), as.character(-5:6)),
  min = -5,
  max = 6,
  value = list(-3,4)
)
  '
)),
style = list('overflow' = 'hidden'))
)),
htmlBr(),
htmlDiv(referenceLink('RangeSlider', 'More RangeSlider Examples and Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('Input')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccInput(
  placeholder = "Enter a value...",
  type = "text",
  value = ""
)
  '
))),

htmlBr(),
htmlDiv(referenceLink('Input', 'More Input Examples and Reference')),
htmlHr(),

#--------------------------------
htmlDiv(titleLink('Textarea')),

htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccTextarea(
  placeholder = "Enter a value...",
  value = "This is a TextArea component",
  style = list("width" = "100%")
)
  '
))),
htmlBr(),
htmlDiv(referenceLink('Textarea', 'Textarea Reference')),
htmlHr(),

#--------------------------------
htmlDiv(titleLink('Checklist')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccChecklist(
  options=list(
    list("label" = "New York City", "value" = "NYC"),
    list("label" = "Montréal", "value" = "MTL"),
    list("label" = "San Francisco", "value" = "SF")
  ),
  value=list("MTL", "SF")
)
  '
),

utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccChecklist(
  options=list(
    list("label" = "New York City", "value" = "NYC"),
    list("label" = "Montréal", "value" = "MTL"),
    list("label" = "San Francisco", "value" = "SF")
  ),
  value=list("MTL", "SF"),
  labelStyle = list("display" = "inline-block")
)
  '
)
)),
htmlBr(),
htmlDiv(referenceLink('Checklist', 'Checklist Properties')),
htmlHr(),

#--------------------------------
htmlDiv(titleLink('Radioitems')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccRadioItems(
  options=list(
    list("label" = "New York City", "value" = "NYC"),
    list("label" = "Montréal", "value" = "MTL"),
    list("label" = "San Francisco", "value" = "SF")
  ),
  value = "MTL"
)
  '
),

utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccRadioItems(
  options=list(
    list("label" = "New York City", "value" = "NYC"),
    list("label" = "Montréal", "value" = "MTL"),
    list("label" = "San Francisco", "value" = "SF")
  ),
  value = "MTL",
  labelStyle = list("display" = "inline-block")
)
  '
)
)),
htmlBr(),
htmlDiv(referenceLink('Radioitems', 'RadioItems Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('Button')),
examples$button$source,
examples$button$layout,

htmlBr(),
htmlDiv(referenceLink('Button', 'More Button Examples and Reference')),

#--------------------------------

htmlDiv(titleLink('DatePickerSingle')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccDatePickerSingle(
  id="date-picker-single",
  date=as.Date("1997/5/10")
)
  '
))),

htmlBr(),
htmlDiv(referenceLink('DatePickerSingle', 'More DatePickerSingle Examples and Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('DatePickerRange')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccDatePickerRange(
  id = "date-picker-range",
  start_date = as.Date("1997/5/10"),
  end_date_placeholder_text="Select a date!"
)

  '
))),

#--------------------------------

htmlBr(),
htmlDiv(referenceLink('DatePickerRange', 'More DatePickerRange Examples and Reference')),
htmlHr(),

htmlDiv(titleLink('Markdown')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
dccMarkdown("
Dash supports [Markdown](http://commonmark.org/help).
Markdown is a simple way to write and format text.
It includes a syntax for things like **bold text** and *italics*,
[links](http://commonmark.org/help), inline `code` snippets, lists,
quotes, and more.
")

  '
))),
htmlBr(),
htmlDiv(referenceLink('Markdown', 'More Markdown Examples and Reference')),
htmlHr(),

#--------------------------------
htmlDiv(htmlH3('Interactive Tables')),


htmlDiv(list(dccMarkdown("
The `dashHtmlComponents` library exposes all of the HTML tags.
This includes the `Table`, `Tr`, and `Tbody` tags that can be used
to create an HTML table. See
[Create Your First Dash App, Part 1](/getting-started)
for an example.
Dash provides an interactive `DataTable` as part of the `data-table`
project. This table includes built-in filtering, row-selection,
editing, and sorting.
  "
),
htmlHr(),

htmlA(
  className="image-link",
  href="https://github.com/plotly/dash-table-experiments",
  children=htmlImg(
    src="assets/images/gallery/DataTable.gif",
    alt="Example of a Dash Interactive Table"
  ))),
style = list('overflow' = 'hidden',
             'align' = 'left')),

dccMarkdown("
    [View the docs](/datatable) or [View the source](https://github.com/plotly/dash-table)"),


#--------------------------------
htmlDiv(titleLink('UploadComponent')),

dccMarkdown("
The `dccUpload` component allows users to upload files into your app
through drag-and-drop or the systems native file explorer.
"),
htmlBr(),

  htmlDiv(list(htmlA(
    className="image-link",
    href="https://github.com/plotly/dash-core-components/pull/73",
    children=htmlImg(
      src="https://user-images.githubusercontent.com/1280389/30351245-6b93ee62-97e8-11e7-8e85-0411e9d6c98c.gif",
      alt="Dash Upload Component"
    )
  )), style = list('overflow' = 'hidden',
                  'align' = 'left')),

htmlBr(),
htmlDiv(referenceLink('UploadComponent', 'More Upload Examples and Reference')),
htmlHr(),
#--------------------------------

htmlDiv(htmlH3('Tabs')),
examples$tabs$source,
examples$tabs$layout,

htmlBr(),
htmlDiv(referenceLink('Tabs', 'More Tabs Examples and Reference')),
htmlHr(),

#--------------------------------
htmlDiv(titleLink('Graph')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
library(plotly)

year = c(1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003,
  2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012)

  Rest_of_world = c(219, 146, 112, 127, 124, 180, 236, 207, 236, 263,
  350, 430, 474, 526, 488, 537, 500, 439)

  china = c(16, 13, 10, 11, 28, 37, 43, 55, 56, 88, 105, 156, 270,
  299, 340, 403, 549, 499)

  data = data.frame(year, Rest_of_world, china)

  dccGraph(
    figure = plot_ly(data, x = ~year, y = ~Rest_of_world, type = "bar",
      name = "Rest of World", marker = list(
      color = "rgb(55, 83, 109)")) %>%

      add_trace(y = ~china, name = "China",
      marker = list(color = "rgb(26, 118, 255)")) %>%

    layout(yaxis = list(title = "Count"), barmode = "group",
      title="US Export of Plastic Scrap"),

  style = list("height" = 300),
  id = "my_graph"

  )
  '
  ))),
htmlBr(),
htmlDiv(referenceLink('Graph', 'More Graph Examples and Reference')),
dccMarkdown('View the [plotly.r docs](https://plotly.com/r).'),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('ConfirmDialog')),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
confirm = dccConfirmDialog(
  id = "confirm",
  message = "Danger danger! Are you sure you want to continue?"
)
  '
))),

htmlBr(),
htmlDiv(referenceLink('ConfirmDialog', 'More ConfirmDialog Examples and Reference')),
htmlHr(),

#--------------------------------

dccMarkdown(
  " There is also a `dccConfirmDialogProvider`,
     it will automatically wrap a child component
    to send a `dccConfirmDialog` when clicked.
  "
),

htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
confirm = dccConfirmDialogProvider(
  children = htmlButton("Click Me"),
  id = "danger-danger",
  message = "Danger danger! Are you sure you want to continue?"
)
  '
))),

htmlBr(),
htmlDiv(referenceLink('ConfirmDialogProvider', 'More ConfirmDialogProvider Examples and Reference
')),
htmlHr(),

#--------------------------------
htmlDiv(titleLink('Store')),
dccMarkdown(
  " The store component can be used to keep data in the visitor's browser.
    The data is scoped to the user accessing the page.
  **Three types of storage (`storage_type` prop):**
  - `memory`: default, keep the data as long the page is not refreshed.
  - `local`: keep the data until it is manually cleared.
  - `session`: keep the data until the browser/tab closes.
  _For `local`/`session`, the data is serialized as json when stored._
  "
),

htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
store = dccStore(
  id = "my-store",
  data = list("my-data" = "data")
)
  '
))),
dccMarkdown('_The store must be used with callbacks_'),
htmlDiv(referenceLink('Store', 'More Store Examples and Reference')),

#--------------------------------

#htmlDiv(titleLink('Logout Button')),

#dccMarkdown(
#  " The logout button can be used to perform logout mechanism.
#    It's a simple form with a submit button, when the button is clicked,
#    it will submit the form to the `logout_url` prop. Please note that no authentication is performed in Dash by default
#    and you have to implement the authentication yourself.
#  "
#),
#htmlBr(),
#htmlDiv(referenceLink('logout', 'More Logout Button Examples and Reference')),
#htmlHr(),
#--------------------------------
htmlDiv(titleLink('LoadingComponent')),

dccMarkdown(
  " The Loading component can be used to wrap components that you want to display a spinner for, if they take too long to load.
    It does this by checking if any of the Loading components' children have a `loading_state` prop set where `is_loading` is true.
    If true, it will display one of the built-in CSS spinners.
  "
),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
library(dashCoreComponents)
loading = dccLoading(list(list(
    # ...
)))

  '
  ))),

htmlBr(),
htmlDiv(referenceLink('LoadingComponent', 'More Loading Component Examples and Reference')),
htmlHr(),

#--------------------------------

htmlDiv(titleLink('Location')),
dccMarkdown(
  " The location component represents the location bar in your web browser. Through its `href`, `pathname`,
    `search` and `hash` properties you can access different portions of your app's url.

  For example, given the url `http://127.0.0.1:8050/page-2?a=test#quiz`:

  - `href` = `http://127.0.0.1:8050/page-2?a=test#quiz\`
  - `pathname` = `/page-2`
  - `search` = `?a=test`
  - `hash` = `#quiz`

  "
),
# htmlDiv(list(utils$LoadAndDisplayComponent(
#   '
# library(dashCoreComponents)
# location = dccLocation(id= "url", refresh= FALSE)
#   '
#)
dccMarkdown("```r
library(dashCoreComponents)
location = dccLocation(id = 'url', refresh = FALSE)

```",
className = "example-container"),

htmlBr(),
htmlDiv(referenceLink('Location', 'More Location Examples and Reference')),
htmlHr(),
dccMarkdown("[Back to the Table of Contents](/)")

)

)

route <- function(pathname) {
  componentName = gsub('dropdown', '', pathname)
  component_chapter_index = file.path(
    'dash',
    'chapters',
    'dash-core-components',
    componentName,
    'index.R'
  )
  tmp_namespace = new.env()
  source(component_chapter_index, local=tmp_namespace)
  return(tmp_namespace$layout);
}
