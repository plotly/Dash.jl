library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  graph_update=utils$LoadExampleCode('dash_docs/chapters/clientside_callbacks/examples/graph_update_fe_be.R')
)

layout <- htmlDiv(
  list(
    htmlH1("Clientside Callbacks"),
    dccMarkdown("
Sometimes callbacks can incur a significant overhead, especially when they:
- receive and/or return very large quantities of data (transfer time)
- are called very often (network latency, queuing, handshake)
- are part of a callback chain that requires multiple roundtrips
between the browser and Dash

When the overhead cost of a callback becomes too great and no
other optimization is possible, the callback can be modified to be run
directly in the browser instead of a making a request to Dash.

The syntax for the callback is almost exactly the same; you use
`Input` and `Output` as you normally would when declaring a callback,
but you also define a JavaScript function as the first argument to the
`app$callback` method.

For example, the following callback:
  "),
    
    dccMarkdown("
```r
app$callback(
  output('out-component', 'value'),
  params = list(
    input('in-component1', 'value'),
    input('in-component2', 'value')
  ),
  large_params_function <- function(largeValue1, largeValue2) {
    largeValueOutput = someTransform(largeValue1, largeValue2)
    
    return(largeValueOutput)
  }
)
```
  "),
    
    dccMarkdown("
***

Can be rewritten to use JavaScript like so:
  "),
    
    dccMarkdown("
```r
app$callback(
  output('out-component', 'value'),
  params = list(
    input('in-component1', 'value'),
    input('in-component2', 'value')
  ),
  clientsideFunction(
    namespace = 'my_clientside_example'
    function_name = 'my_function'
  )
)
```
    "),
    
    dccMarkdown("
    
    ***
    
    You can define the function in a `.js` file in your `assets/` folder.
    To achieve the same result as the code above, the contents of the `.js`
    file would look like this:
      "),
    
    dccLink(
      'Dash Tutorial Part 4: Interactive Graphing',
      href="/interactive-graphing"
    ),

    dccMarkdown("
```js
window.my_clientside_example = {
my_function: function(input_value_1, input_value_2) {
   return (
     parseFloat(input_value_1, 10) +
       parseFloat(input_value_2, 10)
   );
  }
}
```
        "),
    dccMarkdown("

***

## A simple example

Below are two examples of using clientside callbacks to update a
graph in conjunction with a `dcc.Store` component. In these
examples, we update a `dccStore` component on the backend; to
create and display the graph, we have a clientside callback in the
frontend that adds some extra information about the layout that we
specify using the radio buttons under 'Graph scale'.

      "),

    examples$graph_update$layout,

    dccMarkdown("
**Note**: There are a few limitations to keep in mind:

1. Clientside callbacks execute on the browser's main thread and wil block
rendering and events processing while being executed.
2. Dash does not currently support asynchronous clientside callbacks and will
fail if a `Promise` is returned.
3. Clientside callbacks are not possible if you need to refer to global
variables on the server or a DB call is required.

      "),

    htmlHr(),
    dccMarkdown("
[Back to the Table of Contents](/)
                ")
  )
)
