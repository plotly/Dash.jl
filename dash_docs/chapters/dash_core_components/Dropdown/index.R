library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('./dash_docs/utils.R', local=utils)

examples <- list(
  simple_example=utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Dropdown/examples/simple-example.R'),
  simple_example_multi=utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Dropdown/examples/simple-example-multi.R'),
  proptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Dropdown/examples/dropdownproptable.R')
)


layout <- htmlDiv(list(
htmlH1('Dropdown Examples and Reference'),

#--------------------------------------------
htmlHr(),
htmlH3('Default Dropdown'),
dccMarkdown('
An example of a default dropdown without any extra properties.
'),
examples$simple_example$source,
examples$simple_example$layout,

#--------------------------------------------
htmlHr(),
htmlH3('Multi-Value Dropdown'),
dccMarkdown('
A dropdown component with the `multi` property set to `TRUE`
will allow the user to select more than one value at a time.
'),
htmlDiv(list(utils$LoadAndDisplayComponent(
'
dccDropdown(
  options=list(
    list(label="New York City", value="NYC"),
    list(label="Montréal", value="MTL"),
    list(label="San Francisco", value="SF")
  ),
  value=list("MTL", "NYC"),
  multi=TRUE
)
'
))),

#--------------------------------------------
htmlHr(),
htmlH3('Disable Search'),
dccMarkdown("
The `searchable` property is set to `TRUE` by default on all \
`Dropdown` components. To prevent searching the dropdown \
value, just set the `searchable` property to `FALSE`. \
Try searching for 'New York' on this dropdown below and compare \
it to the other dropdowns on the page to see the difference.
"),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
dccDropdown(
  options=list(
    list(label="New York City", value="NYC"),
    list(label="Montréal", value="MTL"),
    list(label="San Francisco", value="SF")
  ),
  searchable = FALSE
)
'
))),

#--------------------------------------------
htmlHr(),
htmlH3('Dropdown Clear'),
dccMarkdown("
The `clearable` property is set to `TRUE` by default on all \
`Dropdown` components. To prevent the clearing of the selected dropdown \
value, just set the `clearable` property to `FALSE`
            "),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
  dccDropdown(
  options=list(
  list(label="New York City", value="NYC"),
  list(label="Montréal", value="MTL"),
  list(label="San Francisco", value="SF")
  ),
  value = "MTL",
  clearable = FALSE
  )
  '
))),

#--------------------------------------------
htmlHr(),
htmlH3('Placeholder Text'),
dccMarkdown("
The `placeholder` property allows you to define \
default text shown when no value is selected.
            "),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
  dccDropdown(
  options=list(
  list(label="New York City", value="NYC"),
  list(label="Montréal", value="MTL"),
  list(label="San Francisco", value="SF")
  ),
  placeholder="Select a city"
  )
  '
))),

#--------------------------------------------
htmlHr(),
htmlH3('Disable Dropdown'),
dccMarkdown("To disable the dropdown just set `disabled=TRUE`.
            "),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
  dccDropdown(
  options=list(
  list(label="New York City", value="NYC"),
  list(label="Montréal", value="MTL"),
  list(label="San Francisco", value="SF")
  ),
  disabled=TRUE
  )
  '
))),

#--------------------------------------------
htmlHr(),
htmlH3('Disable Options'),
dccMarkdown("To disable a particular option inside the dropdown \
                 menu, set the `disabled` property in the options.
            "),
htmlDiv(list(utils$LoadAndDisplayComponent(
  '
  dccDropdown(
  options=list(
  list(label="New York City", value="NYC", "disabled" = TRUE),
  list(label="Montréal", value="MTL"),
  list(label="San Francisco", value="SF", "disabled" = TRUE)
  )
  )
  '
))),

#--------------------------------------------

htmlHr(),
htmlH3("Dropdown Properties"),

examples$proptable$layout,

#--------------------------------------------

htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
  ")

))

