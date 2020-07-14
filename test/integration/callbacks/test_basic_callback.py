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
        "#output", "initial value", timeout=3
    )
    input_ = dashjl.find_element("#input")
    dashjl.clear_input(input_)
    input_.send_keys("hello world")

    dashjl.wait_for_text_to_equal(
        "#output", "hello world", timeout=3
    )

def test_jlcbsc002_callbacks_generating_children(dashjl):
    fp = jl_test_file_path("jlcbsc002_callbacks_generating_children.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=3
    ) 

    dashjl.wait_for_text_to_equal(
        "#sub-output-1", "sub input initial value", timeout=3
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
        "#sub-output-1", pad_input.attrs["value"] + "deadbeef", timeout=3
    )


def test_jlcbsc003_callback_with_unloaded_async_component(dashjl):
    fp = jl_test_file_path("jlcbsc003_callback_with_unloaded_async_component.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal("#output", "Hello", timeout=3)
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

    dashjl.wait_for_text_to_equal("#out", "init", timeout=3)
    for text in outputs:
        dashjl.find_element("#btn").click()
        dashjl.wait_for_text_to_equal("#out", text, timeout=3)

def test_jlcbsc006_multiple_outputs(dashjl):
    fp = jl_test_file_path("jlcbsc006_multiple_outputs.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=2
    ) 

    dashjl.wait_for_text_to_equal(
        "#output1", "initial value first", timeout=3
    )
    dashjl.wait_for_text_to_equal(
        "#output2", "initial value second", timeout=3
    )
    input_ = dashjl.find_element("#input")
    dashjl.clear_input(input_)
    input_.send_keys("hello world")

    dashjl.wait_for_text_to_equal(
        "#output1", "hello world first", timeout=3
    )

    dashjl.wait_for_text_to_equal(
        "#output2", "hello world second", timeout=3
    )

def test_jlcbsc007_prevent_update(dashjl):
    fp = jl_test_file_path("jlcbsc007_prevent_update.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=2
    ) 
    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[0].click()

    dashjl.wait_for_text_to_equal(
        "#output", "regular", timeout=3
    )
    dashjl.wait_for_text_to_equal(
        "#regular_output", "regular", timeout=3
    )

    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[1].click()

    dashjl.wait_for_text_to_equal(
        "#regular_output", "prevent", timeout=3
    )
    dashjl.wait_for_text_to_equal(
        "#output", "regular", timeout=3
    )

    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[2].click()

    dashjl.wait_for_text_to_equal(
        "#regular_output", "no_update", timeout=3
    )
    dashjl.wait_for_text_to_equal(
        "#output", "regular", timeout=3
    )

def test_jlcbsc008_prevent_update(dashjl):
    fp = jl_test_file_path("jlcbsc008_prevent_update_multiple.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=2
    ) 
    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[0].click() #regular

    dashjl.wait_for_text_to_equal(
        "#regular_output", "regular", timeout=3
    )

    dashjl.wait_for_text_to_equal(
        "#output1", "regular", timeout=3
    )
    dashjl.wait_for_text_to_equal(
        "#output2", "regular", timeout=3
    )

    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[1].click() #PreventUpdate

    dashjl.wait_for_text_to_equal(
        "#regular_output", "prevent", timeout=3
    )

    dashjl.wait_for_text_to_equal(
        "#output1", "regular", timeout=2
    )
    dashjl.wait_for_text_to_equal(
        "#output2", "regular", timeout=2
    )

    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[2].click() #no_update1

    dashjl.wait_for_text_to_equal(
        "#regular_output", "no_update1", timeout=2
    )

    dashjl.wait_for_text_to_equal(
        "#output1", "regular", timeout=2
    )
    dashjl.wait_for_text_to_equal(
        "#output2", "no_update1", timeout=2
    )

    dashjl.find_element("#input").click()
    dashjl.find_elements("div.VirtualizedSelectOption")[3].click() #no_update2

    dashjl.wait_for_text_to_equal(
        "#regular_output", "no_update2", timeout=3
    )

    dashjl.wait_for_text_to_equal(
        "#output1", "no_update2", timeout=2
    )
    dashjl.wait_for_text_to_equal(
        "#output2", "no_update1", timeout=2
    )

def test_jlcbsc009_single_element_array_output(dashjl):
    fp = jl_test_file_path("jlcbsc009_single_element_array_output.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_element_by_css_selector(
        "#input", timeout=3
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