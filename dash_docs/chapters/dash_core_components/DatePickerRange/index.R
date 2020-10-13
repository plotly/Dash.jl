library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local = utils)

examples <- list(
  pickerrange  =  utils$LoadExampleCode('dash_docs/chapters/dash_core_components/DatePickerRange/examples/datepickerrange.R'),
  datepickerrangeproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/DatePickerRange/examples/datepickerrangeproptable.R')
)

layout <- htmlDiv(list(
  
htmlH1('DatePickerRange Examples and Reference'),
htmlHr(),
htmlH3("Simple DatePickerRange Example"),
dccMarkdown("This is a simple example of a `DatePickerRange` \
             component tied to a callback. The `min_date_allowed` and \
             `max_date_allowed` properties define the minimum and \
             maximum selectable \
             dates on the calendar while `initial_visible_month` defines \
             the calendar month that is first displayed when the \
             `DatePickerRange` component is opened."),

examples$pickerrange$source,
examples$pickerrange$layout,

htmlHr(),
htmlH3('Month and Display Format'),
dccMarkdown("The `display_format` property \
             determines how selected dates are displayed \
             in the `DatePickerRange` component. The `month_format` \
             property determines how calendar headers are displayed when \
             the calendar is opened."),
htmlP("Both of these properties are configured through \
       strings that utilize a combination of any \
       of the following tokens."),

htmlTable(list(
  htmlTr(list(
    htmlTh('String Token', style = list('text-align' =  'left', 'width' =  '20%')),
    htmlTh('Example', style = list('text-align' =  'left', 'width' =  '20%')),
    htmlTh('Description', style = list('text-align' =  'left', 'width' =  '60%'))
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`YYYY`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`2014`'), style = list('text-align' =  'left')),
    htmlTd('4 or 2 digit year')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`YY`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`14`'), style = list('text-align' =  'left')),
    htmlTd('2 digit year')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`Y`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`-25`'), style = list('text-align' =  'left')),
    htmlTd('Year with any number of digits and sign')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`Q`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1..4`'), style = list('text-align' =  'left')),
    htmlTd('Quarter of year. Sets month to first month in quarter.')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`M MM`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1..12`'), style = list('text-align' =  'left')),
    htmlTd('Month number')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`MMM MMMM`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`Jan..December`'), style = list('text-align' =  'left')),
    htmlTd('Month name')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`D DD`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1..31`'), style = list('text-align' =  'left')),
    htmlTd('Day of month')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`Do`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1st..31st`'), style = list('text-align' =  'left')),
    htmlTd('Day of month with ordinal')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`DDD DDDD`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1..365`'), style = list('text-align' =  'left')),
    htmlTd('Day of year')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`X`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1410715640.579`'), style = list('text-align' =  'left')),
    htmlTd('Unix timestamp')
  )),
  htmlTr(list(
    htmlTd(dccMarkdown('`x`'), style = list('text-align' =  'left')),
    htmlTd(dccMarkdown('`1410715640579`'), style = list('text-align' =  'left')),
    htmlTd('Unix ms timestamp')
  )))),

htmlBr(),
htmlH3("Display Format Examples"),
dccMarkdown("You can utilize any permutation of the string tokens \
             shown in the table above to change how selected dates are \
             displayed in the `DatePickerRange` component."),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  end_date  =  as.POSIXct("2017-6-21 23:59:59", tz  =  "GMT"),
  display_format = "MMM Do, YY",
  start_date_placeholder_text = "MMM Do, YY"
)
'
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
    end_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d"),
    display_format = "M-D-Y-Q",
    start_date_placeholder_text = "M-D-Y-Q"
)
  '
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
    end_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d"),
    display_format = "MMMM Y, DD",
    start_date_placeholder_text = "MMMM Y, DD"
)
  '
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
  dccDatePickerRange(
  end_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d"),
  display_format = "X",
  start_date_placeholder_text = "X"
  )
  '
),

htmlBr(),

htmlH3("Month Format Examples"),
dccMarkdown("Similar to the `display_format`, you can set `month_format` \
             to any permutation of the string tokens \
             shown in the table above to change how calendar titles \
             are displayed in the `DatePickerRange` component."),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  display_format = "MMM Do, YY",
  start_date_placeholder_text = "MMM Do, YY",
  start_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d")
  )
  '
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  display_format = "M-D-Y-Q",
  start_date_placeholder_text = "M-D-Y-Q",
  start_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d")
  )
  '
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  display_format = "MMMM Y",
  start_date_placeholder_text = "MMMM Y",
  start_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d")
  )
  '
),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  display_format = "X",
  start_date_placeholder_text = "X",
  start_date = format(as.Date("2017-6-21"), format  =  "%Y,%m,%d")
  )
  '
),

htmlHr(),

htmlH3("Vertical Calendar and Placeholder Text"),
dccMarkdown("The `DatePickerRange` component can be rendered in two \
             orientations, either horizontally or vertically. \
             If `calendar_orientation` is set to `'vertical'`, it will \
             be rendered vertically and will default to `'horizontal'` \
             if not defined."),
dccMarkdown("The `start_date_placeholder_text` and \
             `end_date_placeholder_text` define the grey default text \
             defined in the calendar input boxes when no date is \
             selected."),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  start_date_placeholder_text = "Start Period",
  end_date_placeholder_text = "End Period",
  calendar_orientation = "vertical",
)
  '
),
htmlHr(),

htmlH3("Minimum Nights, Calendar Clear, and Portals"),
dccMarkdown("The `minimum_nights` property defines the number of \
                  nights that must be in between the range of two \
                  selected dates."),
dccMarkdown("When the `clearable` property is set to `TRUE` \
                  the component will be rendered with a small 'x' \
                  that will remove all selected dates when selected."),
dccMarkdown("The `DatePickerRange` component supports two different \
                  portal types, one being a full screen portal \
                  (`with_full_screen_portal`) and another being a simple \
                  screen overlay, like the one shown below (`with_portal`)."),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  minimum_nights = 5,
  clearable = TRUE,
  with_portal = TRUE,
  start_date  =  format(as.Date("2017-6-21"), format  =  "%Y,%m,%d")
)
  '
),
htmlHr(),

htmlH3("Right to Left Calendars and First Day of Week"),
dccMarkdown("When the `is_RTL` property is set to `TRUE` \
             the calendar will be rendered from right to left."),
dccMarkdown("The `first_day_of_week` property allows you to \
             define which day of the week will be set as the first \
             day of the week. In the example below, Tuesday is \
             the first day of the week."),

utils$LoadAndDisplayComponent(
'library(dashCoreComponents)
dccDatePickerRange(
  is_RTL = TRUE,
  first_day_of_week = 3,
  start_date= format(as.Date("2017-6-21"), format = "%Y,%m,%d")
)
  '
),


htmlHr(),
htmlH3('DatePickerRange Properties'),
examples$datepickerrangeproptable$layout,

htmlHr(),
htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
")



))
