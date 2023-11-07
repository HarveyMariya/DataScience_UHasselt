# from exercises2 import Point, Circle, SMSsStore
# from pytest import mark, raises, fixture
# import random


# def test_point() -> None:
#     p = Point(random.randint(-10, 10), random.randint(-10, 10))
#     assert '_x' in dir(p) and '_y' in dir(p) and p._x == p.x and p._y == p.y


# @mark.parametrize(
#     "x1, y1, x2, y2, distance",
#     [
#         (0, 0, 0, 0, 0),
#         (0, 0, 0, 5, 5),
#         (0, 0, 5, 0, 5),
#         (0, 0, 3, 4, 5),
#         (1, 2, 4, 6, 5),
#     ],
# )
# def test_point_distance_to(x1: int, y1: int, x2: int, y2: int, distance: float) -> None:
#     assert Point(x1, y1).distance_to(Point(x2, y2)) == distance


# @mark.parametrize("x1, y1, x2, y2, m, c", [(4, 11, 6, 15, 2, 3), (0, 0, 1, 1, 1, 0)])
# def test_point_calculate_equation(
#     x1: int, y1: int, x2: int, y2: int, m: float, c: float
# ) -> None:
#     assert Point(x1, y1).calculate_equation(Point(x2, y2)) == (m, c)


# def test_point_calculate_equation_fails_on_equal_x() -> None:
#     with raises(ZeroDivisionError):
#         Point(1, 2).calculate_equation(Point(1, 3))


# @mark.parametrize("x, y", [(0, 0), (-5, 0), (3, 4), (6, -3)])
# def test_point_move_to(x: int, y: int) -> None:
#     p = Point(random.randint(-10, 10), random.randint(-10, 10))
#     p.move_to(x, y)
#     assert p.x == x and p.y == y


# @mark.parametrize(
#     "r, x, y, expected",
#     [(4, 0, 0, 50.27), (0, 0, -5, 0), (1, -7, -3, 3.14), (7, 2, -4, 153.94)],
# )
# def test_circle_area(r: int, x: int, y: int, expected: float) -> None:
#     p = Point(x, y)
#     c = Circle(r, p)
#     assert round(c.area, 2) == expected


# def test_circle_area_read_only() -> None:
#     p = Point(0, 0)
#     c = Circle(1, p)
#     with raises(AttributeError) as error:
#         c.area = 9
#     assert "can't set attribute" == error.value.args[0]


# @mark.parametrize("r, x, y", [(4, 0, 0), (0, 0, -5), (1, -7, -3), (7, 2, -4)])
# def test_circle_move_to(r: int, x: int, y: int) -> None:
#     p = Point(random.randint(-10, 10), random.randint(-10, 10))
#     c = Circle(r, p)
#     c.move_to(x, y)
#     assert p.x == x and p.y == y and c.radius == r and c.point == p


# @mark.parametrize(
#     "r1, x1, y1, r2, x2, y2, expected",
#     [
#         (4, 0, 0, 2, 0, 0, True),
#         (3, 0, -5, 2, 0, 0, True),
#         (1, -7, -3, 3, 4, -4, False),
#         (4, 1, 2, 4, -6, -3, False),
#     ],
# )
# def test_circle_is_touching(
#     r1: int, x1: int, y1: int, r2: int, x2: int, y2: int, expected: bool
# ) -> None:
#     c1 = Circle(r1, Point(x1, y1))
#     c2 = Circle(r2, Point(x2, y2))
#     assert c1.is_touching(c2) == expected

# # SmsStore Test Cases


# @fixture
# def sms_store() -> SMSsStore:
#     return SMSsStore()


# @mark.parametrize(
#     "has_been_viewed, from_number, time_arrived, text_of_SMS, output",
#     [
#         (False, "1234567890", '2-11-2022', "Hello, how are you?", 1),
#         (False, "0987654321", '20-5-2022', "I'm good, thanks!", 1),
#         (False, "5555555555", '12-6-2022', "Can we meet tomorrow?", 1),
#     ],
# )
# def test_add_new_arrival(
#         sms_store, has_been_viewed, from_number, time_arrived, text_of_SMS, output) -> None:
#     sms_store.add_new_arrival(from_number, time_arrived, text_of_SMS)
#     assert sms_store.message_count() == output


# @mark.parametrize("index", [
#     0,
#     1,
#     2,
# ])
# def test_get_message(sms_store, index):
#     sms_store.add_new_arrival("1234567890", '2-10-2022', "Hello, how are you?")
#     sms_store.add_new_arrival("0987654321", '9-11-2022', "I'm good, thanks!")
#     sms_store.add_new_arrival(
#         "5555555555", '4-11-2002', "Can we meet tomorrow?")
#     message = sms_store.get_message(index)
#     assert message is not None


# @mark.parametrize("number, expected_result", [
#     ("1234567890", ["Hello, how are you?"]),
#     ("0987654321", ["I'm good, thanks!"]),
#     ("5555555555", ["Can we meet tomorrow?"]),
#     ("9999999999", []),
# ])
# def test_get_messages_from(sms_store, number, expected_result):
#     sms_store.add_new_arrival("1234567890", '4-11-2002', "Hello, how are you?")
#     sms_store.add_new_arrival("0987654321", '4-01-2012', "I'm good, thanks!")
#     sms_store.add_new_arrival(
#         "5555555555", '12-11-2022', "Can we meet tomorrow?")
#     messages = sms_store.get_messages_from(number)
#     assert messages == expected_result


# @mark.parametrize("index", [
#     0,
#     1,
#     2,
# ])
# def test_delete(sms_store, index):
#     sms_store.add_new_arrival("1234567890", '4-08-2002', "Hello, how are you?")
#     sms_store.add_new_arrival("0987654321", '14-11-2002', "I'm good, thanks!")
#     sms_store.add_new_arrival(
#         "5555555555", '9-10-2012', "Can we meet tomorrow?")
#     sms_store.delete(index)
#     assert sms_store.message_count() == 2


# def test_clear(sms_store):
#     sms_store.add_new_arrival("1234567890", '4-01-2022', "Hello, how are you?")
#     sms_store.add_new_arrival("0987654321", '08-11-2002', "I'm good, thanks!")
#     sms_store.add_new_arrival(
#         "5555555555", '11-11-2012', "Can we meet tomorrow?")
#     sms_store.clear()
#     assert sms_store.message_count() == 0
