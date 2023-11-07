

class Point:
    """Point class represents and manipulates x,y coordinates."""

    def __init__(self, x: int = 0, y: int = 0) -> None:
        """Creates a new point at x, y."""
        self.x = x
        self.y = y

    def distance_from_origin(self) -> float:
        """Compute the distance from the origin."""
        return ((self.x ** 2) + (self.y ** 2)) ** 0.5
