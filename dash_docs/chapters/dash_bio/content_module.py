# -*- coding: utf-8 -*-
from dash_docs import tools
from .utils import create_doc_page, get_component_names

component_names = get_component_names('dash_bio')

examples = tools.load_examples(__file__)


# AlignmentChart/AlignmentViewer
AlignmentChart = create_doc_page(
    examples, component_names, 'alignment-chart.py', component_examples=[

        {
            'param_name': 'Color Scales',
            'description': 'Change the colors used for the heatmap.',
            'code': '''from six.moves.urllib import request as urlreq
from six import PY3
import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta").read()

if PY3:
    data = data.decode('utf-8')

dashbio.AlignmentChart(
    data=data,
    colorscale='hydro',
    conservationcolorscale='blackbody'
)

'''
        },
        {
            'param_name': 'Show/hide Barplots',
            'description': 'Enable or disable the secondary bar plots for gaps and conservation.',
            'code': '''from six.moves.urllib import request as urlreq
from six import PY3
import dash_bio as dashbio

data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta").read()

if PY3:
    data = data.decode('utf-8')

dashbio.AlignmentChart(
    data=data,
    showconservation=False,
    showgap=False
)'''
        },

        {
            'param_name': 'Tile Size',
            'description': 'Change the height and/or width of the tiles.',
            'code': '''from six.moves.urllib import request as urlreq
from six import PY3
import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta").read()

if PY3:
    data = data.decode('utf-8')

dashbio.AlignmentChart(
    data=data,
    tilewidth=50
)'''
        },
        {
            'param_name': 'Consensus Sequence',
            'description': 'Toggle the display of the consensus sequence at the bottom of the \
            heatmap.',
            'code': '''from six.moves.urllib import request as urlreq
from six import PY3
import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/alignment_viewer_p53.fasta").read()

if PY3:
    data = data.decode('utf-8')

dashbio.AlignmentChart(
    data=data,
    showconsensus=False
)'''
        }
    ]
)


# Circos
Circos = create_doc_page(
    examples, component_names, 'circos.py', component_examples=[
        {
            'param_name': 'Inner and Outer Radii',
            'description': 'Change the inner and outer radii of your Circos graph.',
            'code': '''import json
from six.moves.urllib import request as urlreq
import dash_bio as dashbio

data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/circos_graph_data.json').read()
circos_graph_data = json.loads(data)

dashbio.Circos(
    layout=circos_graph_data['GRCh37'],
    tracks=[{
        'type': 'CHORDS',
        'data': circos_graph_data['chords']
    }],
    config={
        'innerRadius': 40,
        'outerRadius': 200
    }
)'''
        },
    ]
)

# Clustergram
Clustergram = create_doc_page(
    examples, component_names, 'clustergram.py', component_examples=[
        {
            'param_name': 'Heatmap color scale',
            'description': 'Change the color scale by specifying values and colors.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv',
                 sep='	', skiprows=4).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

clustergram = dashbio.Clustergram(
    data=df.loc[rows].values,
    row_labels=rows,
    column_labels=columns,
    color_threshold={
        'row': 250,
        'col': 700
    },
    height=800,
    width=700,
    color_map= [
        [0.0, '#636EFA'],
        [0.25, '#AB63FA'],
        [0.5, '#FFFFFF'],
        [0.75, '#E763FA'],
        [1.0, '#EF553B']
    ]
)

dcc.Graph(figure=clustergram)'''
        },

        {
            'param_name': 'Dendrogram Cluster Colors/Line Widths',
            'description': 'Change the colors of the dendrogram traces that \
            are used to represent clusters, and configure their line widths.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv',
                 sep='	', skiprows=4).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

clustergram = dashbio.Clustergram(
    data=df.loc[rows].values,
    row_labels=rows,
    column_labels=columns,
    color_threshold={
        'row': 250,
        'col': 700
    },
    height=800,
    width=700,
    color_list={
        'row': ['#636EFA', '#00CC96', '#19D3F3'],
        'col': ['#AB63FA', '#EF553B'],
        'bg': '#506784'
    },
    line_width=2
)

dcc.Graph(figure=clustergram)'''
        },

        {
            'param_name': 'Relative Dendrogram Size',
            'description': 'Change the relative width and height of, respectively, the row \
            and column dendrograms compared to the width and height of the heatmap.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv',
                 sep='	', skiprows=4).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

clustergram = dashbio.Clustergram(
    data=df.loc[rows].values,
    row_labels=rows,
    column_labels=columns,
    color_threshold={
        'row': 250,
        'col': 700
    },
    height=800,
    width=700,
    display_ratio=[0.1, 0.7]
)

dcc.Graph(figure=clustergram)'''
        },
        {
            'param_name': 'Hidden Labels',
            'description': 'Hide the labels along one or both dimensions.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv',
                 sep='	', skiprows=4).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

clustergram = dashbio.Clustergram(
    data=df.loc[rows].values,
    row_labels=rows,
    column_labels=columns,
    color_threshold={
        'row': 250,
        'col': 700
    },
    height=800,
    width=700,
    hidden_labels='row'
)

dcc.Graph(figure=clustergram)'''
        },
        {
            'param_name': 'Annotations',
            'description': 'Annotate the clustergram by highlighting specific clusters.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv',
                 sep='	', skiprows=4).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

