import math


class CommissionEmployee:
    def __init__(self, first_name, last_name, ssn, gross_rate, commission_rate):
        self._first_name = first_name
        self._last_name = last_name
        self._ssn = ssn
        self._gross_rate = gross_rate
        self._commission_rate = commission_rate

    @property
    def first_name(self):
        return self._first_name

    @property
    def last_name(self):
        return self._last_name

    @property
    def ssn(self):
        return self._ssn

    @property
    def gross_rate(self):
        return self._gross_rate

    @gross_rate.setter
    def gross_rate(self, value):
        if value < 0:
            raise ValueError(f'The value {value} you inserted is wrong')
        self._gross_rate = value

    @property
    def commission_rate(self):
        return self._commission_rate

    @commission_rate.setter
    def commission_rate(self, rate):
        if rate < 0:
            raise ValueError(f'The rate {rate} entered is wrong')
        self._commission_rate = rate

    def __repr__(self):
        represent = f'First name: {self._first_name}\n' \
                    f'Last name: {self._last_name}\n' \
                    f'SS Number: {self._ssn}\n' \
                    f'Gross rate: {self._gross_rate}\n' \
                    f'Commission rate: {self._commission_rate}'
        return represent

    def __str__(self):
        return f"The employee's name {self._first_name} {self._last_name} with " \
               f"SSN {self._ssn} has a gross rate of {self._gross_rate} and commission rate " \
               f"of {self._commission_rate}"

    @property
    def earning(self):
        return self._gross_rate * self._commission_rate


#####################################################################
############ Operator Overloading ##############


class Point:

    def __init__(self, x: int, y: int) -> None:
        """initialize the points of the class"""

        self.x = x
        self.y = y

    def __repr__(self) -> str:
        """the string representation of the points"""
        return f'Point x: {self.x} and Point y: {self.y}'

    def __eq__(self, value) -> bool:
        if isinstance(value, Point):
            return self.x == value.x and self.y == value.y
        return False

    def __lt__(self, value) -> bool:
        if isinstance(value, Point):
            distance_origin = math.sqrt(self.x**2 + self.y**2)
            distance_new = math.sqrt(value.x**2 + value.y**2)
            return distance_origin < distance_new
        return TypeError('Cannot compare this point parsed')

    def __le__(self, value) -> bool:
        if isinstance(value, Point):
            return self < value or self == value
        return TypeError('Cannot compare this point parsed')

    def __add__(self, value):
        if isinstance(value, Point):
            new_x = self.x + value.x
            new_y = self.y + value.y
            return Point(new_x, new_y)
        return TypeError('Cannot compare point parsed')

    def __iadd__(self, value):
        if isinstance(self, value):
            self.x += value.x
            self.y += value.y
            return self
        return TypeError('Cannot compare point parsed')


if __name__ == "__main__":
    # c1 = CommissionEmployee("John", "Ekpa", 234, 10.5, 3.5)
    # c2 = CommissionEmployee("Filip", "Kobo", 115, 21.5, 7.5)
    # print(c1)
    # print(c2.commission_rate)
