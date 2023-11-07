"""
author: [Harvey Okotie]
studentnumber: [2262068]

"""
from re import findall
from typing import List


class Stack:
    """Stack class that stores data in a stack with the Last In First
    Out manner

    Example
    -------
    stack = Stack()
    stack.push('ABC')
    stack.push('+')
    stack.pop()

    """

    def __init__(self) -> None:
        """Initialize the stack"""

        self._item = []

    def __repr__(self) -> str:
        """return a textual representation of the object

        Returns
        -------
        str
            string representation of the object
        """

        return f'the data stored is: {self._item}'

    @property
    def item(self) -> List[str]:
        """takes items(data) stored in the stack

        Returns
        -------
        List[str]
            a list of strings in the stack

        """

        return self._item

    def push(self, value: str) -> None:
        """a action used to add data x to the top of the stack

        Returns
        -------
        List[str]
            takes data and store at the top of the stack
        """

        self._item.append(value)

    def pop(self) -> str:
        """removes and returns the element on the top of the stack
        and returns error if the stack is empty

        Returns
        -------
        List[str]
            removes the top most element in a stack
        """

        if self.empty():
            raise KeyError("You can not pop an empty stack.")
        return self._item.pop()

    def empty(self) -> bool:
        """a boolean method that checks whether the stack is empty
        or not"""

        return self._item == []


class InfixExpression:
    """a class used to create and instantiate expressions in infix notations"""

    def __init__(self, expression: str) -> None:
        """initialize the object for the class"""

        self._expression = expression

    def __repr__(self) -> str:
        """return a textual representation for repr()

        Returns
        -------
        str
            string representation of the object
        """

        return f'expression = {self._expression}'

    def __str__(self) -> str:
        """return a textual representation of the object

        Returns
        -------
        str
            string representation of the object
        """

        return f'the expression is: {self._expression}'

    @property
    def expression(self) -> str:
        """acccessor for the expression

        Returns
        -------
        str
            string added as an infix expression
        """

        return self._expression

    @expression.setter
    def expression(self, value: str) -> None:
        """a changeable value of the expression"""

        self._expression = value

    def update_expression(self, operator: str, expression: str) -> str:
        """updates the self._expression with an operator and expression which
        represents another expression

        Args:
            operator: A character.
            expression: A string of infix expression

        Returns:
            string

        Example:
        -------
            expression = InfixExpression('A+B*C')
            print(expression.update_expression('-', 'AB')) # '(A+B*C)-(AB)'
        """

        result = f'({self._expression}){operator}({expression})'
        self._expression = result
        return result

    def check_operand(self, operand):
        """checks whether it is an operand"""

        if operand.isalpha():
            return True
        return False

    def check_operator(self, operator: str) -> bool:
        """checks whether it is an operator and returns boolean"""

        OPERATORS = ['+', '-', '*', '/', '^']
        if operator in OPERATORS:
            return True
        return False

    def precedence_order(self, operator: str) -> int:
        """checks the order of precedence and returns a value which
        represents the order number"""

        PRECEDENCE = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}

        if operator in PRECEDENCE:
            return PRECEDENCE[operator]

        return 0

    def convert_to_postfix(self) -> str:
        """
        Convert infix expression to be in postfix format.

        Returns:
            A string of expression in postfix format.

        Example:
        -------
            expression = InfixExpression('A+B*C')
            print(expression.convert_to_postfix()) # ABC*+
        """

        stack = Stack()
        result = ""
        pattern = r"(\b\w*[\.]?\w+\b|[\(\)\^\+\*\-\/])"
        new_expression = findall(pattern, self._expression)

        for item in new_expression:

            if self.check_operand(item):
                result += item

            elif self.check_operator(item):
                while True:
                    if stack.empty():
                        stack.push(item)
                        break

                    pop_item = stack.pop()
                    if pop_item == '(':
                        stack.push(pop_item)
                        stack.push(item)
                        break
                    else:
                        operator_position = self.precedence_order(item)
                        item_position = self.precedence_order(pop_item)

                        if operator_position > item_position:
                            stack.push(pop_item)
                            stack.push(item)
                            break
                        else:
                            result += pop_item

            elif item == '(':
                stack.push(item)

            elif item == ')':
                while not stack.empty():
                    pop_item = stack.pop()
                    if pop_item == '(':
                        break
                    result += pop_item

        while not stack.empty():
            new_item = stack.pop()
            result += new_item

        return result
