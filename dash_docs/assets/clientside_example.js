window.dash_clientside = Object.assign({}, window.dash_clientside, {
    clientside_examples: {
        update_graph: function(data, scale) {
        return {
            'data': data,
            'layout': {
                 'yaxis': {'type': scale}
             }
        };
    }
    }
});
