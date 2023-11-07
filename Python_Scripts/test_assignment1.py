# from typing import List
# from pathlib import Path
# from unittest.mock import patch
# from pytest import mark
# from Assignment1 import dna_match, collect_email_from_text


# @mark.parametrize('dna, expected', [
#     ('AAA', True),
#     ('AATTTA', False),
#     ('AATTTAGGCTA', True),
#     ('AATTTATACGGGCTA', True),
#     ('AATTTATTTTTTTTTTGGCTA', True),
#     ('AATTTATTTTTTTTTTTGGCTA', False),
#     ('AATTTAATTTAGGCTA', True),
# ])
# def test_dna_match(dna: str, expected: bool) -> None:
#     assert dna_match(dna) is expected


# @mark.parametrize('content, emails', [
#     ('', []),
#     ('___e--mail@123.123.123.123', ['___e--mail@123.123.123.123']),
#     ('"john"@doe.com', ['"john"@doe.com']),
#     ('email@-domain.com', []),
#     ('email@domain..com', []),
#     ('e..mail@domain..com', []),
#     ('.email@domain.com', ['email@domain.com']),
#     ('<b>email me on</b><em>john@doe.com</em>', ['john@doe.com']),
#     ('This is valid also john.doe+1@gmail.com', ['john.doe+1@gmail.com']),
#     ('you have jane@do-e-e.uk.com but als john@this.be, although not me@this',
#      ['jane@do-e-e.uk.com', 'john@this.be']),
# ])
# def test_collect_email_from_text(tmp_path: Path, content: str, emails: List[str]) -> None:
#     log_file = tmp_path / 'log.txt'
#     with patch('assignment1.collect_email_from_text'):
#         collect_email_from_text(content, log_file.as_posix())
#     expected_result = '\n'.join(
#         [f'The number of emails extracted is {len(emails)}'] + emails)
#     assert log_file.read_text() == expected_result
