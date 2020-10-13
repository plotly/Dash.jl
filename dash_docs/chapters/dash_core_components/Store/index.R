library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  storeclick = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Store/examples/storeclick.R'),
  sharecallback = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Store/examples/sharecallbacks.R'),
  storeproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Store/examples/storeproptable.R')

)

layout <- htmlDiv(list(
htmlH1('Store component'),
dccMarkdown("
Store json data in the browser.
## limitations.
- `modified_timestamp` is read only.
### local/session specifics
- The maximum browser [storage space](https://demo.agektmr.com/storage/) is determined by the following factors:
    - Mobile or laptop
    - The browser, under which a sophiticated algorithm is implmented within *Quota Management*
    - Storage encoding where UTF-16 can end up saving only half of the size of UTF-8
    - It's generally safe to store up to 2MB in most environments, and 5~10MB in most desktop-only applications.
### Retrieving the initial store data
If you use the `data` prop as an output, you cannot get the
initial data on load with the `data` prop. To counter this,
you can use the `modified_timestamp` as `Input` and the `data` as `State`.
This limitation is due to the initial None callbacks blocking the true
data callback in the request queue.
See https://github.com/plotly/dash-renderer/pull/81 for further discussion.
                 ))
"),

htmlH2('Store clicks example'),

examples$storeclick$source,
examples$storeclick$layout,

htmlH2('Share data between callbacks'),
examples$sharecallback$source,
examples$sharecallback$layout,

examples$storeproptable$layout


))
