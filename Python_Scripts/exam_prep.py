import json
from typing import List, Union
import re
import networkx as nx


# Question (Files and exceptions)

def get_keys(filename: str) -> List[str]:
    """ this function checks if the file parsed
    is json and returns it as a list """

    # try statement
    try:
        # open the file
        with open(filename) as new_file:

            # load the file
            new_dict = json.load(new_file)

            # check if it is a json file
            if not new_dict:

                # if not: what to expect from error
                raise KeyError(f'Oops! there is an error in {filename}')

            # else: return a list of the keys
            return list(new_dict.keys())

    # exception error
    except FileNotFoundError:
        FileNotFoundError(f'Oops! {filename} not found')


def log_json_keys(filename: str, logfile: str) -> None:
    """this function checks a file if it is json and
    writes the keys into a text file
    """

    # try
    try:
        # use get_keys() to read the file
        the_keys = get_keys(filename)

    # except filenotfound (file not found)
    except FileNotFoundError:
        FileNotFoundError('File cannot be found')

    # if not True i.e no keys present
    if not the_keys:
        raise KeyError('No keys found')

    # else there are keys: write it into the text file
    with open(logfile, 'w') as text_file:
        text_file.writelines(the_keys)


# Question (Data class)

class Person:
    '''a dataclass with name and age of different persons'''

    def __init__(self, name: str, age: int) -> None:
        '''initialize the name and age instances'''

        self.name = name
        self.age = age

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, give_name: str) -> None:
        self._name = give_name

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, give_age: str) -> None:
        self._age = give_age

    def __repr__(self) -> str:
        '''the string representation of the class'''

        return f"{self.name} whose age is {self.age}"

    def __eq__(self, value: int) -> bool:

        if isinstance(value, Person):
            if self.age == value.age:
                return self.name < value.name or self.name == value.name
            # elif self.age != value.age:
            #     return True
        return TypeError('You entered wrong value')

    def __ne__(self, value: int) -> bool:

        if isinstance(value, Person):
            if (self.age != value.age) or (self.name != value.name):
                return True
            return False
        return TypeError('You entered wrong value')

    def __gt__(self, value: int) -> bool:
        '''checks if the age is greater than...'''

        if isinstance(value, Person):
            return self.age > value.age
        return TypeError('You entered a wrong value')

    def __lt__(self, value: int) -> bool:
        '''checks if the age is less than...'''

        if isinstance(value, Person):
            return self.age < value.age
        return TypeError('Wrong value entered')

    def __geq__(self, value: int) -> bool:
        '''checks if the ages are equal or greater'''

        if isinstance(value, Person):
            if self.__gt__(value):
                return True
            elif self.age == value.age:
                return self.name > value.name
        return TypeError('Wrong value entered')

    def __leq__(self, value: int) -> bool:
        '''checks if the ages are equal or greater'''

        if isinstance(value, Person):
            if self.__lt__(value):
                return True
            elif self.age == value.age:
                return self.name < value.name
        return TypeError('Wrong value entered')

# overload the comparison operator
# method is_banned that checks the if the author/title is in list of banned words


class Book:

    def __init__(self, title: str, author: str) -> None:
        self.title = title
        self.author = author

    @property
    def title(self):
        return self._title

    @title.setter
    def title(self, name):
        self._title = name

    @property
    def author(self):
        return self._author

    @author.setter
    def author(self, name):
        self._author = name

    def __repr__(self):
        return f'Book title: {self.title} and author: {self.author}'

    def __eq__(self, value):
        if isinstance(value, Book):
            if self.author == value.author:
                return self.title > value.title or self.title == value.title

            return False

    def __gt__(self, value):
        if isinstance(value, Book):
            return self.author < value.author

    def __lt__(self, value):
        if isinstance(value, Book):
            return self.author > value.author

    def __geq__(self, value):
        if isinstance(value, Book):
            return self.__eq__(value) or self.__gt__(value)
        return False

    def __leq__(self, value):
        if isinstance(value, Book):
            return self.__eq__(value) or self.__lt__(value)
        return False

    def is_banned(self, banned_list):
        '''checks if the title or author name is found in the list of banned words'''
        for word in banned_list:
            if word.lower() in self.title.lower() or word.lower() == self.author.lower():
                return True
        return False

