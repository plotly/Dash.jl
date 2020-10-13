# AUTO GENERATED FILE - DO NOT EDIT

sidebar <- function(children=NULL, id=NULL, urls=NULL, depth=NULL) {
    
    props <- list(children=children, id=id, urls=urls, depth=depth)
    if (length(props) > 0) {
        props <- props[!vapply(props, is.null, logical(1))]
    }
    component <- list(
        props = props,
        type = 'Sidebar',
        namespace = 'dash_user_guide_components',
        propNames = c('children', 'id', 'urls', 'depth'),
        package = 'dashUserGuideComponents'
        )

    structure(component, class = c('dash_component', 'list'))
}
