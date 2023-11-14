# import networkx as nx
from typing import List


def max_index_list(num: List) -> int:
    if len(num) == 1:
        return 0
    max_index = max_index_list(num[1:]) + 1
    return 0 if num[0] > num[max_index] else max_index


def knight_tour(L, x):
    pass


def binary_search_rec(L, x):
    pass


def jump_search(L, x):
    pass


def bucket_sort(L):
    pass


def min_list(num: List, index1: int, index2: int) -> int:
    # if (index1 < 0) and (index1 > index2):
    #     return ('Check the first index you entered')
    # elif (index2 > len(num) - 1):
    #     return ('Check the second index you entered')
    if index1 == index2:
        return num[index1]
    return min(num[index1], min_list(num, index1 + 1, index2))


def mybit(number: int, result: str = ''):
    if number == 0:
        print(result)
        return
    mybit(number - 1, result + '0')
    mybit(number - 1, result + '1')


def _count_different_element(L, elements):
    if len(L) == 0:
        return elements

    elements = _count_different_element(L[1:], elements)

    if isinstance(L[0], list):
        elements = _count_different_element(L[0], elements)
    else:
        elements[L[0]] = None

    return elements


def count_different_elements(L):
    return len(_count_different_element(L, dict()))


# if __name__ == '__main__':

# G = nx.Graph()

# Bucket Sort
# Binary search
# Jump search
