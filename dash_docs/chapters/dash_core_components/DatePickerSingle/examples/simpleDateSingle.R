library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccDatePickerSingle(
        id='my-date-picker-single',
        min_date_allowed=as.Date('1995-8-5'),
        max_date_allowed=as.Date('2017-9-19'),
        initial_visible_month=as.Date('2017-8-5'),
        date = as.POSIXct("2017-08-25 23:59:59", tz = "GMT")
      ),
      htmlDiv(id='output-container-date-picker-single')
    )
  )
)

app$callback(
  output = list(id='output-container-date-picker-single', property = 'children'),
  params = list(input(id = 'my-date-picker-single', property = 'date')),
  function(date){
    if(is.null(date) == FALSE){
      date = format(as.Date(date), format = '%B %d,%Y')
      sprintf('You have selected: %s', date)
    }
  }
)

app$run_server()
