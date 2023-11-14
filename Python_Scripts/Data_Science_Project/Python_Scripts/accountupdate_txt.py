accounts = open('account.txt', 'r')

temp_file = open('temp_file.txt', 'w')

with accounts, temp_file:
    for record in accounts:
        account, name, balance = record.split()
        if account != '300':
            temp_file.write(record)  # copy all in account file to temporary file 
        else:
            new_record = ' '.join([account, 'Williams', balance])  # alter the line with 300 by changing the name to Williams
            temp_file.write(new_record + '\n')  # insert it into the new file

import os

# delete the original file 
os.remove('account.txt')

# rename the new temporary file 
os.rename('temp_file.txt', 'account.txt')
