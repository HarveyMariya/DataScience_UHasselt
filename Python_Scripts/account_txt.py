# create a text file and insert details of the account into the file

with open('account.txt', mode='w') as accounts:
    accounts.write('100 Jones 24.98\n')
    accounts.write('200 Doe 98.98\n')
    accounts.write('300 Halbert 0.0\n')
    accounts.write('400 White -4.18\n')
    accounts.write('500 Chika 6.33\n')

with open('account.txt', mode='r') as accounts:
    print(f'{"Account":<10}{"Name":<10}{"Balance":>10}')
    for record in accounts:
        account, name, balance = record.split()
        print(f'{account:<10}{name:<10}{balance:>10}')


# Read the content of the file from top to bottom again
# with open('account.txt', mode = 'r') as accounts:
#     for record in accounts:
#         print(record, end="")
#     print('------')
#     accounts.seek(0)
#     for record in accounts:
#         print(record, end="")
