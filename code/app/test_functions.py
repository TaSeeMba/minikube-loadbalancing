

from app import functions

def test_result_function():
    assert functions.multiple(3) == 9
    # assert functions.multiple('8') == 64
    # assert functions.multiple('Hello') == 'Provide good inputs'