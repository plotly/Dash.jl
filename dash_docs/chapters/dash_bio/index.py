import dash_core_components as dcc
import dash_html_components as html
import dash_bio

from dash_docs import styles
from .utils import generate_docs
from dash_docs import reusable_components as rc

DASHBIO_LIBRARY_HEADING = [
    rc.Markdown('''# Dash Bio'''),

    rc.Markdown('''pip install dash-bio=={}'''.format(dash_bio.__version__),
                          style=styles.code_container),

    rc.Markdown('''
    Dash is a web application framework that provides pure Python abstraction
    around HTML, CSS, and JavaScript.

    Dash Bio is a suite of bioinformatics components that make it simpler to
    analyze and visualize bioinformatics data and interact with them in a Dash
    application.

    The source can be found on GitHub at [plotly/dash-bio](https://github.com/plotly/dash-bio).

    These docs are using Dash Bio version {}.
    '''.format(dash_bio.__version__, dash_bio.__version__))
]

DASHBIO_INSTALL_INSTRUCTIONS = rc.Markdown(
    '''
    ```
    >>> import dash_bio
    >>> print(dash_bio.__version__)
    {}
    ```
    '''.format(dash_bio.__version__),
    style=styles.code_container
)


DASHBIO_COMPONENTS = {

    'AlignmentChart': {
        'description': '''An alignment chart.''',
        'datafile': {
            'name': 'alignment_viewer_p53.fasta',
            'parameter': 'data'
        },
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_alignment_chart.png?raw=true',
            'width': 400
        }
    },

    'Circos': {
        'description': '''A circular ideogram with arcs representing links between genes.''',
        'library_imports': [
            ['json', 'json'],
        ],
        'datafile': {
            'name': 'circos_graph_data.json'
        },
        'params': {
            'layout': 'circos_graph_data[\'GRCh37\']',
            'tracks': '''[{
  'type': 'CHORDS',
  'data': circos_graph_data['chords'],
  'opacity': 0.7,
  'color': {'name': 'color'},
  'config': {
    'tooltipContent': {
      'source': 'source',
      'sourceID': 'id',
      'target': 'target',
      'targetID': 'id',
      'targetEnd': 'end'
    }
  }
}]'''
        },
        'setup_code': '''circos_graph_data = json.loads(data)''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_circos.png?raw=true',
        }
    },

    'Clustergram': {
        'description': '''A heatmap with dendrograms to display clustering of
        data such as gene expression data.''',
        'default_id': False,
        'library_imports': [
            ['pandas', 'pd'],
            ['dash_core_components', 'dcc']
        ],
        'params': {
            'data': 'data',
            'color_threshold': '{\'row\': 150, \'col\': 700}',
            'column_labels': 'list(df.columns.values)',
            'row_labels': 'list(df.index)',
            'hidden_labels': '[\'row\']',
            'width': 600
        },
        'component_wrap': 'dcc.Graph(figure=_)',
        'setup_code': '''df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files' +
    '/master/clustergram_mtcars.tsv',
    sep='\t', skiprows=4
).set_index('model')

data = df.values
''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_clustergram.png?raw=true',
        }
    },

    'FornaContainer': {
        'description': '''A secondary structure visualization for RNA molecules.''',
        'setup_code': '''sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))',
        'options': {
            'applyForce': True,
            'circularizeExternal': True,
            'avoidOthers': True,
            'labelInterval': 5,
            'name': 'PDB_01019'
        }
}]''',
        'params': {
            'sequences': 'sequences'
        }
    },

    'Ideogram': {
        'description': '''A visual representation and analysis tool for chromosome bands.''',
        'params': {
            'chrHeight': 250
        },
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_ideogram.png?raw=true'
        }
    },

    'ManhattanPlot': {
        'description': '''A plot that can be used to display the results of genomic studies
        sorted out by chromosome. Perfect for Genome Wide Association Studies (GWAS).''',
        'default_id': False,
        'component_wrap': 'dcc.Graph(figure=_)',
        'params': {
            'dataframe': 'df'
        },
        'library_imports': [
            ['pandas', 'pd'],
            ['dash_core_components', 'dcc']
        ],
        'setup_code': '''df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/' +
    'master/tests/dashbio_demos/sample_data/manhattan_data.csv'
)''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_manhattan.png?raw=true',
            'width': 800
        }
    },

    'Molecule2dViewer': {
        'description': '''A 2D rendering of molecular structures.''',
        'params': {
            'modelData': 'model_data'
        },
        'library_imports': [
            ['json', 'json']
        ],
        'setup_code': '''model_data = json.loads(data)''',
        'datafile': {
            'name': 'mol2d_buckminsterfullerene.json'
        }
    },

    'Molecule3dViewer': {
        'description': '''A 3D visualization of biomolecular structures.''',
        'params': {
            'modelData': 'model_data',
            'styles': 'styles_data',
            'backgroundOpacity': '\'0\''
        },
        'library_imports': [
            ['json', 'json'],
            ['urllib.request', 'urlreq']
        ],
        'setup_code': '''
model_data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/' +
    'master/mol3d/model_data.js'
).read()
styles_data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/' +
    'master/mol3d/styles_data.js'
).read()

