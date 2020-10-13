library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  provider = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/ConfirmDialogProvider/examples/dialogprovider.R'),
  providerproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/ConfirmDialogProvider/examples/providerproptable.R')
)
layout <- htmlDiv(list(
htmlH1('ConfirmDialogProvider component'),
dccMarkdown('
    Send a [ConfirmDialog](/dash-core-components/confirm) when the user
    clicks the children of this component, usually a button.
    '),

examples$provider$source,
examples$provider$layout,

examples$providerproptable$layout
))




