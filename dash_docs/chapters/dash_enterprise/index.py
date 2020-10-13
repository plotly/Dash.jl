import dash_html_components as html
import os

from dash_docs import reusable_components as rc

layout = html.Div(className='toc', children=[
    html.H1('Dash Enterprise Documentation'),

    rc.Section("What's Dash Enterprise?", [
        rc.Chapter('Learn More About Dash Enterprise',
                'https://plotly.com/dash/',
                """Dash Enterprise is Plotly's commercial offering
                   for managing and improving your Dash apps in your
                   organization. [Learn more](https://plotly.com/dash) or
                   [request a trial](https://plotly.com/get-demo/).""")
    ]) if 'DASH_DOCS_URL_PREFIX' not in os.environ else '',

    rc.Section("Deployment", [
        rc.Chapter('Part 1. Initialize Dash Apps on Dash Enterprise',
                '/dash-enterprise/initialize',
                'Initialize an app via Dash Enterprise UI.'),
        rc.Chapter('Part 2. Deploy Dash Apps on Dash Enterprise',
                '/dash-enterprise/deployment',
                'Deploy Dash Apps to the Dash Enterprise using '
                'HTTPS or SSH. Start with a sample app or deploy your existing app.')
    ]),

    rc.Section("Configuration", [
        rc.Chapter('Application Structure',
                '/dash-enterprise/application-structure',
                'Ensure that your app meets all the requirements for deployment.'),
        rc.Chapter('Adding Static Assets',
                '/dash-enterprise/static-assets',
                'Learn how to include custom CSS, JS, and images with the `assets` directory.'),
        rc.Chapter('Configuring System Dependencies',
                '/dash-enterprise/configure-system-dependencies',
                'Install and configure system dependencies such as database drivers or the Java JRE environment.'),
    ]),

rc.Section("User Interface", [
        rc.Chapter('Dash App Portal',
                '/dash-enterprise/portal',
                'Learn about the Dash App Portal.'),
        rc.Chapter('Admin Panel',
                '/dash-enterprise/admin-panel',
                'Manage users in the Admin Panel.'),
        rc.Chapter('Dash App Privacy',
                '/dash-enterprise/privacy',
                'Learn about Dash App privacy and how to manage collaborators.'),
        rc.Chapter('Linking a Redis Database',
                '/dash-enterprise/redis-database',
                'Create and link an in-memory database to your Dash Apps.'),
        rc.Chapter('Setting Environment Variables',
                '/dash-enterprise/environment-variables',
                'Environment variables are commonly used to store secret '
                'variables like database passwords.'),
        rc.Chapter('Mapping Local Directories',
                '/dash-enterprise/map-local-directories',
                'Directory mappings allow you to make directories on the '
                'Dash Enterprise available to your app.')
    ]),

    rc.Section("Advanced", [
        rc.Chapter('Authenticating to Dash Enterprise with SSH',
                '/dash-enterprise/ssh',
                "There are two methods to deploy Dash Apps: HTTPS and SSH. "
                "We recommend getting started with the HTTPS method. "
                "In this section, you'll learn more about deploying with SSH."),
        rc.Chapter('Managing Dash Apps from the Command Line',
                '/dash-enterprise/cli',
                "A list of commands to manage Dash apps and services using"
                " the command line."),
        rc.Chapter('Dash Enterprise Auth Features',
                '/dash-enterprise/app-authentication',
                'Using `dash-enterprise-auth` to manage user authentication data.'),
        rc.Chapter('App Deployment Health Checks',
                '/dash-enterprise/checks',
                'Create custom checks to ensure that a newly deployed app can serve traffic.'),
        rc.Chapter('Adding Private Python Packages',
                '/dash-enterprise/private-packages',
                'Install private python packages in your Dash Apps.'),
        rc.Chapter('Linking a Celery Process',
                '/dash-enterprise/celery-process',
                'Add a task queue to your Dash Apps.'),
        rc.Chapter('Create a Staging Dash App',
                '/dash-enterprise/staging-app',
                'Use a staged Dash App to test changes before updating your '
                'production Dash App.'),
        rc.Chapter('Dash Enterprise PDF Service',
                '/dash-enterprise/pdf-service',
                'Utilize the Dash Enterprise API endpoint for creating '
                'PDF exports of your Dash applications')
    ]),

    rc.Section("Troubleshooting", [
        rc.Chapter('App Analytics',
                '/dash-enterprise/analytics',
                """View app analytics such as last updated, CPU usage, Memory Usage, and more."""),
        rc.Chapter('App Logs',
                '/dash-enterprise/logs',
                """Check your Dash App's logs via the Dash Enterprise
                UI or via the command line."""),
        rc.Chapter('Common Errors',
                '/dash-enterprise/troubleshooting',
                """Common errors when deploying Dash Apps."""),
        rc.Chapter('Support',
                '/dash-enterprise/support',
                """Having trouble deploying your app? Our dedicated support team is available to help you out.""")
    ]),

    rc.Section("Reference", [
        rc.Chapter('Advanced Git',
                '/dash-enterprise/git',
                'A reference for git commands and how they are used '
                'with Dash Enterprise.'),
        rc.Chapter('Dash Enterprise API',
                'https://github.com/plotly/dds-api-docs',
                'Reference documentation for Dash Enterprise\'s GraphQL API. '
                'Use this to programmatically add collaborators, '
                'initialize dash apps and more.')
    ])
])