clustergram = dashbio.Clustergram(
    data=df.loc[rows].values,
    row_labels=rows,
    column_labels=columns,
    color_threshold={
        'row': 250,
        'col': 700
    },
    height=800,
    width=700,
    hidden_labels='row',
    col_group_marker=[
        {'group': 1, 'annotation': 'largest column cluster', 'color': '#EF553B'}
    ],
    row_group_marker=[
        {'group': 2, 'annotation': 'cluster 2', 'color': '#AB63FA'},
        {'group': 1, 'annotation': '', 'color': '#19D3F3'}
    ]
)

dcc.Graph(figure=clustergram)'''
        }
    ]
)

# FornaContainer
FornaContainer = create_doc_page(
    examples, component_names, 'forna-container.py', component_examples=[
        {
            'param_name': 'Height/width',
            'description': 'Change the size of the canvas component \
            that holds the container.',
            'code': '''import dash_bio as dashbio

sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))'
}]

dashbio.FornaContainer(
        sequences=sequences,
        height=300,
        width=500
)
'''
        },

        {
            'param_name': 'Disable zoom and pan',
            'description': 'Specify whether zoom and pan interactions should be \
            disabled.',
            'code': '''import dash_bio as dashbio

sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))'
}]

dashbio.FornaContainer(
        sequences=sequences,
        allowPanningAndZooming=False
)'''
        },

        {
            'param_name': 'Label interval',
            'description': 'Specify the interval at which the sequence \
            positions should be labelled.',
            'code': '''import dash_bio as dashbio

sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))',
        'options': {
            'labelInterval': 3
        }
}]

dashbio.FornaContainer(
        sequences=sequences
)'''
        },

        {
            'param_name': 'Fill color for all nodes',
            'description': 'Change the color of all of the nucleotides \
            in all sequences shown.',
            'code': '''import dash_bio as dashbio

sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))'
}]

dashbio.FornaContainer(
        sequences=sequences,
        nodeFillColor='pink'
)'''
        },

        {
            'param_name': 'Color scheme',
            'description': 'Change the parameter according to which \
            the structure is colored.',
            'code': '''import dash_bio as dashbio

sequences = [{
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))'
}]

dashbio.FornaContainer(
        sequences=sequences,
        colorScheme='positions'
)'''
        },

        {
            'param_name': 'Custom color schemes for different sequences',
            'description': 'Specify color schemes to be applied to all \
            sequences in the container, or sequence-specific color schemes.',
            'code': '''import dash_bio as dashbio

sequences = [
    {
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))',
        'options': {
            'name': 'PDB_01019'
        }
    },
    {
        'sequence': 'GGAGAUGACgucATCTcc',
        'structure': '((((((((()))))))))',
        'options': {
            'name': 'PDB_00598'
        }
    }
]

custom_colors = {
    'domain': [0, 100],
    'range': ['rgb(175, 0, 255)', 'orange'],
    'colorValues': {
        '': {'1': 10, '5': 40},  # default; can be overridden by sequence-specific colorschemes below
        'PDB_01019': {'10': 'rgb(120, 50, 200)', '13': 50},
        'PDB_00598': {str(i): i*5 for i in range(3, len(sequences[1]['sequence']))}
    }
}

