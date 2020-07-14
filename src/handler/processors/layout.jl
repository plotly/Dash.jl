layout_data(layout::Component) = layout
layout_data(layout::Function) = layout()
function process_layout(request::HTTP.Request, state::HandlerState)
    return HTTP.Response(
        200,
        ["Content-Type" => "application/json"],
        body = JSON2.write(layout_data(state.app.layout))
    )
end