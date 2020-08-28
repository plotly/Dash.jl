import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_props_check", filename)

test_cases = {
    "not-boolean": {
        "fail": True,
        "name": 'simple "not a boolean" check',
    },
    "missing-required-nested-prop": {
        "fail": True,
        "name": 'missing required "value" inside options',
    },
    "invalid-nested-prop": {
        "fail": True,
        "name": "invalid nested prop",
    },
    "invalid-arrayOf": {
        "fail": True,
        "name": "invalid arrayOf",
    },
    "invalid-oneOf": {
        "fail": True,
        "name": "invalid oneOf",
    },
    "invalid-oneOfType": {
        "fail": True,
        "name": "invalid oneOfType",
    },
    "invalid-shape-5": {
        "fail": True,
        "name": "invalid not required key",
    },
    "string-not-list": {
        "fail": True,
        "name": "string-not-a-list",
    },
    "no-properties": {
        "fail": False,
        "name": "no properties",
    },
    "nested-children": {
        "fail": True,
        "name": "nested children",
    },
    "deeply-nested-children": {
        "fail": True,
        "name": "deeply nested children",
    },
    "dict": {
        "fail": True,
        "name": "returning a dictionary",
    },
    "allow-null-2": {
        "fail": False,
        "name": "allow null as value",
    },
    "allow-null-3": {
        "fail": False,
        "name": "allow null in properties",
    },
    "allow-null-4": {
        "fail": False,
        "name": "allow null in oneOfType",
    },
    "long-property-string": {
        "fail": True,
        "name": "long property string with id",
    },
    "multiple-wrong-values": {
        "fail": True,
        "name": "multiple wrong props",
    },
    "boolean-html-properties": {
        "fail": True,
        "name": "dont allow booleans for dom props",
    },
    "allow-exact-with-optional-and-required-1": {
        "fail": False,
        "name": "allow exact with optional and required keys",
    },
    "allow-exact-with-optional-and-required-2": {
        "fail": False,
        "name": "allow exact with optional and required keys 2",
    },
}

def test_jldvpc001_prop_check_errors_with_path(dashjl):
    fp = jl_test_file_path("jldvpc001_prop_check_errors_with_path.jl")
    dashjl.start_server(fp)
    for tc in test_cases:
        route_url = "{}/{}".format(dashjl.server_url, tc)
        dashjl.wait_for_page(url=route_url)

        if test_cases[tc]["fail"]:
            dashjl.wait_for_element(".test-devtools-error-toggle", timeout=4).click()
            dashjl.wait_for_element(".dash-error-card")
        else:
            dashjl.wait_for_element("#new-component", timeout=2)