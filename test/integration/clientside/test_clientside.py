import pathlib
import os.path
import logging
import dash.testing.wait as wait
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_clientside", filename)

def test_jlclsd001_simple_clientside_serverside_callback(dashjl):
    fp = jl_test_file_path("jlclsd001_simple_clientside_serverside_callback.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#output-serverside", 'Server says "nothing"', timeout=3)
    dashjl.wait_for_text_to_equal("#output-clientside", 'Client says "undefined"', timeout=2)

    dashjl.find_element("#input").send_keys("hello world")
    dashjl.wait_for_text_to_equal("#output-serverside", 'Server says "hello world"', timeout=2)
    dashjl.wait_for_text_to_equal("#output-clientside", 'Client says "hello world"', timeout=2)

def test_jlclsd002_chained_serverside_clientside_callbacks(dashjl):
    fp = jl_test_file_path("jlclsd002_chained_serverside_clientside_callbacks.jl") 
    dashjl.start_server(fp)

    test_cases = [
        ["#x", "3"],
        ["#y", "6"],
        ["#x-plus-y", "9"],
        ["#x-plus-y-div-2", "4.5"],
        ["#display-all-of-the-values", "3\n6\n9\n4.5"],
        ["#mean-of-all-values", str((3 + 6 + 9 + 4.5) / 4.0)],
    ]
    for selector, expected in test_cases:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=3)

    x_input = dashjl.wait_for_element_by_css_selector("#x", timeout=2)
    x_input.send_keys("1")

    test_cases = [
        ["#x", "31"],
        ["#y", "6"],
        ["#x-plus-y", "37"],
        ["#x-plus-y-div-2", "18.5"],
        ["#display-all-of-the-values", "31\n6\n37\n18.5"],
        ["#mean-of-all-values", str((31 + 6 + 37 + 18.5) / 4.0)],
    ]
    for selector, expected in test_cases:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=2)

def test_jlclsd003_clientside_exceptions_halt_subsequent_updates(dashjl):
    fp = jl_test_file_path("jlclsd003_clientside_exceptions_halt_subsequent_updates.jl") 
    dashjl.start_server(fp)

    test_cases = [["#first", "1"], ["#second", "2"], ["#third", "3"]]
    for selector, expected in test_cases:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=3)

    first_input = dashjl.wait_for_element("#first")
    first_input.send_keys("1")
    # clientside code will prevent the update from occurring
    test_cases = [["#first", "11"], ["#second", "2"], ["#third", "3"]]
    for selector, expected in test_cases:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=2)

    first_input.send_keys("1")

    # the previous clientside code error should not be fatal:
    # subsequent updates should still be able to occur
    test_cases = [["#first", "111"], ["#second", "112"], ["#third", "113"]]
    for selector, expected in test_cases:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=2)

def test_jlclsd004_clientside_multiple_outputs(dashjl):
    fp = jl_test_file_path("jlclsd004_clientside_multiple_outputs.jl") 
    dashjl.start_server(fp)

    for selector, expected in [
        ["#input", "1"],
        ["#output-1", "2"],
        ["#output-2", "3"],
        ["#output-3", "4"],
        ["#output-4", "5"],
    ]:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=2)

    dashjl.wait_for_element("#input").send_keys("1")

    for selector, expected in [
        ["#input", "11"],
        ["#output-1", "12"],
        ["#output-2", "13"],
        ["#output-3", "14"],
        ["#output-4", "15"],
    ]:
        dashjl.wait_for_text_to_equal(selector, expected, timeout=2)

def test_jlclsd005_clientside_fails_when_returning_a_promise(dashjl):
    fp = jl_test_file_path("jlclsd005_clientside_fails_when_returning_a_promise.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#input", "hello", timeout=2)
    dashjl.wait_for_text_to_equal("#side-effect", "side effect")
    dashjl.wait_for_text_to_equal("#output", "output")

def test_jlclsd006_PreventUpdate(dashjl):
    fp = jl_test_file_path("jlclsd006_PreventUpdate.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#first", "1", timeout=2)
    dashjl.wait_for_text_to_equal("#second", "2")
    dashjl.wait_for_text_to_equal("#third", "2")

    dashjl.find_element("#first").send_keys("1")

    dashjl.wait_for_text_to_equal("#first", "11")
    dashjl.wait_for_text_to_equal("#second", "2")
    dashjl.wait_for_text_to_equal("#third", "2")

    dashjl.find_element("#first").send_keys("1")

    dashjl.wait_for_text_to_equal("#first", "111")
    dashjl.wait_for_text_to_equal("#second", "3")
    dashjl.wait_for_text_to_equal("#third", "3")

def test_jlclsd007_no_update(dashjl):
    fp = jl_test_file_path("jlclsd007_no_update.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal("#first", "1")
    dashjl.wait_for_text_to_equal("#second", "2")
    dashjl.wait_for_text_to_equal("#third", "2")

    dashjl.find_element("#first").send_keys("1")

    dashjl.wait_for_text_to_equal("#first", "11")
    dashjl.wait_for_text_to_equal("#second", "2")
    dashjl.wait_for_text_to_equal("#third", "3")

    dashjl.find_element("#first").send_keys("1")

    dashjl.wait_for_text_to_equal("#first", "111")
    dashjl.wait_for_text_to_equal("#second", "3")
    dashjl.wait_for_text_to_equal("#third", "4")

def test_jlclsd008_clientside_inline_source(dashjl):
    fp = jl_test_file_path("jlclsd008_clientside_inline_source.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#output-serverside", 'Server says "nothing"', timeout=3)
    dashjl.wait_for_text_to_equal("#output-clientside", 'Client says "undefined"')

    dashjl.find_element("#input").send_keys("hello world")
    dashjl.wait_for_text_to_equal("#output-serverside", 'Server says "hello world"', timeout=2)
    dashjl.wait_for_text_to_equal("#output-clientside", 'Client says "hello world"')