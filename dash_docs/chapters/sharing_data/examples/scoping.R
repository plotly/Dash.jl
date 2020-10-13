app$callback(output('output', 'children'),
             list(input('dropdown', 'value')),
             function(val) {
               filtered_df <- lapply(df, `[[`, which(df$c == val))
               sprintf(paste(c('the output is', unlist(filtered_df))))
             })
