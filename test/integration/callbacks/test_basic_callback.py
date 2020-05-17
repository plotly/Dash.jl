import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_basic_callback", filename)

def test_jlcbsc001_simple_callback(dashjl):
    fp = jl_test_file_path("jlcbsc001_simple_callback.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=2
    ) 

    dashjl.wait_for_text_to_equal(
        "#output", "initial value", timeout=2
    )
    input_ = dashjl.find_element("#input")
    dashjl.clear_input(input_)
    input_.send_keys("hello world")

    dashjl.wait_for_text_to_equal(
        "#output", "hello world", timeout=1
    )

def test_jlcbsc002_callbacks_generating_children(dashjl):
    fp = jl_test_file_path("jlcbsc002_callbacks_generating_children.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=2
    ) 

    dashjl.wait_for_text_to_equal(
        "#sub-output-1", "sub input initial value", timeout=2
    )

    pad_input, pad_div = dashjl.dash_innerhtml_dom.select_one(
        "#output > div"
    ).contents

    assert (
        pad_input.attrs["value"] == "sub input initial value"
        and pad_input.attrs["id"] == "sub-input-1"
    )
    assert pad_input.name == "input"

    assert (
        pad_div.text == pad_input.attrs["value"] and pad_div.get("id") == "sub-output-1"
    ), "the sub-output-1 content reflects to sub-input-1 value"

    dashjl.find_element("#sub-input-1").send_keys("deadbeef")

    dashjl.wait_for_text_to_equal(
        "#sub-output-1", pad_input.attrs["value"] + "deadbeef", timeout=2
    )


def test_jlcbsc003_callback_with_unloaded_async_component(dashjl):
    fp = jl_test_file_path("jlcbsc003_callback_with_unloaded_async_component.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal("#output", "Hello", timeout=2)
    dashjl.find_element("#btn").click()
    dashjl.wait_for_text_to_equal("#output", "Bye")


def test_jlcbsc005_children_types(dashjl):
    fp = jl_test_file_path("jlcbsc005_children_types.jl") 
    dashjl.start_server(fp)

    outputs = [
        "",
         "a string",
        "123",
        "123.45",
        "678",
        "alistofstrings",
        "strings2numbers",
        "a string\nand a div"
    ]

    dashjl.wait_for_text_to_equal("#out", "init", timeout=2)
    for text in outputs:
        dashjl.find_element("#btn").click()
        dashjl.wait_for_text_to_equal("#out", text, timeout=2)