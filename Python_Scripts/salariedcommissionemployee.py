import math
from commissionemployee import CommissionEmployee


class SalariedCommissionEmployee(CommissionEmployee):

    def __init__(self, first_name, last_name, ssn, gross_rate, commission_rate, base_salary):
        super().__init__(first_name, last_name, ssn, gross_rate, commission_rate)
        self._base_salary = base_salary

    @property
    def base_salary(self):
        return self._base_salary

    @base_salary.setter
    def base_salary(self, salary):
        if salary < 0:
            raise ValueError(f'The salary {salary} should not be less than 0')
        self._base_salary = salary

    def earning(self):
        return super().earning() + 10  # Corrected the earning calculation

    def __repr__(self):
        return f'Salaried{super().__repr__()} \n Base salary: {self._base_salary}'

    def __str__(self):
        return f'{super().__str__()} with Salary of {self._base_salary} in dollars'


############################################################################################


class Point:

    def __init__(self, x: int, y: int) -> None:

        self.x = x
        self.y = y

    def __repr__(self) -> str:
        return f'Point x: {self.x} and Point y: {self.y}'

    def __eq__(self, value) -> bool:
        if isinstance(value, Point):
            return self.x == value.x and self.y == value.y
        return False

    def __lt__(self, value) -> bool:
        if isinstance(value, Point):
            dist_origin = math.sqrt(self.x**2 + self.y**2)
            dist_final = math.sqrt(value.x**2 + value.y**2)
            return dist_origin < dist_final
        return TypeError('you entered a wrong point')

    def __leq__(self, value) -> bool:
        if isinstance(value, Point):
            dist_origin = math.sqrt(self.x**2 + self.y**2)
            dist_final = math.sqrt(value.x**2 + value.y**2)
            return (dist_origin < dist_final) or (dist_origin == dist_final)
        return TypeError('you entered a wrong point')

    def __add__(self, value):
        if isinstance(value, Point):
            new_x = self.x + value.x
            new_y = self.y + value.y
            return Point(new_x, new_y)
        return TypeError('you entered a wrong point')

    def __iadd__(self, value):
        if isinstance(value, Point):
            self.x += value.x
            self.y += value.y
            return self
        return TypeError('you entered a wrong point')


if __name__ == "__main__":
    d1 = SalariedCommissionEmployee("Fish", "Son", 234, 10.5, 3.5, 10000)
    d2 = SalariedCommissionEmployee("Koip", "Opot", 115, 21.5, 7.5, 9_000)
    print(d1.earning())
    # print(d2._base_salary)
