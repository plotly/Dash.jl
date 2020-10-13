import dash
from dash.dependencies import Input, Output
import dash_html_components as html
import json
from dash_table import DataTable
import pandas as pd

types = {
    'id': 'numeric',
    'Complaint_ID': 'numeric',
    'ZIP_code': 'numeric',
    'Date_received': 'datetime',
    'Date_sent_to_company': 'datetime',
}

df = pd.read_csv('https://github.com/plotly/datasets/raw/master/26k-consumer-complaints.csv')
df['id'] = df['Unnamed: 0']
df = df.drop(['Unnamed: 0'], axis=1)
df = df.reindex(columns=['id']+df.columns[:-1].tolist())
df.columns = [column.replace(" ", "_") for column in df.columns]
df.columns = [column.replace("-", "_") for column in df.columns]

app = dash.Dash()
app.scripts.config.serve_locally = True

app.layout = DataTable(
    id='demo-table',
    data=df.to_dict('rows'),
    columns=[{ 'id': i, 'name': i, 'type': types.get(i, 'any')} for i in df.columns],
    filter_action='custom',
    page_action='native',
    page_size=15,
    virtualization=True,
    style_cell={
        'min-width': '100px'
    },
    css=[
        { 'selector': '.row-1', 'rule': 'min-height: 500px;' }
    ]
)


def to_string(filter):
    operator_type = filter.get('type')
    operator_subtype = filter.get('subType')

    if operator_type == 'relational-operator':
        if operator_subtype == '=':
            return '=='
        else:
            return operator_subtype
    elif operator_type == 'logical-operator':
        if operator_subtype == '&&':
            return '&'
        else:
            return '|'
    elif operator_type == 'expression' and operator_subtype == 'value' and type(filter.get('value')) == str:
        return '"{}"'.format(filter.get('value'))
    else:
        return filter.get('value')


def construct_filter(derived_query_structure, df, complexOperator=None):

    # there is no query; return an empty filter string and the
    # original dataframe
    if derived_query_structure is None:
        return ('', df)

    # the operator typed in by the user; can be both word-based or
    # symbol-based
    operator_type = derived_query_structure.get('type')

    # the symbol-based representation of the operator
    operator_subtype = derived_query_structure.get('subType')

    # the LHS and RHS of the query, which are both queries themselves
    left = derived_query_structure.get('left', None)
    right = derived_query_structure.get('right', None)

    # the base case
    if left is None and right is None:
        return (to_string(derived_query_structure), df)

    # recursively apply the filter on the LHS of the query to the
    # dataframe to generate a new dataframe
    (left_query, left_df) = construct_filter(left, df)

    # apply the filter on the RHS of the query to this new dataframe
    (right_query, right_df) = construct_filter(right, left_df)

    # 'datestartswith' and 'contains' can't be used within a pandas
    # filter string, so we have to do this filtering ourselves
    if complexOperator is not None:
        right_query = right.get('value')
        # perform the filtering to generate a new dataframe
        if complexOperator == 'datestartswith':
            return ('', right_df[right_df[left_query].astype(str).str.startswith(right_query)])
        elif complexOperator == 'contains':
            return ('', right_df[right_df[left_query].astype(str).str.contains(right_query)])

    if operator_type == 'relational-operator' and operator_subtype in ['contains', 'datestartswith']:
        return construct_filter(derived_query_structure, df, complexOperator=operator_subtype)

    # construct the query string; return it and the filtered dataframe
    return ('{} {} {}'.format(
        left_query,
        to_string(derived_query_structure) if left_query != '' and right_query != '' else '',
        right_query
    ).strip(), right_df)


@app.callback(
    Output("demo-table", "data"),
    [Input("demo-table", "derived_filter_query_structure")]
)
def onFilterUpdate(derived_query_structure):
    (pd_query_string, df_filtered) = construct_filter(derived_query_structure, df)

    if pd_query_string != '':
        df_filtered = df_filtered.query(pd_query_string)

    return df_filtered.to_dict('rows')


if __name__ == "__main__":
    app.run_server(debug=True)
