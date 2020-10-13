dashDataTable(
  columns = list(
    list(name = c("", "Year"), id = "year"),
    list(name = c("City", "Montreal"), id = "montreal"),
    list(name = c("City", "Toronto"), id = "toronto"),
    list(name = c("City", "Ottawa"), id = "ottawa",
         hidden = TRUE),
    list(name = c("City", "Vancouver"), id = "vancouver"),
    list(name = c("Climate", "Temperature"), id = "temp"),
    list(name = c("Climate", "Humidity"), id = "humidity")
  ),
  data = lapply(1:10,
                function(i){
                  list(year = i,
                       montreal = 10 * i,
                       toronto = 100 * i,
                       ottawa = -1 * i,
                       vancouver = -10 * i,
                       temp = -100 * i,
                       humidity = 5 * i)
                }),
  merge_duplicate_headers = TRUE
)
