# AUTO GENERATED FILE - DO NOT EDIT

from dash.development.base_component import Component, _explicitize_args


class Sidebar(Component):
    """A Sidebar component.


Keyword arguments:
- children (a list of or a singular dash component, string or number; optional): Custom content in the "no results found" panel
- id (string; optional): The ID used to identify this component in Dash callbacks.
- urls (list; optional): URLs
- depth (number; default 0): depth"""
    @_explicitize_args
    def __init__(self, children=None, id=Component.UNDEFINED, urls=Component.UNDEFINED, depth=Component.UNDEFINED, **kwargs):
        self._prop_names = ['children', 'id', 'urls', 'depth']
        self._type = 'Sidebar'
        self._namespace = 'dash_user_guide_components'
        self._valid_wildcard_attributes =            []
        self.available_properties = ['children', 'id', 'urls', 'depth']
        self.available_wildcard_properties =            []

        _explicit_args = kwargs.pop('_explicit_args')
        _locals = locals()
        _locals.update(kwargs)  # For wildcard attrs
        args = {k: _locals[k] for k in _explicit_args if k != 'children'}

        for k in []:
            if k not in args:
                raise TypeError(
                    'Required argument `' + k + '` was not specified.')
        super(Sidebar, self).__init__(children=children, **args)
