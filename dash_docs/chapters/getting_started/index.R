library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(data.table)

utils <- new.env()
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  hello.world=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-world.R'),
  hello.dash2=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-dash-components.R'),
  hello.table=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-table.R'),
  hello.bubble=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-bubble.R'),
  hello.markdown=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-markdown.R'),
  hello.dcc=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/hello-dcc.R'),
  dropdown.doc=utils$LoadExampleCode('dash_docs/chapters/getting_started/examples/markdown-doc-dropdown.R')
)

dccDropdownProps <- props_to_list("dccDropdown")
dccDropdownPropsDF <- rbindlist(dccDropdownProps, fill = TRUE)
dccDropdownTable <- generate_table(dccDropdownPropsDF)

layout <- htmlDiv(list(
  dccMarkdown("
# Dash Layout
> This is the 2nd chapter of the
> [Dash Tutorial](/).
> The [previous chapter](/installation)
> covered installation
> and the [next chapter](/getting-started-part-2) covers Dash callbacks.


This tutorial will walk you through a fundamental aspect of Dash apps,
the app `layout`, through 6 self-contained apps.
"),

htmlBr(),

dccMarkdown("
Dash apps are composed of two parts.
The first part is the \"`layout`\" of the app and
it describes what the application looks like.
The second part describes the interactivity of the application
and will be covered in the [next chapter](/getting-started-part-2).


Dash provides R functions for all of the visual components of the application.
We maintain a set of components in the `dashCoreComponents`
and `dashHtmlComponents` package
but you can also [build your own](https://github.com/plotly/dash-component-boilerplate) with JavaScript and React.js.


To get started, create a file named `app.R` containing the following code:
"),
examples$hello.world$source_code,

dccMarkdown("
Run the app with

   ```
   $ Rscript app.R
   Fire started at 127.0.0.1:8050
   start: 127.0.0.1:8050
   ```
  "),
  # hello markdown example
  dccMarkdown("
and visit [http:127.0.0.1:8050/](http:127.0.0.1:8050/)
in your web browser. You should see an app that looks like this.
  "),
  examples$hello.world$layout,

  dccMarkdown("
Note:

1.The `layout` is composed of a tree of \"components\" like `htmlDiv`
and `dccGraph`.

2.The `dashHtmlComponents` package has a component for every HTML
tag. The `htmlH1(children='Hello Dash')` component generates
a `<h1>Hello Dash</h1>` HTML element in your application.

3.Not all components are pure HTML. The `dashCoreComponents` describe
higher-level components that are interactive and are generated with
JavaScript, HTML, and CSS through the React.js library.

4.Each component is described entirely through keyword attributes.
Dash is _declarative_: you will primarily describe your application
through these attributes.

5.The `children` property is special. By convention, it's always the
first attribute which means that you can omit it:
`htmlH1(children='Hello Dash')` is the same as `htmlH1('Hello Dash')`.
Also, it can contain a string, a number, a single component, or a
list of components.

6.The fonts in your application will look a little bit different than
what is displayed here. This application is using a
custom CSS stylesheet to modify the default styles of the elements.
You can learn more in the [css tutorial](/external-resources),
but for now you can initialize your app with
```
app <- Dash$new(external_stylesheets = \"https://codepen.io/chriddyp/pen/bWLwgP.css\")
```

#### More about HTML
The `dashHtmlComponents` package contains a component class for every
HTML tag as well as keyword arguments for all of the HTML arguments.

Let's customize the text in our app by modifying the inline styles of the components:
  "),

  # hello layout example
  examples$hello.dash2$source_code,
  examples$hello.dash2$layout,

  dccMarkdown("
In this example, we modified the inline styles of the `htmlDiv`
and `htmlH1` components with the `style` property.
`htmlH1('Hello Dash', style=list(textAlign = 'center', color = '#7FDBFF')`
is rendered in the Dash application as
`<h1 style=\"text-align: center; color: #7FDBFF\">Hello Dash</h1>`.

There are a few important differences between the `dashHtmlComponents`
and the HTML attributes:

1.The `style` property in HTML is a semicolon-separated string. In Dash,
you can just supply a named list.

2.The keys in the `style` named list are [camelCased](https://en.wikipedia.org/wiki/Camel_case).
So, instead of `text-align`, it's `textAlign`.

3.The HTML `class` attribute is `className` in Dash.

4.The children of the HTML tag is specified through the `children` keyword argument.
By convention, this is always the _first_ argument and so it is often omitted.
Besides that, all of the available HTML attributes and tags are available
to you within your R context.

***
#### Reusable Components

Here's a quick example that generates a `Table`.
  "),
  # hello table example
  examples$hello.table$source_code,
  examples$hello.table$layout,

  dccMarkdown("
#### More about Visualization
The `dashCoreComponents` package includes a component called `dccGraph`.
`dccGraph` renders interactive data visualizations using the open source
[plotly.js](https://github.com/plotly/plotly.js) JavaScript graphing
library. `Plotly.js` supports over 35 chart types and renders charts in
both vector-quality SVG and high-performance WebGL.
The `figure` argument in the `dccGraph` component is
the same `figure` argument that is used by `plotly.R`, Plotly's
open source R graphing package.
Check out the [plotly.r documentation and gallery](https://plotly.com/r)
to learn more.
  "),
  # hello scatter example
  examples$hello.bubble$source_code,
  examples$hello.bubble$layout,

  dccMarkdown("
*These graphs are interactive and responsive.
**Hover** over points to see their values,
**click** on legend items to toggle traces,
**click and drag** to zoom,
**hold down shift, and click and drag** to pan.*

#### Markdown
While Dash exposes HTML through the `dashHtmlComponents` package,
it can be tedious to write your copy in HTML.
For writing blocks of text, you can use the `dccMarkdown` component in the
`dashCoreComponents` package.
  "),

  # hello dmarkdown example
  examples$hello.markdown$source_code,
  examples$hello.markdown$layout,

  dccMarkdown("
#### Core Components
The `dashCoreComponents` includes a set of higher-level components like
dropdowns, graphs, markdown blocks, and more.
Like all Dash components, they are described entirely declaratively.
Every option that is configurable is available as a keyword argument
of the component.

Here are a few of the available components:
  "),

  # hello dcc example
  examples$hello.dcc$source_code,
  examples$hello.dcc$layout,

  dccMarkdown("
#### Calling help
Dash components are declarative: every configurable aspect of these components
is set during instantiation as a keyword argument. Call help in your R console
on any of the components to learn more about a component and its available arguments.
  "),

dccMarkdown('```r
help(dccDropdown)
```'),

dccMarkdown('
**Description**

Dropdown is an interactive dropdown element for selecting one or more items.
The values and labels of the dropdown items are specified in the "options"
property and the selected item(s) are specified with the "value" property.
Use a dropdown when you have many options (more than 5) or when you are
constrained for space. Otherwise, you can use RadioItems or a Checklist,
which have the benefit of showing the users all of the items at once.

**Usage**
'),

dccMarkdown('```r

dccDropdown(id=NULL, options=NULL, value=NULL, optionHeight=NULL, className=NULL,
clearable=NULL, disabled=NULL, multi=NULL, placeholder=NULL, searchable=NULL,
style=NULL, loading_state=NULL)
```'),

  dccDropdownTable,
  dccMarkdown("
# Summary
The layout of a Dash app describes what the app looks like.
The layout is a hierarchical tree of components. The `dashHtmlComponents` package provides
classes for all of the HTML tags and the keyword arguments describe the HTML
attributes like style, className, and id. The `dashCoreComponents` package generates
higher-level components like controls and graphs.
For reference, see:
- [dashCoreComponents gallery](https://dashr.plotly.com/dash-core-components)
- [dashHtmlComponents gallery](https://dashr.plotly.com/dash-html-components)


The next part of the Dash tutorial covers how to make these apps interactive.

[Dash Tutorial Part 3: Basic Callbacks](/getting-started-part-2)
  "),

  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
  ")
))
