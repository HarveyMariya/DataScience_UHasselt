# from assignment2 import Stack, InfixExpression
# from pytest import mark, raises


# def test_stack() -> None:
#     stack = Stack()
#     assert stack.empty()
#     stack.push("a")
#     stack.push("b")
#     stack.push("c")
#     assert not stack.empty()
#     assert stack.pop() == "c"
#     stack.push("d")
#     assert stack.pop() == "d"
#     assert stack.pop() == "b"
#     assert stack.pop() == "a"
#     assert stack.empty()


# def test_stack_empty_pop() -> None:
#     stack = Stack()
#     with raises(KeyError) as error:
#         stack.pop()
#     assert "You can not pop an empty stack." == error.value.args[0]


# def test_infix() -> None:
#     exp = InfixExpression("a")
#     assert exp.expression == "a"
#     exp.update_expression("+", "b*(c^d-e)^(f+g*h)")
#     assert exp.expression == "(a)+(b*(c^d-e)^(f+g*h))"
#     exp.update_expression("-", "i")
#     assert exp.expression == "((a)+(b*(c^d-e)^(f+g*h)))-(i)"


# def test_infix_private() -> None:
#     exp = InfixExpression("a")
#     assert "_expression" in dir(exp) and exp.expression == exp._expression


# @mark.parametrize(
#     "given, expected",
#     [
#         ("a+b*(c^d-e)^(f+g*h)-i", "abcd^e-fgh*+^*+i-"),
#         ("A+(B*C-(D/E^F)*G)*H", "ABC*DEF^/G*-H*+"),
#     ],
# )
# def test_infix2postfix(given: str, expected: str) -> None:
#     exp = InfixExpression(given)
#     assert exp.convert_to_postfix() == expected
#     assert exp.expression == given
