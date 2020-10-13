library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  markdownproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Markdown/examples/markdownproptable.R')
)

layout <- htmlDiv(list(
  htmlH1("Markdown Examples and Reference"),
  htmlHr(),
  htmlH3("Syntax Guide"),
  dccMarkdown("These examples are based on the \
    [GitHub Markdown Guide](https://guides.github.com/features/mastering-markdown/).\
    The Dash Markdown component uses the \
    [CommonMark](http://commonmark.org/) specification of Markdown."),
  htmlBr(),
  htmlH3("Headers"),

utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '

# This is an <h1> tag

## This is an <h2> tag

###### This is an <h6> tag)

  '
)
"
),

utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '

  *This text will be italic*

  _This will also be italic_


  **This text will be bold**

  __This will also be bold__

  _You **can** combine them_

  '
)
"
),

htmlHr(),
htmlH3("Lists"),
htmlH3("Unordered"),

utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '
* Item 1
* Item 2
  * Item 2a
  * Item 2b
  '
)
"
),

htmlH3("Block Quotes"),

utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '
>
> Block quotes are used to highlight text.
>
  '
)
"
),

htmlHr(),
htmlH3("Links"),
utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '
[Dash User Guide](https://dashr.plotly.com/)
  '
)
"
),

htmlHr(),
htmlH3("Inline Code"),
htmlP("Any block of text surrounded by ` ` will rendered as inline-code. "),

utils$LoadAndDisplayComponent("
library(dashCoreComponents)
dccMarkdown(
  '
Inline code snippet = `TRUE`
  '
)
"
),

htmlHr(),
htmlH3('Markdown Properties'),

examples$markdownproptable$layout,

htmlHr(),
htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
")

))
