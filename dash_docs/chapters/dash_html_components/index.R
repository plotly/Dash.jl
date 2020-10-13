library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

layout <- htmlDiv(list(
  htmlH1('Dash HTML Components'),
  dccMarkdown("
Dash is a web application framework that provides pure R abstraction around HTML, CSS, and JavaScript.
Instead of writing HTML or using an HTML templating engine, you compose your layout using R with the `dashHtmlComponents` library.
The source for this library is on GitHub: [plotly/dash-html-components](https://github.com/plotly/dash-html-components).
Here is an example of a simple HTML structure:
  "),

  utils$LoadAndDisplayComponent(
"
library(dashHtmlComponents)

htmlDiv(list(
  htmlH1(\'Hello Dash\'),
  htmlDiv(list(
    htmlP(\'Dash converts R classes into HTML\'),
    htmlP(\"This conversion happens behind the scenes by Dash's JavaScript front-end\")
  ))
))\n"
  ),

dccMarkdown("
    If you're not comfortable with HTML, don't worry!
             You can get 95% of the way there with just a few elements
             and attributes.
             Dash's [core component library](/dash-core-components) also supports
             [Markdown](https://daringfireball.net/projects/markdown/).
             "),

dccMarkdown("
    ```r
    library(dashHtmlComponents)
    dccMarkdown(\'\'\'
    #### Dash and Markdown
    Dash supports [Markdown](https://daringfireball.net/projects/markdown/).
    Markdown is a simple way to write and format text.
    It includes a syntax for things like **bold text** and *italics*,
    [links](https://daringfireball.net/projects/markdown/), inline `code` snippets, lists,
    quotes, and more.
    \'\'\')
    "),

dccMarkdown("
    #### Dash and Markdown
    Dash supports [Markdown](http://commonmark.org/help).
    Markdown is a simple way to write and format text.
    It includes a syntax for things like **bold text** and *italics*,
    [links](http://commonmark.org/help), inline `code` snippets, lists,
    quotes, and more.", className='example-container'),

dccMarkdown("
If you're using HTML components, then you also have access to
properties like `style`, `class`, and `id`.

All of these attributes are available in the R functions.
The HTML elements and Dash classes are mostly the same but there are
a few key differences:
- The `style` property is a named list
- Properties in the `style` dictionary are camelCased
- The `class` key is renamed as `className`
- Style properties in pixel units can be supplied as just numbers without the `px` unit \n
Let's take a look at an example.
    "),

dccMarkdown("
    ```r
    library(dashHtmlComponents)
    htmlDiv(list(
        htmlDiv('Example Div', style=list('color': 'blue', 'fontSize': 14)),
        htmlP('Example P', className='my-class', id='my-p-element')
    ), style=list('marginBottom' = 50, 'marginTop' = 25))
    ```
    "),

htmlDiv('That Dash code will render this HTML markup:'),

dccMarkdown('
             ```html
             <div style="margin-bottom: 50px; margin-top: 25px;">

                <div style="color: blue; font-size: 14px">
                    Example Div
                </div>

                <p class="my-class", id="my-p-element">
                    Example P
                </p>
             </div>
             ```
             '),
htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)")
))
