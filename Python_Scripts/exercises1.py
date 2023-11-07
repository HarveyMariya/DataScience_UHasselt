# from typing import List
# import re
# import json
from typing import List, Tuple, Dict, Union
from re import findall, IGNORECASE, search, sub
from json import load


def count_chars(text: str) -> Dict[str, int]:
    result = {'digits': len(findall(r'\d', text)), 'non-digits': len(findall(r'\D', text)),
              'whitespaces': len(findall(r'\s', text)), 'words': len(findall(r'\w+', text))}
    return result


def get_valid_numbers(text: str) -> List[str]:
    pattern = r'(\A|\s)([\-\+]?\d+(?:\.\d+)?)(\s|\Z)'
    return [f[1] for f in findall(pattern, text)]


def email_splitter(emails: str) -> List[Tuple[str, str, str]]:
    pattern = r'([\w|.]+)@([A-Z0-9]+)\.([A-Z]{2,3})\b'
    return findall(pattern, emails, flags=IGNORECASE)


def find_words_with_first_letter(letter: str, text: str) -> List[str]:
    return findall(rf'\b{letter}\w+', text, flags=IGNORECASE)


def get_html_text(html: str) -> str:
    result = html
    if search(r'<body>', html):
        result = search(r'<body>(.*)</body>', html).group(1)
    # result = sub(r'<.*?>', '', result)
    result = sub(r'<.*?>', '', result)
    return result


def get_keys(filename: str) -> List[str]:
    try:
        with open(filename) as reader:
            the_dict = load(reader)
    except FileNotFoundError:
        raise FileNotFoundError(f'Oops! file "{filename}" not found')
    if isinstance(the_dict, list) or not the_dict.keys():
        raise KeyError(f'Oops! no keys in "{filename}"')
    return list(the_dict.keys())


def log_json_keys(filename: str, logfile: str) -> None:
    try:
        output: Union[str, List[str]] = get_keys(filename)
    except FileNotFoundError:
        output = 'File not found'
    except KeyError:
        output = 'No keys found'

    with open(logfile, 'w') as writer:
        writer.writelines(output)


# def count_chars(s: str) -> dict:
#     """takes a string and returns a dictionary with the counts
#     of the number of digits, non-digit characters, whitespace
#     charaters and words in a string"""

#     # number of words in the string
#     # the list of strings
#     regex_sp = re.compile(r'\s+')
#     list_of_words = regex_sp.split(s)
#     number_of_words = len(list_of_words)

#     # number of white spaces in the string
#     list_of_spaces = regex_sp.findall(s)
#     number_of_spaces = len(list_of_spaces)

#     # number of non-digits in the string
#     regex_wd = re.compile(r'[^\d]')
#     list_of_non_digits = regex_wd.findall(s)
#     number_of_non_digits = len(list_of_non_digits)

#     # number of digits in the string
#     regex_dig = re.compile(r'\d+')
#     get_digits = regex_dig.search(s)
#     combine_digits = get_digits.group()
#     number_of_digits = len(combine_digits)

#     keys = ['digits', 'non-digits', 'whitespaces', 'words']
#     values = [number_of_digits, number_of_non_digits,
#               number_of_spaces, number_of_words]
#     new_dictionary = {}

#     for key, value in zip(keys, values):
#         new_dictionary[key] = value

#     # print(new_dictionary)
#     return new_dictionary


# def find_words_with_first_letter(letter: str, sentence: str) -> List[str]:
#     """use regular function that takes a letter and a text and returns
#     a list of strings"""

#     capital_letter = letter.upper()
#     find = r"\b[" + letter + '|' + capital_letter + r"]\w+"
#     result = re.findall(find, sentence)
#     return result


# def get_keys(s: str) -> List[str]:
#     """ function that loads and returns the key(s) found in a json file """
#     try:
#         with open(s, 'r') as new:
#             x = json.load(new)
#             keys = list(x.keys())
#             if keys == []:
#                 raise KeyError(f'Oops! no keys in "{s}"')
#             return keys
#     except FileNotFoundError:
#         raise FileNotFoundError(f"Oops! file '{s}' not found")
#     except KeyError:
#         raise KeyError(f'Oops! no keys in "{s}"')


# def log_json_keys(s: str, p: str) -> str:
#     """ function accepts two files, authenticates and writes into another
#     file if it has valid keys"""

#     try:
#         new_keys = get_keys(s)
#         if new_keys == []:
#             print('No keys found')
#         with open(p, mode='w') as logfile:
#             # logfile.writelines(new_keys)
#             logfile.write(' '.join(str(i) for i in new_keys))
#     except FileNotFoundError:
#         logfile.write('File not found')
#     except KeyError:
#         logfile.write('No keys found')
