library(dash)
library(dashTable)
library(dashBio)

df <- data.frame(
  Attribute = formalArgs(dashbioMolecule3dViewer),
  Description = c("The ID used to identify this component in callbacks",
                  "The selection type - may be atom, residue or chain",
                  "Property to change the background color of the molecule viewer",
                  "Property to change the backgroun opacity - ranges from 0 to 1",
                  "Property that can be used to change the representation of the molecule. Options include sticks, cartoon and sphere",
                  "The data that will be used to display the molecule in 3D The data will be in JSON format and should have two main dictionaries - atoms, bonds",
                  "Property to either show or hide labels",
                  "Property that stores a list of all selected atoms",
                  "labels corresponding to the atoms of the molecule",
                  "Callback to re-render molecule viewer when modelData is changed",
                  "Callback to change append selectedAtomIds when a selection is made"),
  Type = c("string",
           "one of: 'atom', 'residue', 'chain'",
           "string",
           "number",
           "list of dict containing key(s): 'color' (string), 'visualization_type' (one of: 'cartoon', 'sphere', 'stick').",
           "dict containing key(s): 'atoms' (list), 'bonds' (list).",
           "boolean",
           "list",
           "list",
           "func",
           "func"
  ),
  "Default value" = rep("NULL", 11)
)

app <- Dash$new()

app$layout(
  dashDataTable(
    columns = lapply(colnames(df),
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    data = df_to_list(df),
    style_as_list_view = TRUE,
    style_cell = list(padding = '5px', textAlign = 'center'),
    style_header = list(
      backgroundColor = 'white',
      fontWeight = 'bold'
    ),
    style_data = list(
      whiteSpace = "normal"
    ),
    css = list(
      list(
        selector = '.dash-cell div.dash-cell-value',
        rule = 'display: inline; white-space: inherit; overflow: inherit; text-overflow: inherit;'
      )
    )
  )
)

app$run_server()
