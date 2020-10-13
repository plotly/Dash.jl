library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  tabexample = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabexample.R'),
  tabs = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabs.R'),
  tabchildren = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabchildren.R'),
  tabcss = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabcss.R'),
  tabinline = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabsinline.R'),
  tabinline2 = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabsinline2.R'),
  tabproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabproptable.R'),
  tabsproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabsproptable.R')
)

layout <- htmlDiv(list(
htmlH1('Tabs Examples and Reference'),
dccMarkdown("
The Tabs and Tab components can be used to create tabbed sections in your app.
The `Tab` component controls the style and value of the individual tab
and the `Tabs` component hold a collection of `Tab` components.
**Table of Contents**
-  Method 1. Content as Callback
-  Method 2. Content as Tab children
- Styling the Tabs component
  - with CSS classes
  - with inline styles
  - with props
***
"),
  
htmlH2('Method 1. Content as Callback'),
dccMarkdown("
Attach a callback to the Tabs `value` prop and update a container's `children`
property in your callback."),

examples$tabexample$source,
examples$tabexample$layout,

htmlH2('Method 2. Content as Tab Children'),
dccMarkdown("
Instead of displaying the content through a callback, you can embed the content
directly as the `children` property in the `Tab` component:"),

examples$tabchildren$source,
examples$tabchildren$layout,

dccMarkdown("
Note that this method has a drawback: it requires that you compute the children property for each individual
tab _upfront_ and send all of the tab's content over the network _at once_.
The callback method allows you to compute the tab's content _on the fly_
(that is, when the tab is clicked)."),

htmlH2('Styling the Tabs component'),
htmlH3('With CSS classes'),
dccMarkdown("
Styling the Tabs (and Tab) component can either be done using CSS classes by providing your own to the `className` property:"),

examples$tabcss$source,
examples$tabcss$layout,

htmlBr(),

dccMarkdown("
Notice how the container of the Tabs can be styled as well by supplying a class to the `parent_className` prop, which we use here to draw a border below it, positioning the actual Tabs (with padding) more in the center.
We also added `display: flex` and `justify-content: center` to the regular `Tab` components, so that labels with multiple lines will not break the flow of the text.
The corresponding CSS file (`assets/tabs.css`) looks like this. Save the file in an `assets` folder (it can be named anything you want). Dash will automatically include this CSS when the app is loaded. [Learn more about including CSS in your app here.](/external-resources)
"),

dccMarkdown('
.custom-tabs-container {
width: 85%;
}
.custom-tabs {
border-top-left-radius: 3px;
background-color: #f9f9f9;
padding: 0px 24px;
border-bottom: 1px solid #d6d6d6;
}
            
.custom-tab {
color:#586069;
border-top-left-radius: 3px;
border-top: 3px solid transparent !important;
border-left: 0px !important;
border-right: 0px !important;
border-bottom: 0px !important;
background-color: #fafbfc;
padding: 12px !important;
font-family: "system-ui";
display: flex !important;
align-items: center;
justify-content: center;
}
.custom-tab--selected {
color: black;
box-shadow: 1px 1px 0px white;
border-left: 1px solid lightgrey !important;
border-right: 1px solid lightgrey !important;
border-top: 3px solid #e36209 !important;
}           
'),

htmlBr(),

htmlH3('With inline styles'),
dccMarkdown("
    An alternative to providing CSS classes is to provide style dictionaries directly:
    "),

examples$tabinline$source,
examples$tabinline$layout,

htmlBr(),

dccMarkdown('
Lastly, you can set the colors of the Tabs components in the `color` prop, by specifying the "border", "primary", and "background" colors in a dict. Make sure you set them
all, if you are using them!'),

examples$tabinline2$source,
examples$tabinline2$layout,

htmlHr(),
htmlH3('Tab properties'),

examples$tabproptable$layout,

htmlH3('Tabs properties'),

examples$tabsproptable$layout


  
))





