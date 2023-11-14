"""
author: [Harvey Okotie]
studentnumber: [2262068]

"""
from typing import List


def generate_sequence(n: int) -> List:
    """
    Generate a sequence of integers which converges to 1.

    The next element of the sequence is determined by the rules below:
        1. If current element is even, the next element should be equal to
        n / 2.
        2. If current element is odd, the next element should be equal to
        3 * n + 1.

    Args:
        n: a natural number

    Returns:
        List of integers.

    Example:
    -------
        generate_sequence(7) =  [7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5,
        16, 8, 4, 2, 1]
    """

    result = []
    result.append(n)
    if n == 1:
        return result
    else:
        if n % 2 != 0:
            new_number = 3 * n + 1
        else:
            new_number = n//2

    return result + generate_sequence(new_number)


def compute_power(n: int, m: int) -> int:
    """
    Compute n power m using a recursive method and memoization.
    This reduced time complexity to O(log m). It optimizes the
    function by establishing the base case where n ** m equals 0.
    Else splitting the problem into two possible subproblems,either
    odd or even power. Indeed, with this divide and conquer approach
    the recursive call will reduce the time complexity.


    Args:
        n: An integer of base number
        m: An integer of exponent

    Returns:
        An integer.

    Example:
    -------
        compute_power(2,6) = 2**3 * 2**3 = 64
    """

    if m == 0:
        return 1
    elif m % 2 == 0:
        result = compute_power(n, int(m / 2))
        return result * result
    else:
        result = compute_power(n, m // 2)
        return n * result * result
