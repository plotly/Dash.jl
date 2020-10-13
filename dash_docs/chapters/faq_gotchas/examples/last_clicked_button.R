library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(jsonlite)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlButton(children = 'Button 1', id='btn-1', n_clicks=0),
      htmlButton(children = 'Button 2', id='btn-2', n_clicks=0),
      htmlButton(children = 'Button 3', id='btn-3', n_clicks=0),
      htmlDiv(id='container')
      
    )
  )
)

app$callback(output('container', 'children'),
             list(input('btn-1', 'n_clicks'),
                  input('btn-2', 'n_clicks'),
                  input('btn-3', 'n_clicks')),
    function(input1, input2, input3) {
      
      inputs <- c(input1, input2, input3)
      
      ctx <- app$callback_context()
      
      most_recent_click <- if(ctx$triggered$value) {
        
        unlist(strsplit(ctx$triggered$prop_id, "[.]"))[1]
        
      } else "No clicks yet"

      toJson <- jsonlite::toJSON(ctx, pretty = TRUE)
      
      htmlDiv(
        list(
          htmlTable(
            list(
              htmlTr(
                list(
                  htmlTh('Button 1'),
                  htmlTh('Button 2'),
                  htmlTh('Button 3'),
                  htmlTh('Most Recent Click')
                )
              ),
              htmlTr(
                list(
                  htmlTd(input1),
                  htmlTd(input2),
                  htmlTd(input3),
                  htmlTd(most_recent_click)
                )
              )
            )
          ),
          htmlPre(toJson)
        )
      )
    })
#app$run_server()
