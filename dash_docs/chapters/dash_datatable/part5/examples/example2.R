library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

df_typing_formatting <- data.frame(
  city = c('NYC', 'Montreal', 'Los Angeles'),
  max = c(108, 99, 111),
  max_date = c('1926-07-22', '1975-08-01', '1939-09-20'),
  min = c(-15, -36, 28),
  min_date = c('1934-02-09', '1957-01-15', '1913-01-07')
)

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'typing_formatting',
        data = df_to_list(df_typing_formatting),
        columns = list(
          list(
            id = 'city',
            name = 'City',
            type = 'text'
          ),
          list(
            id = 'max',
            name = 'Max Temperature (?F)',
            type = 'numeric',
            format = list(
              locale = list(
                symbol = list('', '?F')
              ),
              specifier = '$.0f'
            )
          ),
          list(
            id = 'max_date',
            name = 'Max Temperature (Date)',
            type = 'datetime'
          ),
          list(
            id = 'min',
            name = 'Min Temperature (?F)',
            type = 'numeric',
            format = list(
              locale = list(
                symbol = list('', '?F')
              ),
              nully = 'N/A',
              specifier = '$.0f'
            ),
            on_change = list(
              action = 'coerce',
              failure = 'default'
            ),
            validation = list(default = NULL)
          ),
          list(
            id = 'min_date',
            name = 'Min Temperature (Date)',
            type = 'datetime',
            on_change = list(action = 'none')
          )
        ),
        editable = TRUE
      )
    )
  )
)

app$run_server()

