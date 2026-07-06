from niow.core import Niow


def test_greet():
    t = Niow("tester")
    assert "tester" in t.greet()
