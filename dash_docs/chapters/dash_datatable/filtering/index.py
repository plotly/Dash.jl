
import dash_html_components as html
import dash_core_components as dcc

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(
    [
        rc.Markdown("""
        # DataTable Filtering

        As discussed in the <dccLink href="/datatable/interactivity" children="interactivity chapter"/>,
        `DataTable` includes filtering capabilities.
        Set `filter_action='native'` for clientside (front-end) filtering
        or `filter_action='custom'` to perform your own filtering in Python.

        `filter_action='native'` will work well up to 10,000-100,000 rows.
        After which, you may want to use `filter_action='custom'` so that your
        app sends less data over the network into the browser.
        """),

        rc.Markdown(
            examples['filtering_fe.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['filtering_fe.py'][1],
            className='example-container'
        ),

        rc.Markdown(
        '''
        Notes:
        - As above, we recommend fixing column widths with filtering. Otherwise, the column
        widths will grow or shrink depending on how wide the data is within the columns.
        - There is a bug with `fixed_rows` that prevents horizontal scroll
        when no filter results are returned. Until this bug is fixed, we recommend
        avoiding `fixed_rows`. For updates, see [plotly/dash-table#746](https://github.com/plotly/dash-table/issues/746)
        - The default filtering behavior will depend on the data type of the column (see below).
        Data types are not inferred, so you have to set them manually.

        The example below **determines the datatype of the column automatically with Pandas**:
        '''
        ),

        rc.Markdown(
            examples['filtering_fe_autotype.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['filtering_fe_autotype.py'][1],
            className='example-container'
        ),

        rc.Markdown("""
        ## Filtering Operators

        The filtering syntax is data-type specific.
        Data types are not inferred, they must be [set manually](/datatable/typing).
        If a type is not specified, then we assume it is a string (text).

        **Text & String Filtering**

        - `United`
        - `= United`
        - `United States`
        - `"United States"`
        - `= United States`
        - `= "United States"`
        - `contains United`
        - `> United`
        - `>= United`
        - `< United`
        - `<= United`

        By default, the columns with the "text" type use the
        `contains` operator. So, searching `United` is the same as
        `contains United`

        For legacy purposes, `eq` can also be substituted for `=`.

        `>`, `>=`, `<`, and `<=` compare strings in dictionary order,
        with numbers and most symbols coming before letters,
        and uppercase coming before lowercase.

        If you have quotes in the string, you can use a different quote, or
        escape the quote character. So `eq 'Say "Yes!"'` and
        `="Say \\"Yes!\\""` are the same.

        **Numeric Filtering**

        - `43.828`
        - `= 43.828`
        - `> 43.828`
        - `>= 43.828`
        - `< 43.828`
        - `<= 43.828`

        By default, columns with the `numeric` type use the `=` operator.
        So, searching `43.828` is the same as `= 43.828`.

        **Datetime Filtering**

        - `2020`
        - `2020-01`
        - `2020-01-01`
        - `2020-01-01 04:01`
        - `2020-01-01 04:01:10`
        - `datestartswith 2020`
        - `datestartswith 2020-01`
        - `datestartswith 2020-01-01`
        - `datestartswith 2020-01-01 04:01`
        - `datestartswith 2020-01-01 04:01:10`
        - `> 2020-01`
        - `> 2020-01-20`
        - `>= 2020-01`
        - `>= 2020-01-20`
        - `< 2020-01`
        - `< 2020-01-20`
        - `<= 2020-01`
        - `<= 2020-01-20`

        ## Operators

        Many operators have two forms: a symbol (`=`) and a word (`eq`) that
        can be used interchangeably.

        """),
        html.Table([html.Tr([
            html.Td([
                html.H4(
                    html.P([html.Code('='), ' ', html.Code('eq')]),
                    style={'margin': '0px'}),
                rc.Markdown('Default operator for `number` columns')]),
            html.Td(rc.Markdown("""
            Are the two numbers equal? Regardless of type, will first try to
            convert both sides to numbers and compare the numbers. If either
            cannot be converted to a number, looks for an exact match.
            """))
        ]), html.Tr([
            html.Td([
                html.H4(html.P(html.Code('contains')), style={'margin': '0px'}),
                rc.Markdown('Default operator for `text` and `any` columns')
            ]),
            html.Td(rc.Markdown("""
            Does the text value contain the requested substring?
            May match the beginning, end, or anywhere in the middle. The match
            is case-sensitive and exact.
            """))
        ]), html.Tr([
            html.Td([
                html.H4(
                    html.P(html.Code('datestartswith')),
                    style={'margin': '0px'}),
                rc.Markdown('Default operator for `datetime` columns')]),
            html.Td(rc.Markdown("""
            Does the datetime start with the given parts? Enter a partial
            datetime, this will match any date that has at least as much
            precision and starts with the same pieces. For example,
            `datestartswith '2018-03-01'` will match `'2018-03-01 12:59'` but
            not `'2018-03'` even though we interpret `'2018-03-01'` and
            `'2018-03'` both to mean the first instant of March, 2018.
            """))
        ]), html.Tr([
            html.Td(html.H4(html.P([
                html.Code('>'), ' ', html.Code('gt'), u' \u00a0 ',
                html.Code('<'), ' ', html.Code('lt'), html.Br(),
                html.Code('>='), ' ', html.Code('ge'), u' \u00a0 ',
                html.Code('<='), ' ', html.Code('le'), html.Br(),
                html.Code('!='), ' ', html.Code('ne')
            ]), style={'margin': '0px'})),
            html.Td(rc.Markdown("""
            Comparison: greater than, less than, greater or equal, less or
            equal, and not equal. Two strings compare by their dictionary
            order, with numbers and most symbols coming before letters, and
            uppercase coming before lowercase.
            """))
        ])]),
        html.Br(),

        rc.Markdown("""
        ## Back-end Filtering

        For large dataframes, you can perform the filtering in Python instead
        of the default clientside filtering. You can find more information on
        performing operations in python in the
        <dccLink href="/datatable/callbacks" children="Python Callbacks chapter"/>.

        The syntax is (now) the same as front-end filtering, but it's up to the
        developer to implement the logic to apply these filters on the Python
        side.
        In the future we may accept any filter strings, to allow you to
        write your own expression query language.

        Example:
        """),

        rc.Markdown(
            examples['filtering_be.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['filtering_be.py'][1],
            className='example-container'
        ),

        rc.Markdown("---"),

        rc.Markdown("""
        # Advanced filter usage

        Filter queries can be as simple or as complicated as you want
        them to be. When something is typed into a column filter, it
        is automatically converted to a filter query on that column
        only.
        """),

        rc.Markdown(
            examples['filtering_advanced.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['filtering_advanced.py'][1],
            className='example-container'
        ),

        rc.Markdown("""

        The `filter_query` property is written to when the user
        filters the data by using the column filters. For example, if
        a user types `ge 100000000` in the `pop` column filter, and
        `Asia` in the `continent` column filter, `filter_query` will
        look like this:

        >`{pop} ge 100000000 && {continent} contains "Asia"`

        Try typing those values into the column filters in the app
        above, and ensure that the "Read filter_query" option is
        selected.

        The `filter_query` property can also be written to. This might
        be useful when performing more complex filtering,
        like if you want to filter a column based on two (or more)
        conditions. For instance, say that we want countries with a
        population greater than 100 million, but less than 500
        million. Then our `filter_query` would be as follows:

        >`{pop} ge 100000000 and {pop} le 500000000`

        Select the "Write to filter_query" option in the app above,
        and try it out by copying and pasting the filter query above
        into the input box.

        Say that we now want to get a bit more advanced, and
        cross-filter between columns; for instance, we only want the
        results that are located in Asia. Now, our filter query
        becomes:

        >`{pop} ge 100000000 and {pop} le 500000000 and {continent} eq "Asia"`

        We can make the expression even more complex. For example,
        let's say we want all of those countries with the populations
        that fall within our boundaries and that are in Asia, but for
        some reason we also want to include Singapore. This results in
        a filter query that is a little more long-winded:

        >`(({pop} ge 100000000 and {pop} le 500000000) or {country} eq "Singapore") and {continent} eq "Asia"`

        Note that we've grouped expressions together using
        parentheses. This is part of the filtering syntax. Just as is
        true in mathematical expressions, the expressions in the
        innermost parentheses are evaluated first.

        ## Symbol-based versus letter-based operators

        An important thing to notice is that the two types of
        relational operators that can be used in the column filters
        (symbol-based, like `>=`, and letter-based, like `ge`) are not
        converted into one another when `filter_query` is being
        constructed from the values in the column filters. Therefore,
        if using `filter_query` to implement backend filtering, it's
        necessary to take both of these forms of the
        "greater-than-or-equal-to" operator into account when parsing
        the query string (or ensure that the user only uses the ones
        that the backend can parse).

        However, in the case of the logical operator `and/&&`, when
        the table is constructing the query string, the symbol-based
        representation will always be used.

        ## Derived filter query structure

        The `derived_filter_query_structure` prop is a dictionary
        representation of the query syntax tree. You can use the value
        of this property to implement backend filtering.

        For a query that describes a relationship between two values,
        there are three components: the operation, the left-hand side,
        and the right-hand side. For instance, take the following
        query:

        >`{pop} ge 100000000`

        The operation here is `ge` (i.e., `>=`), the left-hand side is
        the field `pop` (corresponding to the column `pop`), and the
        right-hand side is the value `100000000`. As the queries
        become increasingly complex, so do the query structures. Try
        it out by expanding the "Derived filter query structure" in
        the example app above.

        Note that for all operators, there are two keys `subType` and
        `value` that correspond to, respectively, the symbol-based
        representation and the originally inputted representation of
        the operator. So, in the case of the query above, `subType`
        will be `>=` and `value` will be `ge `; if our query string
        were `{pop} >= 100000000` instead, both `subType` and `value`
        will be `>=`.

        ### Backend filtering with `pandas` and `derived_filter_query_structure`

        It's likely that your data are already in a `pandas`
        dataframe. Using the `derived_filter_query_structure` in
        conjunction with `pandas` filters can enable you to do some
        pretty heavy lifting with the table! You can see an example of
        this below.

        """),

        rc.Markdown(
            examples['filtering_advanced_derived.py'][0],
            style=styles.code_container
        ),

        html.Div(
            examples['filtering_advanced_derived.py'][1],
            className='example-container'
        )

    ]
)
