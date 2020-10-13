import six.moves.urllib.request as urlreq
from six import PY3
import dash
import dash_bio as dashbio
from dash_bio_utils import protein_reader
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

fasta_str = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'sequence_viewer_P01308.fasta'
).read()

if PY3:
    fasta_str = fasta_str.decode('utf-8')

seq = protein_reader.read_fasta(datapath_or_datastring=fasta_str, is_datafile=False)[0]['sequence']

app.layout = html.Div([
    dashbio.SequenceViewer(
        id='my-sequence-viewer',
        sequence=seq
    ),
    html.Div(id='sequence-viewer-output')
])


@app.callback(
    dash.dependencies.Output('sequence-viewer-output', 'children'),
    [dash.dependencies.Input('my-sequence-viewer', 'mouseSelection')]
)
def update_output(value):
    if value is None or len(value) == 0:
        return 'There is no mouse selection.'
    return 'The mouse selection is {}.'.format(value['selection'])


if __name__ == '__main__':
    app.run_server(debug=True)
