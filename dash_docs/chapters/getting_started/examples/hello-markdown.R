library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

markdown_text <- "
### Dash and Markdown

Dash apps can be written in Markdown.
Dash uses the [CommonMark](http://commonmark.org/)
specification of Markdown.
Check out their [60 Second Markdown Tutorial](http://commonmark.org/help/)
if this is your first introduction to Markdown!
"

app$layout(
  htmlDiv(
    list(
      dccMarkdown(children=markdown_text)
    )
  )
)

app$run_server()
