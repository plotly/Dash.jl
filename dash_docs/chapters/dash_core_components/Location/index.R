library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  locationproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Location/examples/locationproptable.R')
)

layout <- htmlDiv(list(
htmlH1('Location Component'),
  
dccMarkdown("
The location component represents the location bar in your web browser. Through its `href`, `pathname`,
`search` and `hash` properties you can access different portions of your app's url.
For example, given the url `http://127.0.0.1:8050/page-2?a=test#quiz`:
- `href` = `'http://127.0.0.1:8050/page-2?a=test#quiz'`
- `pathname` = `'/page-2'`
- `search` = `'?a=test'`
- `hash` = `'#quiz'`"),


examples$locationproptable$layout
  
  
))
