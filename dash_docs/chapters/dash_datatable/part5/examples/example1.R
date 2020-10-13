library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

df_typing_formatting <- data.frame(
  city = c('Vancouver', 'Toronto', 'Calgary', 'Ottawa', 
           'Montreal', 'Halifax', 'Regina', 'Fredericton'),
  average_04_2018 = c(1092000, 766000, 431000, 382000, 
                      341000, 316000, 276000, 173000),
  change_04_2017_04_2018 = c(0.143, -0.051, 0.001, 0.083, 0.063, 
                             0.024, -0.065, 0.012)
)

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'typing_formatting_1',
        data = df_to_list(df_typing_formatting),
        columns = list(
          list(
            id = 'city',
            name = 'City',
            type = 'text'
          ),
          list(
            id = 'average_04_2018',
            name = 'Average Price ($)',
            type = 'numeric',
            format = list(
              specifier = '$,.0f'
            )
          ),
          list(
            id = 'change_04_2017_04_2018',
            name = 'Variation (%)',
            type = 'numeric',
            format = list(
              specifier = '+.1%'
            )
          )
        ),
        editable = TRUE
      )
    )
  )
)

app$run_server()
