# Define the problem and identify data to be used
# Create a class Stack
# create an object that takes values
# the values will be in a container (list)
# create methods push, pop and empty
# check if the list is empty or has content

# Decide on the class name and create python file
#

# Define class using 'class' keyword and class name

# Define constructor method '__init__' to initiatiate object's attributes

# Define other methods needed to solve the problem

# Add comments to the code

# Test the class by creating an object and calling methods


########### Rough Assignment 2 ##############
########################### NEW #######################

# from re import findall


# class Stack:
#     def __init__(self):
#         self._item = []

#     def __repr__(self):
#         return f'the data stored is: {self._item}'

#     @property
#     def item(self):
#         return self._item

#     def push(self, value):
#         self._item.append(value)

#     def pop(self):
#         if self.empty():
#             raise KeyError("You can not pop an empty stack.")
#         return self._item.pop()

#     def empty(self):
#         return self._item == []


# class InfixExpression:
#     def __init__(self, expression):
#         self._expression = expression

#     def __repr__(self):
#         return f'expression = {self._expression}'

#     def __str__(self):
#         return f'the expression is: {self._expression}'

#     @property
#     def expression(self):
#         return self._expression

#     @expression.setter
#     def expression(self, value):
#         self._expression = value

#     def update_expression(self, operator, expression):
#         result = f'({self._expression}){operator}({expression})'
#         self._expression = result
#         return result

#     # For postfix

#     # use the .pop method
#     # def roof_element(self):
#     #     length = len(self._item)

#     #     if length:
#     #         return self._item[length - 1]
#     #     return False

#     def check_alphabet(self, operand):
#         if chr(65) <= operand <= chr(122):>>>>>>>>>>>>>>>>>>>>>>>>>>
#             return True
#         return False

#     def check_operator(self, operator):
#         OPERATORS = ['+', '-', '*', '/', '^']
#         for char in OPERATORS:
#             if operator == char:>>>>>>>>>>>>>>>>>>>>>>>
#                 return True
#         return False

#     def precedence_order(self, operator):
#         PRECEDENCE = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}

#         if operator in PRECEDENCE:
#             return PRECEDENCE[operator]

#         return 0

#     def convert_to_postfix(self):

#         stack = Stack()
#         result = ""
#         pattern = r"(\b\w*[\.]?\w+\b|[\(\)\^\+\*\-\/])"
#         new_expression = findall(pattern, self._expression)

#         for item in new_expression:

#             if self.check_alphabet(item):
#                 result += item

#             elif self.check_operator(item):
#                 while True:
#                     if stack.empty():
#                         stack.push(item)
#                         break

#                     pop_item = stack.pop()
#                     if pop_item == '(':
#                         stack.push(pop_item)
#                         stack.push(item)
#                         break
#                     else:
#                         operator_position = self.precedence_order(item)
#                         item_position = self.precedence_order(pop_item)

#                         if operator_position > item_position:
#                             stack.push(pop_item)
#                             stack.push(item)
#                             break
#                         else:
#                             result += pop_item

#             elif item == '(':
#                 stack.push(item)

#             elif item == ')':
#                 while not stack.empty():
#                     pop_item = stack.pop()
#                     if pop_item == '(':
#                         break
#                     result += pop_item

#         while not stack.empty():
#             new_item = stack.pop()
#             result += new_item

#         return result


infixExps = [
    'A*B+C',    # AB*C+
    'A+B*C',    # ABC*+
    'A*B+C*D',  # AB*CD*+
    'A*B^C+D',  # ABC^*D+
    'A*(B+C*D)+E',          # ABCD*+*E+
    'A+(B*C-(D/E^F)*G)*H',  # ABC*DEF^/G*-H*+
    '(A+B)*C+D/(E+F*G)-H',  # AB+C*DEFG*+/+H-
    'A-B-C*(D+E/F-G)-H',     # AB-CDEF/+G-*-H-
    "a+b*(c^d-e)^(f+g*h)-i",  # "abcd^e-fgh*+^*+i-",
    "A+(B*C-(D/E^F)*G)*H",  # "ABC*DEF^/G*-H*+"
    '(2*3)+(5*4)-9'
]

for exp in infixExps:
    infix = InfixExpression(exp)
    postfix = infix.convert_to_postfix()
    print(f"Infix: {exp} => Postfix: {postfix}")
