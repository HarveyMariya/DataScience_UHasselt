from math import sqrt, pi
from datetime import datetime
from typing import List, Tuple

# from decimal import Decimal


class Point:
    """Point class represents and manipulates x,y coordinates."""

    # self is the reference location where the other arguments are
    def __init__(self, x: int, y: int) -> None:
        """Creates a new point at x, y."""
        self.x = x
        self.y = y

    @property
    def x(self):
        print("@property x is called")
        return self._x

    @x.setter
    def x(self, x):
        print("@x.setter is called")
        self._x = x

    @property
    def y(self):
        print("@property y is called")
        return self._y

    @y.setter
    def y(self, y):
        print("@y.setter is called")
        self._y = y

    # if string(__str__) is not defined representation will be used
    def __repr__(self) -> str:
        """Modifies the default representation of a Point Object."""
        return f"Point(x,y) = ({self.x}, {self.y})"

    def __str__(self) -> str:
        """Modifies the default string representation of a Point object"""
        return f"the two points are: ({self._x}, {self._y})"

    def distance_from_origin(self) -> float:
        """Compute the distance from the origin."""
        return ((self.x ** 2) + (self.y ** 2)) ** 0.5

    def distance_to(self, point) -> float:
        """calculates the distance between two points"""
        distance = sqrt((self.x - point.x) ** 2 + (self.y - point.y) ** 2)
        return distance

    def calculate_equation(self, point) -> Tuple[float, float]:
        m = (point.y - self.y) / (point.x - self.x)
        c = self.y - m * self.x
        return (m, c)

    def move_to(self, x: int, y: int) -> None:
        self.x = x
        self.y = y


class Circle:
    """Circle class represent some properties and points in a circle"""

    def __init__(self, radius: int, point: Point) -> None:
        """takes the radius and the mid-point of the circle"""
        self.radius = radius
        self.point = point

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, radius):
        self._radius = radius

    @property
    def point(self):
        return self._point

    @point.setter
    def point(self, point):
        self._point = point

    # Heba: OK, but if you have defined getters, use them, do not use the attribute itself
    # Adjusted: means don't use self._, use self.
    def __repr__(self) -> str:
        """Modifies the default representation of a Circle object"""
        return f"Circle(radius = {self.radius}, point = {self.point})"

    # Heba: Same ^^^
    def __str__(self) -> str:
        """Modifies the default string representation of a Circle object"""
        return f"A circle with {self.radius} and center {self.point}"

    # Heba: Same ^^^
    # Adjusted: means don't use self._, use self.
    # Because it is a read-only property i.e the radius will not be changed from time to time
    @property
    def area(self):
        # print("@property area is called")
        area = pi * self.radius * self.radius
        return area

    # we define the getter as the decorator property, how about the setter?

    # Heba: properties are not just attributes, they may also be values that are
    # computable from (some of) the attributes of the object
    # for this particular case, the area is a value (property) of the circle that
    # is computable from its radius
    # According to the question, the area is read only and we cannot set its value
    # to something else that's why we did not defined a setter.
    # Assuming it was not a read-only property and we could change its value, then
    # think what would it mean to defined a setter for the area?
    # Note that you do not have an attribtute for it (it is only a computable property)

    def move_to(self, x: int, y: int) -> None:
        self.point.move_to(x, y)
        # self.x = x
        # self.y = y

        # the move_to will be called on the object point
        # self._point.move_to(self.x, self.y)

    # Heba: again, if you have defined getters, use them, do not use the attribute itself
    # Adjusted: means don't use self._, use self.
    def is_touching(self, another_circle) -> bool:
        # pass
        return (
            self._point.distance_to(another_circle._point)
            <= self.radius + another_circle.radius
        )
        # confused on how to get the attributes of the other circle
        # how to get the attributes to calculate the distance

        # Heba: the other circle is just the a circle, so you can deal with
        # as you deal with self.


class SMSsStore:
    """this class instantiates objects that are similar to an inbox
    or outbox on a cellphone. This store holds multiple SMS messages"""

    # Heba: OK
    def __init__(self) -> None:
        self._messages = []

    # Heba: OK, but better list the messages instead of adding their count
    def __repr__(self) -> str:
        return f"SMSsStore(message = {self.messages})"

    # Heba: OK
    def add_new_arrival(
        self, from_number: str, time_arrived: datetime, text_of_SMS: str
    ):
        return self._messages.append((False, from_number, time_arrived, text_of_SMS))

    # Heba: OK
    def message_count(self):
        return len(self._messages)

    # Heba: OK
    def get_unread_indexes(self):
        unread_indexes = [
            index for index, message in enumerate(self._messages) if not message[0]
        ]
        return unread_indexes

    # Heba: OK
    def get_message(self, index: int):
        if index >= len(self._messages):
            print("Message index does not exist")
            return None
        else:
            message = self._messages[index]
            new_message = message[1], message[2], message[3]
            self._messages[index] = (True, message[1], message[2], message[3])
            return new_message

    # Heba: OK
    def delete(self, index: int):
        try:
            del self._messages[index]
        except IndexError:
            raise ValueError(
                f"You requested to delete the message at index {index}, \
                    while there are only {len(self._messages)} messages"
            )

    # Heba: NOT OK! tuples are immutable, so changing message[0] to be True should not be possible.
    # You have to do something similar to what you did in `get_message`
    # Adjusted!
    def get_messages_from(self, number: str) -> List[Tuple]:
        result = []
        for index, message in enumerate(self._messages):
            if message[1] == number:
                result.append(message[3])
                self._messages[index] = (
                    True, message[1], message[2], message[3])
        return result

    # Heba: OK
    def clear(self) -> None:
        self._messages = []


if __name__ == "__main__":
    p1 = Point(1, 1)
    p2 = p1
    p3 = Point(3, 4)
    p1.move_to(2, 3)
    print(p1)
    print(p1 == p2)
#     # p2 = Point(2, 3)

    # c1 = Circle(2, p1)
    # c1.move_to(5, 4)
    # print(c1.point)
#     # c2 = Circle(3, p2)
#     # print(c1.area)
#     # print(c1.move_to(1, 2))
    print(p1.is_touching(p3))

#     store = SMSsStore()
#     store.add_new_arrival('234', '10:20', 'hello you')
