import pathlib
import os.path
import itertools
import logging
import time
import json
logger = logging.getLogger(__name__)
curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_dash_assets", filename)


def test_jldada001_assets(dashjl):
    fp = jl_test_file_path("jldada001_assets.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_element("body", timeout=4)

    assert (
        dashjl.find_element("body").value_of_css_property("margin") == "0px"
    ), "margin is overloaded by assets css resource"

    assert (
        dashjl.find_element("#content").value_of_css_property("padding") == "8px"
    ), "padding is overloaded by assets"

    tested = json.loads(dashjl.wait_for_element("#tested").text)

    order = [
        u"load_first",
        u"load_after",
        u"load_after1",
        u"load_after10",
        u"load_after11",
        u"load_after2",
        u"load_after3",
        u"load_after4",
    ]

    assert order == tested, "the content and order is expected"

def test_jldada002_external_files_init(dashjl):
    fp = jl_test_file_path("jldada002_external_files_init.jl")
    js_files = [
        "https://www.google-analytics.com/analytics.js",
        {"src": "https://cdn.polyfill.io/v2/polyfill.min.js"},
        {
            "src": "https://cdnjs.cloudflare.com/ajax/libs/ramda/0.26.1/ramda.min.js",
            "integrity": "sha256-43x9r7YRdZpZqTjDT5E0Vfrxn1ajIZLyYWtfAXsargA=",
            "crossorigin": "anonymous",
        },
        {
            "src": "https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.11/lodash.min.js",
            "integrity": "sha256-7/yoZS3548fXSRXqc/xYzjsmuW3sFKzuvOCHd06Pmps=",
            "crossorigin": "anonymous",
        },
    ]

    css_files = [
        "https://codepen.io/chriddyp/pen/bWLwgP.css",
        {
            "href": "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css",
            "rel": "stylesheet",
            "integrity": "sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO",
            "crossorigin": "anonymous",
        },
    ]

    dashjl.start_server(fp)
    dashjl.wait_for_element("body", timeout=4)

    js_urls = [x["src"] if isinstance(x, dict) else x for x in js_files]
    css_urls = [x["href"] if isinstance(x, dict) else x for x in css_files]

    for fmt, url in itertools.chain(
        (("//script[@src='{}']", x) for x in js_urls),
        (("//link[@href='{}']", x) for x in css_urls),
    ):
        dashjl.driver.find_element_by_xpath(fmt.format(url))

    assert (
        dashjl.find_element("#btn").value_of_css_property("height") == "18px"
    ), "Ensure the button style was overloaded by reset (set to 38px in codepen)"

    #ensure ramda was loaded before the assets so they can use it.
    assert dashjl.find_element("#ramda-test").text == "Hello World"