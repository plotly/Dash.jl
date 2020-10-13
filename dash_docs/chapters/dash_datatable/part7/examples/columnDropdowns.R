library(dash)
library(dashHtmlComponents)
library(dashTable)

app <- Dash$new()

df <- data.frame(
  climate = c('Sunny', 'Snowy', 'Sunny', 'Rainy'),
  temperature = c(13, 43, 50, 30),
  city = c('NYC', 'Montreal', 'Miami', 'NYC')
)

app$layout(
  htmlDiv(
    list(
      dashDataTable(
        id = 'table-dropdown',
        data = df_to_list(df),
        columns = list(
          list(id = 'climate', name = 'climate', presentation = 'dropdown'),
          list(id = 'temperature', name = 'temperature'),
          list(id = 'city', name = 'city', presentation = 'dropdown')
        ),
        editable = TRUE,
        dropdown = list(
          'climate' = list(
            options = lapply(unique(df$climate),
                             function(climate) {
                               list(label = climate, value = climate)
                             })
          ),
          'city' = list(
            options = lapply(unique(df$city),
                             function(city) {
                               list(label = city, value = city)
                             })
          )
        )
      ),
      htmlDiv(id = 'table-dropdown-container')
    )
  )
)

app$run_server()
