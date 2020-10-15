module chapters_deployment
using Dash, DashCoreComponents, DashHtmlComponents

include("../../utils.jl")

app = dash()

app.layout = html_div() do
    html_h1("Deploying Dash Apps"),
    dcc_markdown("
By default, Dash apps run on `localhost` - you can only access them on your
own machine. To share a Dash app, you need to 'deploy' your Dash app to a
server and open up the server's firewall to the public or to a restricted
set of IP addresses.
    
## Dash Enterprise 

[Dash Enterprise](https://plotly.com/dash/?_ga=2.249471751.1080104966.1578062860-1986131108.1567098614) is Plotly's commercial product for deploying Dash
Apps on your company's servers or on AWS, Google Cloud, or Azure. It
offers an enterprise-wide Dash App Portal, easy git-based deployment,
automatic URL namespacing, built-in SSL support, LDAP authentication, and
more. [Learn more about Dash Enterprise](https://plotly.com/dash?_ga=2.249471751.1080104966.1578062860-1986131108.1567098614) or [get in touch to start a
trial](https://plotly.com/get-demo/?_ga=2.48144423.1080104966.1578062860-1986131108.1567098614).

For existing customers, see the [Dash Enterprise Documentation](https://dash.plotly.com/dash-enterprise).

## Dash and HTTP.jl

Dash apps are web applications. Dash relies upon HTTP.jl to provide client
and server functionality. When you create a Dash for Julia application, the
resulting object provides an interface that wraps this functionality:

```julia
    using Dash

    app = dash()
```

## Heroku Example

Heroku is one of the easiest platforms for deploying and managing public web applications.

Here is a simple example. This example requires a Heroku account and `git`.

---

**Step 1.** Create a new folder for your project:

```
    \$ mkdir dash_app_example
    \$ cd dash_app_example
```

---

**Step 2.** Initialize the folder with `git`

```
    \$ git init        # initializes an empty git repo
```

---

**Step 3.** Initialize the folder with a sample app (`app.jl`), and a `.gitignore` file (not required, but will avoid committing any files that aren't necessary for your app to function).

Add the following Julia application to your project folder:

**`app.jl`**

```julia
    using Dash, DashHtmlComponents, DashCoreComponents;

    app = dash();

    app.layout = html_div() do
        dcc_dropdown(
            id = \"dropdown\",
            options = [
                Dict(\"label\" => \"Los Angeles\", \"value\" => \"LA\"),
                Dict(\"label\" => \"New York City\", \"value\" => \"NYC\"),
                Dict(\"label\" => \"Montreal\", \"value\" => \"MTL\")                
            ],
            value = \"LA\"),
        html_div(id = \"display-value\")
    end;

    callback!(app,
        Output(\"display-value\", \"children\"),
        Input(\"dropdown\", \"value\")) do value 
            \"You've entered \$(value)\"
    end;

    # the default Dash port is 8050, but for Heroku deployments, it's
    # important to ensure the server port matches the PORT environment
    # variable; when running the app on your own machine, omit this
    # unless PORT is set.
    port = parse(Int64, ENV[\"PORT\"]);

    run_server(app, \"0.0.0.0\", port)
```

---

**Step 4.** Use Julia's package manager to generate a file (`Project.toml`) containing all the dependencies for your application.

Make note of any packages you will need for your application once deployed, and install them using `Pkg`. For example, given
our application above, we'll want to launch Julia and then type `]` at the prompt. You should see a new prompt, which includes
the current Julia version and `pkg>`.

From within the directory you created to store your new Dash application, type `activate .` to create a new environment for
this deployment:

```julia
    (@v1.5) pkg> activate .
    Activating new environment at `/dash-projects/dash_app_example/Project.toml`
```

Now, from the same prompt, install the packages (edit as needed for your own application):


```julia
   (dash_app_example) pkg> add Dash, DashHtmlComponents, DashCoreComponents
```


Julia should now display a message indicating that the registry is being updated, and that package versions are being resolved
and installed. Once finished, you should see the `pkg>` prompt again. Hold down the control and C keys, and this should return
you to the `julia>` prompt. From here we can exit Julia, and we'll include the `Project.toml` and `Manifest.toml` files that
were generated in Step 5.

--- 

**Step 5.** Initialize Heroku, add files to Git, and deploy

```
    \$ heroku create my-dash-app --buildpack https://github.com/Optomatica/heroku-buildpack-julia # change my-dash-app to a unique name    
    \$ git add . # add all files to git
    \$ git commit -m 'Initial app boilerplate'
    \$ git push heroku master # deploy code to Heroku
    \$ heroku ps:scale web=1  # run the app with one Heroku 'dyno'
```

You should be able to access your app at `https://my-dash-app.herokuapp.com` (changing my-dash-app to the name of your app).

---

**Step 6.** Update the code and redeploy

When you modify app.jl with your own code, you will need to add the changes to git and push those changes to heroku.

```
    \$ git status # view the changes
    \$ git add .  # add all the changes
    \$ git commit -m 'a description of the changes'
    \$ git push heroku master
```

If you're ready to take your apps to the next level, and deliver interactive analytics at scale, we invite you to learn more about Dash Enterprise. 
[Click here for more information](https://plotly.com/dash/?_ga=2.176345125.1075922756.1562168385-916141078.1562168385) or [get in touch](https://plotly.typeform.com/to/rkO85m?_ga=2.176345125.1075922756.1562168385-916141078.1562168385).
    "),

    html_hr(),
    dcc_markdown("[Back to the table of contents](/)")
end

end
