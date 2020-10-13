import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([

    rc.Markdown('''
    # Cytoscape with Biopython

    In this chapter, we will show an example of automatically generating a
    phylogenetic tree
    from biopython's `Phylo` object, and enable interactive features such
    as highlighting children clades. The source code is available as [`usage-phylogeny.py`](https://github.com/plotly/dash-cytoscape/blob/master/demos/usage-phylogeny.py),
    and you can find an [online demo here](https://dash-gallery.plotly.host/cytoscape-phylogeny).

    ## Parsing the Phylo object

    The first step is to load the phylogeny tree. We will be using the
    `apaf.xml` file retrieved from [PhyloXML](http://www.phyloxml.org/examples/apaf.xml).

    To load the file, run this (after you made sure that
    biopython was correctly installed):

    '''),

    rc.Markdown('''
    ```py
    from Bio import Phylo
    tree = Phylo.read('data/apaf.xml', 'phyloxml')
    ```
    ''', style=styles.code_container),

    rc.Markdown('''

    Then, we need to use a function to parse the data. We will construct a
    function `generate_elements(...)`, which will first generate the column
    position and row position of each element in the tree using helper functions
    `get_col_positions` and `get_row_positions`, and recursively parse the
    tree and add the clades to the list of elements, using a helper function
    called `add_to_elements`.
    '''),

    html.Details(open=False, children=[
        html.Summary('get_col_positions() function definition'),
        rc.Markdown('''
        ```py
        def get_col_positions(tree, column_width=80):
            taxa = tree.get_terminals()

            # Some constants for the drawing calculations
            max_label_width = max(len(str(taxon)) for taxon in taxa)
            drawing_width = column_width - max_label_width - 1

            """Create a mapping of each clade to its column position."""
            depths = tree.depths()
            # If there are no branch lengths, assume unit branch lengths
            if not max(depths.values()):
                depths = tree.depths(unit_branch_lengths=True)
                # Potential drawing overflow due to rounding -- 1 char per tree layer
            fudge_margin = int(math.ceil(math.log(len(taxa), 2)))
            cols_per_branch_unit = ((drawing_width - fudge_margin) /
                                    float(max(depths.values())))
            return dict((clade, int(blen * cols_per_branch_unit + 1.0))
                        for clade, blen in depths.items())
        ```
        ''', style=styles.code_container),
    ]),

    html.Details(open=False, children=[
        html.Summary('get_row_positions() function definition'),
        rc.Markdown('''
        ```py
        def get_row_positions(tree):
            taxa = tree.get_terminals()
            positions = dict((taxon, 2 * idx) for idx, taxon in enumerate(taxa))

            def calc_row(clade):
                for subclade in clade:
                    if subclade not in positions:
                        calc_row(subclade)
                positions[clade] = ((positions[clade.clades[0]] +
                                     positions[clade.clades[-1]]) // 2)

            calc_row(tree.root)
            return positions
        ```
        ''', style=styles.code_container),
    ]),

    html.Details(open=False, children=[
        html.Summary('add_to_elements() function definition'),
        rc.Markdown('''
        ```py
        def add_to_elements(clade, clade_id):
            children = clade.clades

            pos_x = col_positions[clade] * xlen
            pos_y = row_positions[clade] * ylen

            cy_source = {
                "data": {"id": clade_id},
                'position': {'x': pos_x, 'y': pos_y},
                'classes': 'nonterminal',
                'grabbable': grabbable
            }
            nodes.append(cy_source)

            if clade.is_terminal():
                cy_source['data']['name'] = clade.name
                cy_source['classes'] = 'terminal'

            for n, child in enumerate(children):
                # The "support" node is on the same column as the parent clade,
                # and on the same row as the child clade. It is used to create the
                # 90 degree angle between the parent and the children.
                # Edge config: parent -> support -> child

                support_id = clade_id + 's' + str(n)
                child_id = clade_id + 'c' + str(n)
                pos_y_child = row_positions[child] * ylen

                cy_support_node = {
                    'data': {'id': support_id},
                    'position': {'x': pos_x, 'y': pos_y_child},
                    'grabbable': grabbable,
                    'classes': 'support'
                }

                cy_support_edge = {
                    'data': {
                        'source': clade_id,
                        'target': support_id,
                        'sourceCladeId': clade_id
                    },
                }

                cy_edge = {
                    'data': {
                        'source': support_id,
                        'target': child_id,
                        'length': clade.branch_length,
                        'sourceCladeId': clade_id
                    },
                }

                if clade.confidence and clade.confidence.value:
                    cy_source['data']['confidence'] = clade.confidence.value

                nodes.append(cy_support_node)
                edges.extend([cy_support_edge, cy_edge])

                add_to_elements(child, child_id)
        ```
        ''', style=styles.code_container),
    ]),

    rc.Markdown('''
    > You might notice that we use something called support clades. Those are
    > simply used to modify the shape of the tree so that it resembles
    > traditional phylogeny tree layouts.

    Finally, we finish building `generate_elements` with the following code:
    '''),

    rc.Markdown('''
    ```py
    import math

    def generate_elements(tree, xlen=30, ylen=30, grabbable=False):
        def col_positions(tree, column_width=80):
            ...

        def row_positions(tree):
            ...

        def add_to_elements(clade, clade_id):
            ...

        col_positions = get_col_positions(tree)
        row_positions = get_row_positions(tree)

        nodes = []
        edges = []

        add_to_elements(tree.clade, 'r')

        return nodes, edges
    ```
    ''', style=styles.code_container),


    rc.Markdown('''
    > Note that `add_to_elements` changes the `nodes` and `edges` lists in place.

    ## Defining layout and stylesheet

    Since we are assigning a position to the nodes, we have to use the `preset`
    layout. Additionally, we need to add specific styles in order to make the
    phylogeny trees to match aesthetically the traditional methods. We define:
    '''),

    rc.Markdown('''
    ```py
    layout = {'name': 'preset'}

    stylesheet = [
        {
            'selector': '.nonterminal',
            'style': {
                'label': 'data(confidence)',
                'background-opacity': 0,
                "text-halign": "left",
                "text-valign": "top",
            }
        },
        {
            'selector': '.support',
            'style': {'background-opacity': 0}
        },
        {
            'selector': 'edge',
            'style': {
                "source-endpoint": "inside-to-node",
                "target-endpoint": "inside-to-node",
            }
        },
        {
            'selector': '.terminal',
            'style': {
                'label': 'data(name)',
                'width': 10,
                'height': 10,
                "text-valign": "center",
                "text-halign": "right",
                'background-color': '#222222'
            }
        }
    ]
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    ## Layout and Callbacks

    At this point, we simply need to create the layout of the app, which will
    be a simple Cytoscape component. We will also add a callback that will
    color all the children of an edge red whenever we hover on that edge. This
    is accomplished by filtering the IDs, which are sequences of
    *s*'s and *c*'s, which stand for *support* and *children*, intersected
    by the number 0 or 1, since there are two subclades per clade.
    '''),

    rc.Markdown('''
    ```py
    # Start the app
    app = dash.Dash(__name__)

    app.layout = html.Div([
        cyto.Cytoscape(
            id='cytoscape-usage-phylogeny',
            elements=elements,
            stylesheet=stylesheet,
            layout=layout,
            style={
                'height': '95vh',
                'width': '100%'
            }
        )
    ])


    @app.callback(Output('cytoscape-usage-phylogeny', 'stylesheet'),
                  [Input('cytoscape-usage-phylogeny', 'mouseoverEdgeData')])
    def color_children(edgeData):
        if not edgeData:
            return stylesheet

        if 's' in edgeData['source']:
            val = edgeData['source'].split('s')[0]
        else:
            val = edgeData['source']

        children_style = [{
            'selector': 'edge[source *= "{}"]'.format(val),
            'style': {
                'line-color': 'blue'
            }
        }]

        return stylesheet + children_style
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    This results in the following app:
    '''),

    html.Details(open=False, children=[
        html.Summary('View the complete source code'),
        rc.Markdown(
            examples['usage-phylogeny.py'][0],
            style=styles.code_container
        )
    ]),

    html.Div(
        examples['usage-phylogeny.py'][1],
        className='example-container'
    ),

])