model_data = json.loads(model_data)
styles_data = json.loads(styles_data)
''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_mol3d.png?raw=true'
        }
    },
    'NeedlePlot': {
        'description': '''A combination of a bar chart and a scatter plot, for data that are
        both categorical and continuous.''',
        'library_imports': [
            ['json', 'json']
        ],
        'params': {
            'mutationData': 'mdata'
        },
        'datafile': {
            'name': 'needle_PIK3CA.json'
        },
        'setup_code': '''mdata = json.loads(data)''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_needle_plot.png?raw=true',
            'width': 850
        }
    },

    'OncoPrint': {
        'description': '''A chart that can be used to visualize multiple
        genomic alternations with an interactive heatmap.''',
        'library_imports': [
            ['json', 'json']
        ],
        'datafile': {
            'name': 'oncoprint_dataset3.json',
            'parameter': 'data'
        },
        'setup_code': '''data = json.loads(data)
''',
        'image_info': {
            'location': 'https://github.com/plotly/docs-demos-dashbio/blob/master/images/pic_oncoprint.png?raw=true'
        }
    },

    'SequenceViewer': {
        'description': '''A sequence viewer.''',
        'library_imports': [
            ['dash_bio_utils.protein_reader', 'protein_reader']
        ],
        'datafile': {
            'name': 'sequence_viewer_P01308.fasta'
        },
        'setup_code': '''seq = protein_reader.read_fasta(datapath_or_datastring=data, is_datafile=False)[0]['sequence']''',
        'params': {
            'sequence': 'seq'
        },
    },

    'Speck': {
        'description': '''A 3D WebGL molecule viewer.''',
        'params': {
            'view': '{\'resolution\': 600}'
        },
        'datafile': {
            'name': 'speck_methane.xyz',
            'parameter': 'data'
        },
        'library_imports': [
            ['dash_bio_utils.xyz_reader', 'xyz_reader']
        ],
        'setup_code': '''data = xyz_reader.read_xyz(datapath_or_datastring=data, is_datafile=False)''',
        'image_info': {
            'location': 'https://raw.githubusercontent.com/plotly/docs-demos-dashbio/master/images/pic_speck.png'
        }
    },

    'VolcanoPlot': {
        'description': '''A graph that can be used to identify clinically meaningful markers in
        genomic experiments.''',
        'default_id': False,
        'library_imports': [
            ['pandas', 'pd'],
            ['dash_core_components', 'dcc']
        ],
        'setup_code': '''df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files' +
    '/master/volcano_data1.csv'
)''',
        'params': {
            'dataframe': 'df'
        },
        'component_wrap': 'dcc.Graph(figure=_)',
        'image_info': {
            'location': 'https://raw.githubusercontent.com/plotly/docs-demos-dashbio/master/images/pic_volcano.png?raw=true'
        }
    }
}

layout_children = generate_docs(
    'dash_bio',
    'dashbio',
    DASHBIO_LIBRARY_HEADING,
    DASHBIO_INSTALL_INSTRUCTIONS,
    DASHBIO_COMPONENTS
)

layout = html.Div(className="gallery", children=layout_children)