custom_colors['colorValues']['PDB_00598']['1'] = 'red'
dashbio.FornaContainer(
    sequences=sequences,
    colorScheme='custom',
    customColors=custom_colors
)
'''
        },
    ]
)

# Ideogram
Ideogram = create_doc_page(
    examples, component_names, 'ideogram.py', component_examples=[
        {
            'param_name': 'Height/width',
            'description': 'Change the size of the chromosomes in your ideogram.',
            'code': '''import dash_bio as dashbio

dashbio.Ideogram(
    id='ideogram-size',
    chrHeight=800,
    chrWidth=100
)'''
        },

        {
            'param_name': 'Annotations',
            'description': 'Display annotations that are loaded from a JSON file.',
            'code': '''import dash_bio as dashbio

dashbio.Ideogram(
    id='ideogram-annotations',
    chromosomes=['X', 'Y'],
    annotationsPath='https://eweitz.github.io/ideogram/data/annotations/SRR562646.json'
)'''
        },

        {
            'param_name': 'Rotatability',
            'description': 'Disable rotation of the chromosome upon clicking on it.',
            'code': '''import dash_bio as dashbio

dashbio.Ideogram(
    id='ideogram-rotate',
    rotatable=False
)'''
        },

        {
            'param_name': 'Orientation',
            'description': 'Display chromosomes horizontally or vertically.',
            'code': '''import dash_bio as dashbio

dashbio.Ideogram(
    id='ideogram-orientation',
    orientation='horizontal'
)'''
        },

        {
            'param_name': 'Brush',
            'description': 'Highlight a region of the chromosome by adding a brush.',
            'code': '''import dash_bio as dashbio

dashbio.Ideogram(
    id='ideogram-brush',
    chromosomes=['X'],
    orientation='horizontal',
    brush='chrX:1-10000000'
)'''
        }
    ]
)

# ManhattanPlot
ManhattanPlot = create_doc_page(
    examples, component_names, 'manhattan-plot.py', component_examples=[
        {
            'param_name': 'Line colors',
            'description': 'Change the colors of the suggestive line and the genome-wide line.',
            'code': '''import pandas as pd
import dash_core_components as dcc
import dash_bio as dashbio

df = pd.read_csv("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/manhattan_data.csv")

n_chr = 23  # number of chromosome pairs in humans
assert 'CHR' in df.columns
assert df['CHR'].max() == n_chr

# Trim down the data
DATASET = df.groupby('CHR').apply(lambda u: u.head(50))
DATASET = DATASET.droplevel('CHR').reset_index(drop=True)

manhattanplot = dashbio.ManhattanPlot(
    dataframe=DATASET,
    suggestiveline_color='#AA00AA',
    genomewideline_color='#AA5500'
)

dcc.Graph(figure=manhattanplot)'''
        },

        {
            'param_name': 'Highlighted points color',
            'description': 'Change the color of the points that are considered significant.',
            'code': '''import pandas as pd
import dash_core_components as dcc
import dash_bio as dashbio

df = pd.read_csv("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/manhattan_data.csv")

n_chr = 23  # number of chromosome pairs in humans
assert 'CHR' in df.columns
assert df['CHR'].max() == n_chr

# Trim down the data
DATASET = df.groupby('CHR').apply(lambda u: u.head(50))
DATASET = DATASET.droplevel('CHR').reset_index(drop=True)

manhattanplot = dashbio.ManhattanPlot(
    dataframe=DATASET,
    highlight_color='#00FFAA'
)

