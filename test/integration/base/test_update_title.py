import os
import pathlib

curr_path = pathlib.Path(__file__).parent.absolute()


def boot(dashjl, filename):
    fp = os.path.join(curr_path, "jl_update_title", filename)
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal(
        "#hello-div",
        "Hello world!"
    )


def get_update_title_state(dashjl):
    return dashjl.driver.execute_script(
        "return store.getState().config.update_title"
    )


def test_jltut001_update_title(dashjl):
    boot(dashjl, "jltut001_update_title.jl")
    assert get_update_title_state(dashjl) == "Updating..."


def test_jltut002_update_title(dashjl):
    boot(dashjl, "jltut002_update_title.jl")
    assert get_update_title_state(dashjl) == "... computing !"


def test_jltut003_update_title(dashjl):
    boot(dashjl, "jltut003_update_title.jl")
    assert get_update_title_state(dashjl) == ""
