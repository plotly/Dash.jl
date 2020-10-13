'''
Phylogeny tree inspired from: http://www.bio.miami.edu/dana/106/106F06_10.html
'''
import dash
import dash_cytoscape as cyto
import dash_html_components as html

app = dash.Dash(__name__)


# Creating elements
nonterminal_nodes = [
    {'data': {'id': name, 'label': name.capitalize()}, 'classes': 'nonterminal'}
    for name in [
        'animalia',
        'eumetazoa',
        'bilateria',
        'deuterostomia'
    ]
]

terminal_nodes = [
    {
        'classes': 'terminal',
        'data': {
            'id': name,
            'label': name.capitalize(),
            'url': 'https://upload.wikimedia.org/wikipedia/commons/thumb/' +
                   url + '/150px-' + url.split('/')[-1]
        }
    }
    for name, url in [
        ['porifera', '4/45/Spongilla_lacustris.jpg'],
        ['ctenophora', 'c/c8/Archaeocydippida_hunsrueckiana.JPG'],
        ['cnidaria', 'c/c1/Polyps_of_Cnidaria_colony.jpg'],
        ['acoela', 'a/aa/Waminoa_on_Plerogyra.jpg'],
        ['echinodermata', '7/7a/Ochre_sea_star_on_beach%2C_Olympic_National_Park_USA.jpg'],
        ['chordata', 'd/d6/White_cockatoo_%28Cacatua_alba%29.jpg']
    ]
]


edges = [
    {'data': {'source': source, 'target': target}}
    for source, target in [
        ['animalia', 'porifera'],
        ['animalia', 'eumetazoa'],
        ['eumetazoa', 'ctenophora'],
        ['eumetazoa', 'bilateria'],
        ['eumetazoa', 'cnidaria'],
        ['bilateria', 'acoela'],
        ['bilateria', 'deuterostomia'],
        ['deuterostomia', 'echinodermata'],
        ['deuterostomia', 'chordata']
    ]
]

# Creating styles
stylesheet = [
    {
        'selector': 'node',
        'style': {
            'content': 'data(label)'
        }
    },
    {
        'selector': '.terminal',
        'style': {
            'width': 90,
            'height': 80,
            'background-fit': 'cover',
            'background-image': 'data(url)'
        }
    },
    {
        'selector': '.nonterminal',
        'style': {
            'shape': 'rectangle'
        }
    }
]


# Declare app layout
app.layout = html.Div([
    cyto.Cytoscape(
        id='cytoscape-images',
        layout={'name': 'breadthfirst', 'roots': ['animalia']},
        style={'width': '100%', 'height': '550px'},
        stylesheet=stylesheet,
        elements=terminal_nodes + nonterminal_nodes + edges
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