dcc.Graph(figure=manhattanplot)'''
        }

    ]
)

# Molecule2dViewer
Molecule2dViewer = create_doc_page(
    examples, component_names, 'molecule-2d-viewer.py', component_examples=[

        {
            'param_name': 'Selected atom IDs',
            'description': 'Highlight specific atoms in the molecule.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio

model_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json').read()

dashbio.Molecule2dViewer(
    id='molecule2d-selectedatomids',
    modelData=json.loads(model_data),
    selectedAtomIds=list(range(10))
)'''
        },

        {
            'param_name': 'Model data',
            'description': 'Change the bonds and atoms in the molecule.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio

model_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol2d_buckminsterfullerene.json').read()

model_data = json.loads(model_data)
for atom in model_data['nodes']:
    atom.update(atom='N')
for bond in model_data['links']:
    bond.update(distance=50.0, strength=0.5)

dashbio.Molecule2dViewer(
    id='molecule2d-modeldata',
    modelData=model_data
)'''
        }
    ]
)

# Molecule3dViewer
Molecule3dViewer = create_doc_page(
    examples, component_names, 'molecule-3d-viewer.py', component_examples=[

        {
            'param_name': 'Selection type',
            'description': 'Choose what gets highlighted with the same color upon selection.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio

model_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js').read()
styles_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js').read()
model_data = json.loads(model_data)
styles_data = json.loads(styles_data)

dashbio.Molecule3dViewer(
    styles=styles_data,
    modelData=model_data,
    selectionType='Chain'
)'''
        },

        {
            'param_name': 'Background color/opacity',
            'description': 'Change the background color and opacity of the canvas on which \
            Mol3D is rendered.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio

model_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/model_data.js').read()
styles_data = urlreq.urlopen('https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/mol3d/styles_data.js').read()
model_data = json.loads(model_data)
styles_data = json.loads(styles_data)

dashbio.Molecule3dViewer(
    styles=styles_data,
    modelData=model_data,
    backgroundColor='#FF0000',
    backgroundOpacity=0.2
)'''
        }

    ]
)

# NeedlePlot
NeedlePlot = create_doc_page(
    examples, component_names, 'needle-plot.py', component_examples=[

        {
            'param_name': 'Needle style',
            'description': 'Change the appearance of the needles.',
            'code': '''import json
import six.moves.urllib.request as urlreq
from six import PY3

import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json").read()

if PY3:
    data = data.decode('utf-8')

mdata = json.loads(data)

dashbio.NeedlePlot(
    mutationData=mdata,
    needleStyle={
        'stemColor': '#FF8888',
        'stemThickness': 2,
        'stemConstHeight': True,
        'headSize': 10,
        'headColor': ['#FFDD00', '#000000']
    }
)'''
        },

        {
            'param_name': 'Domain style',
            'description': 'Change the appearance of the domains.',
            'code': '''import json
import six.moves.urllib.request as urlreq
from six import PY3

import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/needle_PIK3CA.json").read()

if PY3:
    data = data.decode("utf-8")

mdata = json.loads(data)

dashbio.NeedlePlot(
    mutationData=mdata,
    domainStyle={
        'displayMinorDomains': True,
        'domainColor': ['#FFDD00', '#00FFDD', '#0F0F0F', '#D3D3D3']
    }
)'''
        }

    ]
)

# OncoPrint
OncoPrint = create_doc_page(
    examples, component_names, 'onco-print.py', component_examples=[
        {
            'param_name': 'Colors',
            'description': 'Change the color of specific mutations, as well as \
            the background color.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json").read()
data = json.loads(data)

dashbio.OncoPrint(
    data=data,
    colorscale={
        'MISSENSE': '#e763fa',
        'INFRAME': '#E763FA'
    },
    backgroundcolor='#F3F6FA'
)'''
        },

        {
            'param_name': 'Size and spacing',
            'description': 'Change the height and width of the component, and \
            adjust the spacing between adjacent tracks.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json").read()
data = json.loads(data)

dashbio.OncoPrint(
    data=data,
    height=800,
    width=500,
    padding=0.25
)'''
        },

        {
            'param_name': 'Legend and overview',
            'description': 'Show or hide the legend and/or overview heatmap.',
            'code': '''import json
import six.moves.urllib.request as urlreq

import dash_bio as dashbio


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/oncoprint_dataset3.json").read()
data = json.loads(data)

dashbio.OncoPrint(
    data=data,
    showlegend=False,
    showoverview=False
)'''
        }
    ]
)

# SequenceViewer
SequenceViewer = create_doc_page(
    examples, component_names, 'sequence-viewer.py', component_examples=[
        {
            'param_name': 'Line length and line numbers',
            'description': 'Change the characters per line, and toggle the display \
            of line numbers.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3
import dash_bio as dashbio
from dash_bio_utils import protein_reader

fasta_str = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'sequence_viewer_P01308.fasta'
).read()

if PY3:
    fasta_str = fasta_str.decode('utf-8')

seq = protein_reader.read_fasta(datapath_or_datastring=fasta_str, is_datafile=False)[0]['sequence']

dashbio.SequenceViewer(
    id='sequence-viewer-lines',
    sequence=seq,
    showLineNumbers=False,
    charsPerLine=20
)'''
        },

        {
            'param_name': 'Subsequence selection',
            'description': 'Highlight a part of the sequence with a defined color.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3
import dash_bio as dashbio
from dash_bio_utils import protein_reader

fasta_str = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'sequence_viewer_P01308.fasta'
).read()

