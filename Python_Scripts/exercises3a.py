from dataclasses import dataclass
from typing import List

# it is better to use the private property in the setter and getters
# so it can go throught the required checks before performing/assuming
# the allocated value or element.


class Book:
    """define attributes of class"""

    def __init__(self, isbn, title, authors, production_price) -> 'Book':
        self.isbn = isbn
        self.title = title
        self.authors = authors
        self.production_price = production_price

    @property
    def isbn(self):
        return self._isbn

    @isbn.setter
    def isbn(self, value):
        if not (value.isdigit() or len(value) != 10):
            ValueError(f'The isbn {value} number is not upto 10 digits')
        else:
            self._isbn = value

    @property
    def title(self):
        return self._title

    @title.setter
    def title(self, name):
        self._title = name

    @property
    def authors(self):
        return self._authors

    @authors.setter
    def authors(self, name: List[str]):
        self._authors = name

    @property
    def production_price(self):
        return self._production_price

    @production_price.setter
    def production_price(self, price):
        self._production_price = price

    def get_purchase_price(self):
        return self.production_price * 2


class ResearchBook:
    """subclass of the class Book"""

    def __init__(self, isbn, title, authors, production_price,
                 field):

        super().__init__(isbn, title, authors, production_price)
        self.field = field

    @property
    def field(self):
        return self._field

    @field.setter
    def field(self, name):
        self.field = name


class ChildrenBook:
    """subclass of the class Book"""

    def __init__(self, isbn, title, authors, production_price,
                 age_limit, profit_percentage):
        """initialize ChildrenBook attributes."""

        super().__init__(isbn, title, authors, production_price)
        self.age_limit = age_limit

        if not (0 <= profit_percentage <= 100):
            raise ValueError('profit percentage must be of range 0 to 100')

        self.profit_percentage = profit_percentage

    @property
    def profit_percentage(self):
        return self._profit_percentage

    @profit_percentage.setter
    def profit_percentage(self, percent):
        self.profit_percentage = percent

    def get_purchase_price(self):
        percentage = self.production_price * self.profit_percentage/100
        return self.production + percentage


class Person:
    def __init__(self, first_name, last_name, birth_year):
        self.first_name = first_name
        self.last_name = last_name
        self.birth_year = birth_year


@dataclass
class PersonDC:
    first_name: str
    last_name: str
    birth_year: int


class Point:
    """Point class examines the coordinates of x and y"""

    def __init__(self, x: float, y: float) -> None:
        """Create a new point at x and y"""
        self.x = x
        self.y = y

    @property
    def x(self) -> float:
        return self._x

    @x.setter
    def x(self, x: float) -> None:
        self._x = x

    @property
    def y(self) -> float:
        return self.y

    @y.setter
    def y(self, y) -> None:
        self._y = y

    def distance_from_origin(self) -> float:
        # square root of x^2 + y^2
        return ((self._x ** 2) + (self._y ** 2)) ** 0.5

    def __repr__(self) -> str:
        return f'Point(x={self.x}, y={self.y})'

    def __eq__(self, other: 'Point') -> bool:
        return self._x == other._x

    def __lt__(self, other: 'Point') -> bool:
        return self.distance_from_origin() < other.distance_from_origin()

    def __le__(self, other: 'Point') -> bool:
        return self.__eq__(other) or self.__lt__(other)

    def __add__(self, other: 'Point') -> 'Point':
        return Point(self._x + other._x, self._y + other._y)

    def __iadd__(self, other: 'Point') -> None:
        self._x += other._x
        self._y += other._y


if __name__ == "__main__":
    b = Book('1234567890', 'Jungle', ['Harve', 'Mike'], 2.3)
    print(b.authors)


def parse_persons(filename: str):

    result = []

    with open(filename, 'r') as new_file:
        for i in new_file:
            name, age = [i.strip() for j in i.split(',')]
            result.append(Person(name, age))
    return result
    # open and read file
    # loop into the file
    # retrive the name and age
    # append to a list
