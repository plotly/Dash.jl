library(dashCoreComponents)
library(dash)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      htmlButton('Button 1', id='btn-1', n_clicks_timestamp=0),
      htmlButton('Button 2', id='btn-2', n_clicks_timestamp=0),
      htmlButton('Button 3', id='btn-3', n_clicks_timestamp=0),
      htmlDiv(id='container-button-timestamp')
    )
  )
)

app$callback(
  output(id = 'container-button-timestamp', property = 'children'),
  params = list(input(id = 'btn-1', property = 'n_clicks_timestamp'),
                input(id = 'btn-2', property = 'n_clicks_timestamp'),
                input(id = 'btn-3', property ='n_clicks_timestamp')),
             function(btn1, btn2, btn3){
               if((btn1) > (btn2) & (btn1) > (btn3)){
                 msg = 'Button 1 was most recently clicked'
               } else if((btn2) > (btn1) & (btn2) > (btn3)){
                 msg = 'Button 2 was most recently clicked'
               } else if((btn3) > (btn1) & (btn3) > (btn2)){
                 msg = 'Button 3 was most recently clicked'
               } 
               else{
                 msg = 'None of the buttons have been clicked yet'
               }
               return(htmlDiv(list(
                 htmlDiv(sprintf('btn1: %s', format(btn1, scientific = FALSE))),
                 htmlDiv(sprintf('btn2: %s', format(btn2, scientific = FALSE))),
                 htmlDiv(sprintf('btn3: %s', format(btn3, scientific = FALSE))),
                 htmlDiv(msg))
                 ))
             }
)

app$run_server()

