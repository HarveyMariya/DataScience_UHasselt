"""
author: [Harvey Okotie]
studentnumber: [2262068]

"""
from re import search, findall


def dna_match(s: str) -> bool:
    """a function that matches the right DNA sequence
    and returns True if it has the correct DNA sequence,
    thus False otherwise"""

    # check if the string has either AATTTA or GGCTA
    check = search(r'AATTTA|GGCTA', s)

    # if False return True i.e not valid as a DNA sequence
    if not bool(check):
        print('Yea')
        return True

    # a valid DNA sequence must have four nucleobases
    # use regex to search for the required pattern
    # AATTTA + at most 10 arbitrary nucleotides + GGCTA
    dna_sequence = search(r'AATTTA\w{0,10}GGCTA$', s)

    # return True or False if the string has the required pattern
    return bool(dna_sequence)


def collect_email_from_text(s: str, email_file: str) -> None:
    """a function that extracts a list of all valid email addresses found
    in a text and writes this list in a specific format to an output file"""

    # regular expression to find valid emails
    expression = r'[\w_\-\+\"][\w_\-\+\"\.]*@\w(?:[\w\-]+\.)+\w+'

    # use regex function 'findall' to match and return all
    # the valid email addresses.
    extracted_emails = findall(expression, s)

    # count the number of email addresses extracted
    number_of_emails = len(extracted_emails)

    # open and write into the given file
    with open(email_file, mode='w') as new_file:

        # begins with the number of email addresses extracted
        new_file.write(f'The number of emails extracted is {number_of_emails}')
        for emails in extracted_emails:
            new_file.write("\n" + emails)


if __name__ == '__main__':
    # print(dna_match("TTAGGCTA"))
    print(dna_match("AATTTAZGGCTA"))
