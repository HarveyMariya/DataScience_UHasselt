# import numpy as np
# from pytest import mark
# from typing import List, Union
# from exercises4 import (
#     max_index_list,
#     min_list,
#     count_different_elements,
#     mybit,
#     knight_tour,
#     binary_search_rec,
#     jump_search,
#     bucket_sort,
# )


# @mark.parametrize(
#     "given,expected",
#     [
#         ([4, 3, 2, 1, 5, 6, 7, 1, 2], 6),
#         ([1, 2, 3, 4], 3),
#         ([4, 3, 2, 1], 0),
#         ([1, 2, 3, 2, 1], 2),
#     ],
# )
# def test_max_index_list(given: List[int], expected: int) -> None:
#     assert max_index_list(given) == expected


# @mark.parametrize(
#     "given,a,b,expected",
#     [
#         ([4, 3, 2, 1, 5, 6, 7, 1, 2], 0, 8, 1),
#         ([1, 2, 3, 4], 1, 3, 2),
#         ([4, 3, 2, 1], 1, 1, 3),
#         ([1, 2, 3, 2, 1], 1, 3, 2),
#     ],
# )
# def test_min_list(given: List[int], a: int, b: int, expected: int) -> None:
#     assert min_list(given, a, b) == expected


# @mark.parametrize(
#     "given,expected",
#     [
#         ([[[[2, 3], 3], [], 3]], 2),
#         (["a", 2, "a", 4], 3),
#         ([[], [[], []], 3, 4], 2),
#         ([["abba"], [[], [1.5]], 3, 1.5], 3),
#     ],
# )
# def test_count_different_elements(
#     given: List[Union[List, int, float, str]], expected: int
# ) -> None:
#     assert count_different_elements(given) == expected


# @mark.parametrize(
#     "given,expected",
#     [
#         (0, "\n"),
#         (1, "0\n1\n"),
#         (2, "00\n01\n10\n11\n"),
#         (
#             4,
#             "0000\n0001\n0010\n0011\n0100\n0101\n0110\n0111\n"
#             "1000\n1001\n1010\n1011\n1100\n1101\n1110\n1111\n",
#         ),
#     ],
# )
# def test_mybit(capsys, given: int, expected: str) -> None:
#     # capsys is a tool from pytest to capture content printed to stdout
#     mybit(given)
#     captured = capsys.readouterr()
#     assert captured.out == expected


# def test_knight_tour() -> None:
#     board = np.array(knight_tour())

#     # make sure that all values from 0 to 24 exist
#     assert np.array_equal(np.unique(board), np.arange(0, 25))

#     # make sure that each move is a valid L move
#     current = 0
#     current_x, current_y = np.where(board == current)
#     while current < board.size - 1:
#         current = current + 1
#         next_x, next_y = np.where(board == current)
#         assert ((current_x[0] - next_x[0]) ** 2) + (
#             (current_y[0] - next_y[0]) ** 2
#         ) == 5
#         current_x, current_y = next_x, next_y


# searching_tests = mark.parametrize(
#     "lst, x, expected",
#     [
#         ([], 2, -1),
#         ([2], 2, 0),
#         ([1, 2, 5, 7, 9, 12, 15, 17], 12, 5),
#         ([1, 2, 5, 7, 9, 12, 15, 17], 3, -1),
#         ([1, 2, 5, 7, 9, 12, 15, 17], 20, -1),
#         ([1, 2, 5, 7, 9, 12, 15, 17], 1, 0),
#         ([1, 2, 5, 7, 9, 12, 15, 17], 17, 7),
#     ],
# )


# @searching_tests
# def test_binary_search_rec(lst: List[int], x: int, expected: int) -> None:
#     assert binary_search_rec(lst, x) == expected


# @searching_tests
# def test_jump_search(lst: List[int], x: int, expected: int) -> None:
#     assert jump_search(lst, x) == expected


# @mark.parametrize(
#     "lst", [[22, 4, 7, 100], [5000, 4], [
#         5, 2, 1, 80, 56, 87, 4, 3, 1000, 2, 100, 10]]
# )
# def test_bucket_sort(lst: List[int]) -> None:
#     assert bucket_sort(lst) == sorted(lst)