if PY3:
    fasta_str = fasta_str.decode('utf-8')

seq = protein_reader.read_fasta(datapath_or_datastring=fasta_str, is_datafile=False)[0]['sequence']

dashbio.SequenceViewer(
    id='sequence-viewer-selection',
    sequence=seq,
    selection=[10, 20, 'green']
)'''
        },

        {
            'param_name': 'Toolbar',
            'description': 'Display a toolbar to change the line length from the component itself.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3
import dash_bio as dashbio
from dash_bio_utils import protein_reader

fasta_str = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'sequence_viewer_P01308.fasta'
).read()

if PY3:
    fasta_str = fasta_str.decode('utf-8')

seq = protein_reader.read_fasta(datapath_or_datastring=fasta_str, is_datafile=False)[0]['sequence']

dashbio.SequenceViewer(
    id='sequence-viewer-toolbar',
    sequence=seq,
    toolbar=True
)'''
        },

        {
            'param_name': 'Title and badge',
            'description': 'Show a title or a badge with the nucleotide or amino acid \
            count of the protein.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3
import dash_bio as dashbio
from dash_bio_utils import protein_reader

fasta_str = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'sequence_viewer_P01308.fasta'
).read()

if PY3:
    fasta_str = fasta_str.decode('utf-8')

seq = protein_reader.read_fasta(datapath_or_datastring=fasta_str, is_datafile=False)[0]['sequence']

dashbio.SequenceViewer(
    id='sequence-viewer-titlebadge',
    sequence=seq,
    title='Insulin',
    badge=False
)'''
        }
    ]
)

# Speck
Speck = create_doc_page(
    examples, component_names, 'speck.py', component_examples=[

        {
            'param_name': 'Molecule rendering styles',
            'description': 'Change the level of atom outlines, ambient occlusion, \
            and more with the "view" parameter.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3

import dash_bio as dashbio
from dash_bio_utils import xyz_reader


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz").read()

if PY3:
    data = data.decode('utf-8')

data = xyz_reader.read_xyz(datapath_or_datastring=data, is_datafile=False)

dashbio.Speck(
    data=data,
    view={
        'resolution': 400,
        'ao': 0.1,
        'outline': 1,
        'atomScale': 0.25,
        'relativeAtomScale': 0.33,
        'bonds': True
    }
)'''
        },

        {
            'param_name': 'Scroll to zoom',
            'description': 'Allow for the scroll wheel to control zoom for the molecule.',
            'code': '''import six.moves.urllib.request as urlreq
from six import PY3

import dash_bio as dashbio
from dash_bio_utils import xyz_reader


data = urlreq.urlopen("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/speck_methane.xyz").read()

if PY3:
    data = data.decode('utf-8')

data = xyz_reader.read_xyz(datapath_or_datastring=data, is_datafile=False)

dashbio.Speck(
    data=data,
    scrollZoom=True
)'''
        }

    ]
)

# VolcanoPlot
VolcanoPlot = create_doc_page(
    examples, component_names, 'volcano-plot.py', component_examples=[
        {
            'param_name': 'Colors',
            'description': 'Choose the colors of the scatter plot points, the highlighted points, \
            the genome-wide line, and the effect size lines.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv")

volcanoplot = dashbio.VolcanoPlot(
        dataframe=df,
        effect_size_line_color='#AB63FA',
        genomewideline_color='#EF553B',
        highlight_color='#119DFF',
        col='#2A3F5F'
)

dcc.Graph(figure=volcanoplot)'''
        },
        {
            'param_name': 'Point sizes and line widths',
            'description': 'Change the size of the points on the scatter plot, \
            and the widths of the effect lines and genome-wide line.',
            'code': '''import pandas as pd

import dash_core_components as dcc
import dash_bio as dashbio


df = pd.read_csv("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/volcano_data1.csv")

volcanoplot = dashbio.VolcanoPlot(
        dataframe=df,
        point_size=10,
        effect_size_line_width=4,
        genomewideline_width=2
)

dcc.Graph(figure=volcanoplot)'''
        }
    ]
)
