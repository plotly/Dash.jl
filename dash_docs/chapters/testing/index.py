import dash_html_components as html
import dash_core_components as dcc
from dash_docs import reusable_components as rc
from dash_docs import tools

layout = html.Div([
    rc.Markdown(u"""
    # Dash Testing

    *New in Dash v1.0*

    *support Dash for R testing added in v1.1.0*

    `dash.testing` \U0001f9ea provides some off-the-rack
    `pytest` [fixtures](https://docs.pytest.org/en/latest/fixture.html)
    and a minimal set of testing **APIs** with our internal crafted
    best practices at the integration level.

    This tutorial does not intend to cover the usage of
    [pytest](https://docs.pytest.org/en/latest/) and
    [Selenium WebDriver](https://www.seleniumhq.org/projects/webdriver/),
    but focuses on how to do a simple integration test with Dash by hosting
    the App server locally and using a Selenium WebDriver to simulate
    the interaction inside a web browser.

    """),

    html.Img(
        alt='demo',
        src=tools.relpath('assets/images/gallery/dash-testing.gif')
    ),

    rc.Markdown("""

    ## Install

    The Dash testing is now part of the main Dash package. After
    `pip install dash[testing]`, the Dash `pytest` fixtures are available, you
    just need to install the WebDrivers or use a remote Selenium-Grid and you
    are ready to test.

    - [Chrome Driver](http://chromedriver.chromium.org/getting-started)
    - [Firefox Gecko Driver](https://github.com/mozilla/geckodriver/releases)

    FYI, We run Dash integration tests with Chrome WebDriver.
    But the fixture allows you to choose another browser from the command line,
    e.g. `pytest --webdriver Firefox -k bsly001`.

    Headless mode is added in Dash *1.0.1*, run `pytest --headless -k bsly001`
    to start test in headless mode. First time hearing about `headless mode`? The
    main benefit for us is it's lighter and faster to run without a UI. You
    can check the details from both [Firefox](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Headless_mode)
    and [Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome).

    Remote WebDriver support is added in Dash *1.3.0*. There are two ways to use it:

    1. Run `pytest --remote -k bsly001` to grab a Chrome WebDriver from a local
    hosted grid at `http://localhost:4444/wd/hub`
    2. Run `pytest --webdriver Firefox --remote-url https://grid_provioder_endpoints`
    to connect with a remote grid in the cloud running Firefox (default Chrome).
    Note that you don't need to use `--remote` as soon as the `--remote-url`
    value is set and different than the default one.

    ### Caveats

    It's important to note that we cannot fully test and guarantee that the
    above cases will work with any given selenium grid you have. The limitation
    might come from how the network is set up, the limitation of different
    hosting OS or how docker-compose was configured.

    You might need to do some auxiliary WebDriver Options tuning to run the
    tests in a particular Selenium-Grid. The first useful tip is to change the
    default logging level with `--log-cli-level DEBUG`. Secondly, there is a
    back door for browser option customization by a `pytest_setup_options` hook
    defined in `plugin.py`.

    The example below is to use the `headless` mode with Chrome WebDriver in
    Windows, there is a [workaround](https://bugs.chromium.org/p/chromium/issues/detail?id=737678)
    by adding `--disable-gpu` in the options.

    ```Python
    # add this in the conftest.py under tests folder
    from selenium.webdriver.chrome.options import Options

    def pytest_setup_options():
        options = Options()
        options.add_argument('--disable-gpu')
        return options
    ```

    **Notes**:

    * The *Gecko(Marionette)* driver from Mozilla is not fully compatible with
    Selenium specifications. Some features may not work as expected.

    * We only include *Chrome* and *Firefox* in the supported list for now,
    but other popular webdrivers may be included based on popular demand.

    ## Example

    ```python
    # 1. imports of your dash app
    import dash
    import dash_html_components as html


    # 2. give each testcase a tcid, and pass the fixture
    # as a function argument, less boilerplate
    def test_bsly001_falsy_child(dash_duo):

        # 3. define your app inside the test function
        app = dash.Dash(__name__)
        app.layout = html.Div(id="nully-wrapper", children=0)

        # 4. host the app locally in a thread, all dash server configs could be
        # passed after the first app argument
        dash_duo.start_server(app)

        # 5. use wait_for_* if your target element is the result of a callback,
        # keep in mind even the initial rendering can trigger callbacks
        dash_duo.wait_for_text_to_equal("#nully-wrapper", "0", timeout=4)

        # 6. use this form if its present is expected at the action point
        assert dash_duo.find_element("#nully-wrapper").text == "0"

        # 7. to make the checkpoint more readable, you can describe the
        # acceptance criterion as an assert message after the comma.
        assert dash_duo.get_logs() == [], "browser console should contain no error"

        # 8. visual testing with percy snapshot
        dash_duo.percy_snapshot("bsly001-layout")
    ```

    Notes

    1. For most test scenarios, you don't need to import any modules for
    the test; just import what you need for the Dash app itself.

    2. A test case is a regular Python function. The function name follows
    this pattern: `test_{tcid}_{test title}`. The `tcid` (test case ID) is
    an abbreviation pattern of `mmffddd => module + file + three digits`.
    The `tcid` facilitates the test selection by just running
    `pytest -k {tcid}`. Its naming convention also helps code navigation with
    modern editors.

    3. Here we just define our app inside a test function. All the rules
    still apply as in your app file.

    4. We normally start the test by calling the `start_server` API
    from `dash_duo` (you can use `dash_br` for an hosted Dash App, and
    write `dash_br.server_url = "Hosted URL"` to start). Several actions
    implicitly happen under the hood:

       1. The defined app is hosted inside a light Python `threading.Thread`.
       2. A Selenium WebDriver is initialized and navigates to the
       local server URL using `server_url`.
       3. We first wait until the Flask server is responsive to an HTTP
       request; and then make sure the Dash app is full rendered inside
       the browser.

    5. A test case is composed of preparation, actions, and checkpoints.
    Both #5 and #6 are doing the same check in this example; we are expecting
    that the defined `Div` component's text is identical to `children`. #5 will
    wait for the expected state to be reached within a 4 seconds timeout. It's
    a safer way to write the action steps when you are doing an element check
    related to callbacks, as it normally happens under Dash context:
    the element is already present in the DOM, but not necessarily the props.

    6. The `find_element` API call has an implicitly global timeout of two
    seconds set at the driver level, i.e. the driver waits at most two seconds
    to find the element by the locator, **HOWEVER** it will compare the text
    as soon as the driver returns an element. Also note that the API
    `find_element('#nully-wrapper')` is just a shortcut to a more tedious
    version `driver.find_element_by_css_selector('#nully-wrapper')`.

    7. Unlike `unittest`, `pytest` allows using the standard Python
    [`assert`](https://docs.pytest.org/en/latest/assert.html) for verifying
    expectations and values. It also puts more introspection information into
    the assertion failure message by overriding the `assert` behavior. It's
    good practice to expose your *acceptance criteria* directly in the test
    case rather than wrapping the `assert` inside another helper API, also to
    write these messages with SHOULD/SHOULD NOT without failure confusion.
    By looking at the test name, the app definition, the actions, and the
    checkpoints, reviewers should figure out easily the purpose of the test.

    8. We use [Percy](https://percy.io/) as our Visual Regression Testing
    tool. It's a good alternative to assertions when your checkpoint is
    about the graphical aspects of a Dash App, such as the whole layout or a
    `dcc.Graph` component. We integrate the Percy service with a `PERCY_TOKEN`
    variable, so the regression result is only available in Plotly's CircleCI
    setup.

    ## Dash for R testing

    We released [Dash for R](https://medium.com/@plotlygraphs/announcing-dash-for-r-82dce99bae13)
    in July 2019.  To facilitate testing it, we extended the *Python* package
    `dash.testing` to support Dash for R apps.

    The new `dashr` fixture gives us a test development experience in
    Dash for R that's nearly identical to the `dash_duo` fixture in
    Dash for Python. In this context, a `dashr` fixture is an instance of
    Python class which provides a reliable framework to execute the app and test
    one or more of its features via Selenium WebDriver. For more details,
    please visit [pytest documentation](https://docs.pytest.org/en/latest/fixture.html).

    Here is a simple example runnable with `pytest`. Your Dash App is written
    as a string inside the Python test code (the `app` argument can also be a
    valid path to a `.R` file), the app is then executed by `Rscript` within
    a Python `subprocess` and we can use the same set of API calls to
    test it exactly as we do Dash testing in Python Apps.

    ```python

    # the app is a raw string variable defining the Dash App in R
    app = '''

    library(dash)
    library(dashHtmlComponents)
    app <- Dash$new()
    app$layout(htmlDiv(list(htmlDiv(id='container',children='Hello Dash for R testing'))))
    app$run_server()
    '''

    # a test case is a simple Python function with the same prefix convention
    # dashr is the default fixture combines the API for serving the app
    # and selenium tests.
    def test_rstr001_r_with_string(dashr):

        # Since the app is the string chunk we defined above, the dashr
        # fixture creates an unique temporary folder to dump the content into
        # `app.R` and copies any possible subfolders (usually
        # assets or clientside source code) to the same temporary folder

        # start_server by default uses the temporary folder as current working
        # folder You can change this with `start_server(app, cwd='/my/cwd/')`
        dashr.start_server(app)

        assert dashr.find_element("#container").text == "Hello Dash for R Testing"


    def test_rstr002_r_with_file_path(dashr):

        # Alternatively, the app can be a path to a separate file containing your Dash for R app
        # the `os.path.dirname(__file__)` is an useful Python trick to get the path
        # of the currently running script, so it will always work no matter where you start the
        # test runner.
        dashr.start_server(
            app=os.path.join(os.path.dirname(__file__), "assets/demo_hello.R))

        assert dashr.find_element("#container").text == "Hello Dash for R Testing"
    ```

    ## Fixtures

    To avoid accidental name collision with other pytest plugins, all Dash test
    fixtures start with the prefix `dash` or `dashr`.

    - dash_br

    A standalone WebDriver wrapped with high-level Dash testing APIs. This is
    suitable for testing a Dash App in a deployed environment (Dash for Python
    or R), i.e. when your Dash App is accessible from a URL.

    - dash_duo

    The default fixture for Dash Python integration tests, it contains a
    `thread_server` and a WebDriver wrapped with high-level Dash testing APIs.

    - dash_thread_server

    Start your Dash App locally in a Python `threading.Thread`, which is
    lighter and faster than a process.

    - dash_process_server

    This is close to your production/deployed environment. Start your Dash App
    with `waitress`(by default if `raw_command` is not provided) in a Python
    `subprocess`. You can control the process runner with two supplemental
    arguments. To run the application with alternative deployment options, use
    the `raw_command` argument; to extend the timeout if your application needs
    more than the default three seconds to launch, use the `start_timeout`
    argument. Note: *You need to configure your `PYTHONPATH` so that the Dash
    app source file is directly importable*.

    And `Dash for R` test fixtures have a prefix `dashr`.

    - dashr

    The default fixture for Dash for R integration tests. As `dash_duo` in Python,
    it contains a `dashr_server` and a Selenium WebDriver with the same Dash
    testing APIs.

    - dashr_server

    Start your Dash for R App with `Rscript` in a python `subprocess`. Note that
    unlike python server fixtures, the start server arguments can only be
    configured inside the Dash for R App.

    ## APIs

    ### Selenium Overview

    Both `dash_duo` and `dash_br` expose the Selenium WebDriver via the
    property `driver`, e.g. `dash_duo.driver`, which gives you full access to
    the [Python Selenium API](https://selenium-python.readthedocs.io/api.html).
    (*Note that this is not the official Selenium documentation site, but has
    somehow become the defacto Python community reference*)

    One of the core components of selenium testing is finding the
    **web element** with a `locator`, and performing some actions like `click`
    or `send_keys` on it, and waiting to verify if the expected state is met
    after those actions. The check is considered as an acceptance criterion,
    for which you can write in a standard Python `assert` statement.

    #### Element Locators

    There are several strategies to
    [locate elements](https://selenium-python.readthedocs.io/locating-elements.html#locating-elements);
    CSS selector and XPATH are the two most versatile ways. We recommend using
    the **CSS Selector** in most cases due to its
    [better performance and robustness](http://elementalselenium.com/tips/34-xpath-vs-css-revisited-2) across browsers.

    If you are new to using CSS Selectors, these
    [SauceLab tips](https://saucelabs.com/resources/articles/selenium-tips-css-selectors)
    are a great start. Also, remember that
    [Chrome Dev Tools Console](https://developers.google.com/web/tools/chrome-devtools/console/utilities)
    is always your good friend and playground.

    """),

    html.Img(
        alt='Dev Tools',
        src=tools.relpath('assets/images/gallery/dash-testing-dev-tools.png')
    ),

    rc.Markdown("""

    #### Waits

    [This link](https://selenium-python.readthedocs.io/waits.html) covers
    this topic nicely. For impatient readers, a quick take away is
    quoted as follows:

    The Selenium WebDriver provides two types of waits:

    - **explicit wait**
        Makes WebDriver wait for a certain condition to occur before
        proceeding further with execution. All our APIs with `wait_for_*`
        falls into this category.
    - **implicit wait**
        Makes WebDriver poll the DOM for a certain amount of time when trying
        to locate an element. We set a global two-second timeout at the
        `driver` level.

    **Note** *all custom wait conditions are defined in `dash.testing.wait`
    and there are two extra APIs `until` and `until_not` which are similar to
    the explicit wait with WebDriver, but they are not binding to
    WebDriver context, i.e. they abstract a more generic mechanism to
    poll and wait for certain condition to happen*

    ### Browser APIs

    This section lists a minimal set of browser testing APIs. They are
    convenient shortcuts to Selenium APIs and have been approved in
    our daily integration tests.

    The following table might grow as we start migrating more legacy tests in
    the near future. But we have no intention to build a comprehensive list,
    the goal is to make writing Dash tests concise and error-free.
    Please feel free to submit a community PR to add any missing ingredient,
    we would be happy to accept that if it's adequate for Dash testing.

    | API | Description |
    | --- | ----------- |
    | `find_element(selector)` | return the first found element by the `CSS selector`, shortcut to `driver.find_element_by_css_selector`. *note that this API will raise exceptions if not found, the `find_elements` API returns an empty list instead* |
    | `find_elements(selector)` | return a list of all elements matching by the `CSS selector`, shortcut to `driver.find_elements_by_css_selector`|
    | `multiple_click(selector, clicks)`| find the element with the `CSS selector` and clicks it with number of `clicks` |
    | `wait_for_element(selector, timeout=None)` | shortcut to `wait_for_element_by_css_selector` the long version is kept for back compatibility. `timeout` if not set, equals to the fixture's `wait_timeout`|
    | `wait_for_element_by_css_selector(selector, timeout=None)` | explicit wait until the element is present, shortcut to `WebDriverWait` with `EC.presence_of_element_located` |
    | `wait_for_element_by_id(element_id, timeout=None)` | explicit wait until the element is present, shortcut to `WebDriverWait` with `EC.presence_of_element_located` |
    | `wait_for_style_to_equal(selector, style, value, timeout=None)` | explicit wait until the element's style has expected `value`. shortcut to `WebDriverWait` with custom wait condition `style_to_equal`. `timeout` if not set, equals to the fixture's `wait_timeout`  |
    | `wait_for_text_to_equal(selector, text, timeout=None)` | explicit wait until the element's text equals the expected `text`. shortcut to `WebDriverWait` with custom wait condition `text_to_equal`. `timeout` if not set, equals to the fixture's `wait_timeout` |
    | `wait_for_contains_text(selector, text, timeout=None)` | explicit wait until the element's text contains the expected `text`. shortcut to `WebDriverWait` with custom wait condition `contains_text` condition. `timeout` if not set, equals to the fixture's `wait_timeout` |
    | `wait_for_page(url=None, timeout=10)` | navigate to the `url` in webdriver and wait until the dash renderer is loaded in browser. use `server_url` if `url` is None |
    | `toggle_window()` | switch between the current working window and the newly opened one. |
    | `switch_window(idx)` | switch to window by window index. shortcut to `driver.switch_to.window`. raise `BrowserError` if no second window present in browser |
    | `open_new_tab(url=None)` | open a new tab in browser with window name `new window`. `url` if not set, equals to `server_url` |
    | `percy_snapshot(name, wait_for_callbacks=False)` | visual test API shortcut to `percy_runner.snapshot`. it also combines the snapshot `name` with the actual python versions. The `wait_for_callbacks` parameter controls whether the snapshot is taken only after all callbacks have fired; the default is `False`. |
    | `visit_and_snapshot(resource_path, hook_id, wait_for_callbacks=True, assert_check=True)` | This method automates a common task during dash-docs testing: the URL described by `resource_path` is visited, and completion of page loading is assured by waiting until the element described by `hook_id` is fetched. Once `hook_id` is available, `visit_and_snapshot` acquires a snapshot of the page and returns to the main page. `wait_for_callbacks` controls if the snapshot is taken until all dash callbacks are fired, default True. `assert_check` is a switch to enable/disable an assertion that there is no devtools error alert icon. |
    | `take_snapshot(name)` | hook method to take a snapshot while selenium test fails. the snapshot is placed under `/tmp/dash_artifacts` in Linux or `%TEMP` in windows with a filename combining test case `name` and the running selenium session id |
    | `zoom_in_graph_by_ratio(elem_or_selector, start_fraction=0.5, zoom_box_fraction=0.2, compare=True)` | zoom out a graph (provided with either a Selenium WebElement or CSS selector) with a zoom box fraction of component dimension, default start at middle with a rectangle of 1/5 of the dimension use `compare` to control if we check the SVG get changed |
    | `click_at_coord_fractions(elem_or_selector, fx, fy)` |  Use `ActionChains` to click a Selenium WebElement at a location a given fraction of the way `fx` between its left (0) and right (1) edges, and `fy` between its top (0) and bottom (1) edges. |
    | `get_logs()` | return a list of `SEVERE` level logs after last reset time stamps (default to 0, resettable by `reset_log_timestamp`. **Chrome only** |
    | `clear_input()` | simulate key press to clear the input |
    | `driver` | property exposes the Selenium WebDriver as fixture property |
    | `session_id` | property returns the selenium session_id, shortcut to `driver.session_id` |
    | `server_url` | set the server_url as setter so the selenium is aware of the local server port, it also implicitly calls `wait_for_page`. return the server_url as property |
    | `download_path` | property returns the download_path, note that dash fixtures are initialized with a temporary path from pytest `tmpdir` |

    ### Dash APIs

    This section enumerates a full list of Dash App related properties and APIs
    apart from the previous browser ones.

    | API | Description |
    | --- | ----------- |
    | `devtools_error_count_locator` | property returns the selector of the error count number in the devtool UI |
    | `dash_entry_locator` | property returns the selector of react entry point, it can be used to verify if an Dash app is loaded |
    | `dash_outerhtml_dom` | property returns the BeautifulSoup parsed Dash DOM from outerHTML |
    | `dash_innerhtml_dom` | property returns the BeautifulSoup parsed Dash DOM from innerHTML |
    | `redux_state_paths` | property returns the `window.store.getState().paths` |
    | `redux_state_rqs` | property returns `window.store.getState().requestQueue` |
    | `window_store` | property returns `window.store` |
    | `get_local_storage(store_id="local")` | get the value of local storage item by the id, default is `local` |
    | `get_session_storage(session_id="session") ` | get the value of session storage item by the id, default is `session` |
    | `clear_local_storage()` | shortcut to `window.localStorage.clear()` |
    | `clear_session_storage()` | shortcut to `window.sessionStorage.clear()` |
    | `clear_storage()` | clears both local and session storages |


    ## Debugging

    ### Verify your test environment

    If you run the integration in a virtual environment, make sure you are
    getting the latest commit in the **master** branch from each component, and
    that the installed `pip` versions are correct.

    Note: *We have some enhancement initiatives tracking in this [issue](https://github.com/plotly/dash/issues/759)*

    ### Run the CI job locally

    The [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/) is a
    handy tool to execute some jobs locally. It gives you an earlier warning
    before even pushing your commits to remote. For example, it's always
    recommended to pass lint and unit tests job first on your local machine. So
    we can make sure there are no simple mistakes in the commit.

    ```shell
    # install the cli (first time only)
    $ curl -fLSs https://circle.ci/cli | bash && circleci version

    # run at least the lint & unit test job on both python 2 and 3
    # note: the current config requires all tests pass on python 2.7, 3.6 and 3.7.
    $ circleci local execute --job lint-unit-27 && $ circleci local execute --job lint-unit-37
    ```

    ### Increase the verbosity of pytest logging level

    `pytest --log-cli-level DEBUG -k bsly001`

    You can get more logging information from Selenium WebDriver, Flask server,
    and our test APIs.

    ```bash
    14:05:41 | DEBUG | selenium.webdriver.remote.remote_connection:388 | DELETE http://127.0.0.1:53672/session/87b6f1ed3710173eff8037447e2b8f56 {"sessionId": "87b6f1ed3710173eff8037447e2b8f56"}
    14:05:41 | DEBUG | urllib3.connectionpool:393 | http://127.0.0.1:53672 "DELETE /session/87b6f1ed3710173eff8037447e2b8f56 HTTP/1.1" 200 72
    14:05:41 | DEBUG | selenium.webdriver.remote.remote_connection:440 | Finished Request
    14:05:41 | INFO | dash.testing.application_runners:80 | killing the app runner
    14:05:41 | DEBUG | urllib3.connectionpool:205 | Starting new HTTP connection (1): localhost:8050
    14:05:41 | DEBUG | urllib3.connectionpool:393 | http://localhost:8050 "GET /_stop-3ef0e64e8688436caced44e9f39d4263 HTTP/1.1" 200 29
    ```

    ### Selenium Snapshots

    If you run your tests with CircleCI dockers (locally with `CircleCI CLI`
    and/or remotely with `CircleCI`).

    Inside a docker run or VM instance where there is no direct access to the
    video card, there is a known limitation that you cannot see anything from
    the Selenium browser on your screen. Automation developers use
    [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) as
    a workaround to solve this issue. It enables you to run graphical
    applications without a display (e.g., browser tests on a CI server) while
    also having the ability to take screenshots.

    We implemented an automatic hook at the test report stage, it checks if a
    test case failed with a Selenium test fixture. Before tearing down every
    instance, it will take a snapshot at the moment where your assertion is
    `False` or having a runtime error. refer to [Browser APIs](#browser-apis)

    *Note: you can also check the snapshot directly in CircleCI web page
    under `Artifacts` Tab*

    """),

    html.Img(
        alt='CircleCI',
        src=tools.relpath('assets/images/gallery/dash-testing-ci.png')
    ),

    rc.Markdown("""

    ### Percy Snapshots

    There are two customized `pytest` arguments to tune Percy runner:

    1. `--nopercyfinalize` disables the Percy finalize in dash fixtures. This
    is required if you run your tests in parallel, then you add an extra
    `percy finalize --all` step at the end. For more details, please visit
    [Percy Documents](https://docs.percy.io/docs/parallel-test-suites).
    2. `--percy-assets` lets Percy know where to collect additional assets
    such as CSS files. You can refer to the example we used for [`dash-docs`](https://github.com/plotly/dash-docs/blob/b10701c8514b87d86645f6edeb808ccdcfa4143d/tests/conftest.py#L17-L32).
    """),
])
