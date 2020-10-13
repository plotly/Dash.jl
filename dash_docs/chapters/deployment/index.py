import dash_core_components as dcc
import dash_html_components as html
from dash_docs import styles
from dash_docs import reusable_components as rc

layout = html.Div(children=[rc.Markdown('''
# Deploying Dash Apps

By default, Dash apps run on `localhost` - you can only access them on your
own machine. To share a Dash app, you need to "deploy" your Dash app to a
server and open up the server's firewall to the public or to a restricted
set of IP addresses.

Dash uses Flask under the hood. This makes deployment easy: you can deploy
a Dash app just like you would deploy a Flask app.
Almost every cloud server provider has a guide for deploying
Flask apps. For more, see the official [Flask Guide to Deployment](http://flask.pocoo.org/docs/latest/deploying/)
or view the tutorial on deploying to Heroku below.

### Dash Enterprise

[Dash Enterprise](https://plotly.com/dash/)
is Plotly's commercial product for deploying
Dash Apps on your company's servers or on AWS, Google Cloud, or Azure.
It offers an enterprise-wide Dash App Portal,
easy git-based deployment, automatic URL namespacing,
built-in SSL support, LDAP authentication, and more.
[Learn more about Dash Enterprise](https://plotly.com/dash) or
[get in touch to start a trial](https://plotly.com/get-demo/).

For existing customers, see the <dccLink href="/dash-enterprise" children="Dash Enterprise Documentation"/>.

### Dash and Flask

Dash apps are web applications. Dash uses Flask as the web framework.
The underlying Flask app is available at `app.server`, that is:
'''),

          rc.Markdown('''
          ```python
          import dash

          app = dash.Dash(__name__)

          server = app.server # the Flask app
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
You can also pass your own flask app instance into Dash:
'''),

          rc.Markdown('''
          ```python
          import flask

          server = flask.Flask(__name__)
          app = dash.Dash(__name__, server=server)
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
By exposing this `server` variable, you can deploy Dash apps like you would
any Flask app. For more, see the official [Flask Guide to Deployment](http://flask.pocoo.org/docs/latest/deploying/).
Note that

> While lightweight and easy to use, *Flask's built-in server is not suitable
> for production* as it doesn't scale well and by default serves only one
> request at a time

### Heroku Example

Heroku is one of the easiest platforms for deploying and managing public Flask
applications.

[View the official Heroku guide to Python](https://devcenter.heroku.com/articles/getting-started-with-python#introduction).

Here is a simple example. This example requires a Heroku account,
`git`, and `virtualenv`.

***

**Step 1. Create a new folder for your project:**
'''),

          rc.Markdown('''
          ```shell
          $ mkdir dash_app_example
          $ cd dash_app_example
          ```
          ''', style=styles.code_container),

          rc.Markdown('''

***

**Step 2. Initialize the folder with `git` and a `virtualenv`**

'''),

          rc.Markdown('''
          ```shell
          $ git init        # initializes an empty git repo
          $ virtualenv venv # creates a virtualenv called "venv"
          $ source venv/bin/activate # uses the virtualenv
          ```
          ''',style=styles.code_container),

          rc.Markdown('''
`virtualenv` creates a fresh Python instance. You will need to reinstall your
app's dependencies with this virtualenv:
'''),

          rc.Markdown('''
          ```shell
          $ pip install dash
          $ pip install plotly
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
You will also need a new dependency, `gunicorn`, for deploying the app:
'''),

          rc.Markdown('''
          ```shell
          $ pip install gunicorn
          ```
          ''', style=styles.code_container),

          rc.Markdown('''***
**Step 3. Initialize the folder with a sample app (`app.py`), a `.gitignore` file, `requirements.txt`, and a `Procfile` for deployment**

Create the following files in your project folder:

**`app.py`**
'''),

    rc.Markdown('''
    ```python
    import os

    import dash
    import dash_core_components as dcc
    import dash_html_components as html

    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

    server = app.server

    app.layout = html.Div([
        html.H2('Hello World'),
        dcc.Dropdown(
            id='dropdown',
            options=[{'label': i, 'value': i} for i in ['LA', 'NYC', 'MTL']],
            value='LA'
        ),
        html.Div(id='display-value')
    ])

    @app.callback(dash.dependencies.Output('display-value', 'children'),
                  [dash.dependencies.Input('dropdown', 'value')])
    def display_value(value):
        return 'You have selected "{}"'.format(value)

    if __name__ == '__main__':
        app.run_server(debug=True)
    ```
    ''', style=styles.code_container),

          rc.Markdown('''
***

**`.gitignore`**
'''),

          rc.Markdown('''
          ```shell
          venv
          *.pyc
          .DS_Store
          .env
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
          ***

          **`Procfile`**
          '''),

          rc.Markdown('''
          ```shell
          web: gunicorn app:server
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
(Note that `app` refers to the filename `app.py`.
`server` refers to the variable `server` inside that file).

***

**`requirements.txt`**

`requirements.txt` describes your Python dependencies.
You can fill this file in automatically with:
'''),

          rc.Markdown('''
          ```shell
          $ pip freeze > requirements.txt
          ```
          ''', style=styles.code_container),

          rc.Markdown('''
***

**4. Initialize Heroku, add files to Git, and deploy**
'''),

    rc.Markdown('''
    ```shell
    $ heroku create my-dash-app # change my-dash-app to a unique name
    $ git add . # add all files to git
    $ git commit -m 'Initial app boilerplate'
    $ git push heroku master # deploy code to heroku
    $ heroku ps:scale web=1  # run the app with a 1 heroku "dyno"
    ```
    ''', style=styles.code_container),

          rc.Markdown('''
You should be able to view your app at `https://my-dash-app.herokuapp.com`
(changing `my-dash-app` to the name of your app).

**5. Update the code and redeploy**

When you modify `app.py` with your own code, you will need to add the changes
to git and push those changes to heroku.

'''),

    rc.Markdown('''
    ```shell
    $ git status # view the changes
    $ git add .  # add all the changes
    $ git commit -m 'a description of the changes'
    $ git push heroku master
    ```
''', style=styles.code_container),

          rc.Markdown('''

***

This workflow for deploying apps on heroku is very similar to how deployment
works with the Plotly Enterprise's Dash Enterprise.
[Learn more](https://plotly.com/dash/) or [get in touch](https://plotly.com/get-demo/).
''')
])