# Question (Files)


def parse_persons(filename: str):
    '''reads a file(csv) and returns a list of the Person object (list of tuples)

    Arg:
        filename: a string

    Return:
        List of tuples

    Example:
    -------
        input: parse_persons(filename)
        output: 
            alice, 23
            anne, 23
    '''

    result = []

    with open(filename, 'r') as new_file:
        for i in new_file:
            name, age = [j.strip() for j in i.split(',')]
            result.append(Person(name, age))
    return result


# Question (Recursion: get oldest person in a list)

def get_oldest_person(persons: List, old_person=None):

    if old_person is None:
        old_person = persons.pop()

    if len(persons) == 0:
        return old_person

    else:
        new_person = persons.pop()
        if old_person >= new_person:
            return get_oldest_person(persons, old_person)
        return get_oldest_person(persons, new_person)


# Question  (Recursion: gets list of integers from a nested list)
# where nlist is a nested list i.e list of lists
def flatten(nlist: List[List]) -> List[int]:
    '''loops over a nested list and returns a list'''
    flattened_list = []
    for item in nlist:
        if isinstance(item, int):
            flattened_list.append(item)
        elif isinstance(item, list):
            flattened_list.extend(flatten(item))
    return flattened_list


# Question (graphs)


def _check_invalid_child(graph: "nx.DiGraph") -> None:
    
    ''' 
    This function takes a directed graph graph as input and does not return any value.
    It is intended to be a private function, indicated by the underscore prefix.
    
    '''
    invalid_childs = []
    child_parents = {}
    for parent, child in graph.in_edges():
        if child_parents.get(child) is None:
            child_parents[child] = [parent]
        else:
            child_parents[child].append(parent)
    for child, parents in child_parents.items():
        number_of_parents = len(parents)
        # if more than 2 add to invalid_childs list
        if len(parents) > 2:
            invalid_childs.append(child)
            
        # assume that there should be no combination
        # other than 1 father and 1 mother at max
        
        elif number_of_parents == 2:
            first_parent = graph.get_edge_data(parents[0], child)
            second_parent = graph.get_edge_data(parents[1], child)
            
            if first_parent["relation"] == second_parent["relation"]:
                invalid_childs.append(child)
                
    if len(invalid_childs) > 0:
        raise ValueError(
        f'The parent graph is wrong, specifically, each of the following persons have more than two parents: {', '.join(invalid_childs)}'
        )
        
def parse_relations(filename: str) -> Union["nx.Digraph", None]:
    
    '''
    this function opens a file(textfile) and searches for patterns in text
    and returns a graph that represents the parent graph of the meaningful
    data in the file.
    
    '''
    graph = nx.DiGraph()
    
    with open(filename) as new_file:
        for line in new_file:
            parent_child_pairs = re.findall(
            r'(\W+) is (?:the\s)?(father|mother) of (\W+)',
                line,
                flags = re.IGNORECASE
            )
            if len(parent_child_pairs) > 0:
                for parent, relation, child in parent_child_pairs:
                    graph.add_edge(parent, child, relation = relation)
                    
    _check_invalid_child(graph)
    
    return graph


# Build and navigate through graph data structure
# Create queue and stack based data structure, learn to use map and set
################### Test Functions ###############
# if __name__ == "__main__":
#     jude1 = Person('Jude', 40)
#     jude2 = Person('Jude', 40)
#     jude3 = Person('Jude', 33)
#     alice = Person('Alice', 40)

#     max = Person('Max', 23)
#     anne = Person('Anne', 14)

#     john = Person('John', 21)

#     # check ==
#     print(jude1 == jude2)
#     print(jude1 != jude3)
#     print(alice == jude2)
#     print(jude1 < jude2)

# keys = get_keys("file1.json")
# print(keys)
