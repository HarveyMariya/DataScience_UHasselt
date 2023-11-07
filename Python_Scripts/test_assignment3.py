# from pytest import mark
# from typing import List
# from assignment3 import generate_sequence, compute_power


# @mark.parametrize(
#     "given, expected",
#     [
#         (7, [7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]),
#         (9, [9, 28, 14, 7, 22, 11, 34, 17, 52,
#          26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]),
#     ],
# )
# def test_generate_sequence(given: int, expected: List[int]) -> None:
#     assert generate_sequence(given) == expected


# @mark.parametrize(
#     "number, power, expected",
#     [(7, 3, 343), (2, 5, 32), (2, 6, 64),
#      (10, 5, 100000), (51, 3, 132651), (10000, 0, 1)],
# )
# def test_compute_power(number: int, power: int, expected: int) -> None:
#     assert compute_power(number, power) == expected
