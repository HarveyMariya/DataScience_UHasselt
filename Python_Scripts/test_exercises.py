# from pytest import mark, raises
# from typing import List, Dict, Tuple
# from pathlib import Path
# from unittest.mock import patch

# from exercises1 import get_keys, log_json_keys, count_chars, \
#     get_valid_numbers, email_splitter, \
#     find_words_with_first_letter, get_html_text


# @mark.parametrize('given, expected', [
#     ('There are 356 days in a year',
#      {'digits': 3, 'non-digits': 25, 'whitespaces': 6, 'words': 7}),
#     ('NumPy first appeared in 2006 and is the preferred Python array implementation',
#      {'digits': 4, 'non-digits': 73, 'whitespaces': 11, 'words': 12}),
# ])
# def test_count_chars(given: str, expected: Dict[str, int]) -> None:
#     assert count_chars(given) == expected


# @mark.parametrize('given, expected', [
#     ('-12.3 abc 0 2.2.2 13a 90', ['-12.3', '0', '90']),
#     ('13-3 a1ab +1  2. .13 1505 ', ['+1', '1505']),
# ])
# def test_get_valid_numbers(given: str, expected: List[str]) -> None:
#     assert get_valid_numbers(given) == expected


# @mark.parametrize('given, expected', [
#     ('john@doe.com boss@head.hg smith.john@work.nu',
#      [('john', 'doe', 'com'), ('boss', 'head', 'hg'), ('smith.john', 'work', 'nu')]),
#     ('john@doe boss@head.hg smith.john@work.nu',
#      [('boss', 'head', 'hg'), ('smith.john', 'work', 'nu')]),
#     ('john@doe.com boss@head. @work.nu',
#      [('john', 'doe', 'com')]),
#     ('john@doe.com boss@head.hg smith.john@work.null',
#      [('john', 'doe', 'com'), ('boss', 'head', 'hg')]),
# ])
# def test_email_splitter(given: str, expected: List[Tuple[str, str, str]]) -> None:
#     assert email_splitter(given) == expected


# @mark.parametrize('letter, text, expected', [
#     ('a', 'Alice in amazing America goes class is all the way',
#      ['Alice', 'amazing', 'America', 'all']),
#     ('b', 'better be safe than sorry', ['better', 'be'])
# ])
# def test_find_words_with_first_letter(letter: str, text: str, expected: List[str]) -> None:
#     assert find_words_with_first_letter(letter, text) == expected


# @mark.parametrize('html, expected', [
#     ('This is <em>emphasized</em> text', 'This is emphasized text'),
#     ('<html><head><title>A Title</title></head>'
#      '<body><h1>My page</h1><p>Let me refer you to <a href="...">here</a></body></html>', 'My pageLet me refer you to here'),
# ])
# def test_get_html_text(html: str, expected: str) -> None:
#     assert get_html_text(html) == expected


# def test_get_keys_file_not_found() -> None:
#     with raises(FileNotFoundError) as error:
#         get_keys('blablabla.tttt')
#     assert 'Oops! file "blablabla.tttt" not found' == error.value.args[0]


# @mark.parametrize('json_string, expected_keys', [
#     ('{"a": 1, "b": 3}', ["a", "b"]),
#     ('{"a": 1, "b": {"c": 4}}', ["a", "b"]),
# ])
# def test_get_keys(tmp_path: Path, json_string: str, expected_keys: List) -> None:
#     input_file = tmp_path / 'input.txt'
#     input_file.write_text(json_string)
#     assert get_keys(input_file.as_posix()) == expected_keys


# @mark.parametrize('json_string', [
#     '{}',
#     '[]',
#     '[{}, {}]',
# ])
# def test_get_keys_no_keys(tmp_path: Path, json_string: str) -> None:
#     input_file = tmp_path / 'input.txt'
#     input_file.write_text(json_string)
#     with raises(KeyError) as error:
#         get_keys(input_file.as_posix())
#     assert f'Oops! no keys in "{input_file.as_posix()}"' == error.value.args[0]


# @mark.parametrize('error, expected_result', [
#     (FileNotFoundError, 'File not found'),
#     (KeyError, 'No keys found')
# ])
# def test_log_json_keys_handle_exceptions(tmp_path: Path, error: Exception, expected_result: str) -> None:
#     log_file = tmp_path / 'log.txt'
#     with patch('exercises1.get_keys', side_effect=error):
#         log_json_keys('notImportant.txt', log_file.as_posix())
#     assert log_file.read_text() == expected_result


# @mark.parametrize('json_string, expected_result', [
#     ('{"a": 1, "b": 3}', 'ab'),
#     ('{"a": 1, "b": {"c": 4}}', 'ab'),
# ])
# def test_log_json_keys_valid_json(tmp_path: Path, json_string: str, expected_result: str) -> None:
#     input_file = tmp_path / 'input.txt'
#     input_file.write_text(json_string)
#     log_file = tmp_path / 'log.txt'
#     log_json_keys(input_file.as_posix(), log_file.as_posix())
#     assert log_file.read_text() == expected_result
