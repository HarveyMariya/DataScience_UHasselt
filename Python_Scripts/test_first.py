from pytest import mark


def fun(x, y):
    return x + y


def test_fun1():
    assert fun(2, 4) == 6
    assert fun(0, 2) == 2


@mark.parametrize(
    "first, second, expected", [(2, 4, 6), (0, 2, 2), (3, 1, 4)],
)
def test_fun2(first, second, expected):
    assert fun(first, second) == expected
