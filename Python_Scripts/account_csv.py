# write and read a csv file

import csv

with open('accounts.csv', mode='w', newline='') as account:
    writer = csv.writer(account)
    writer.writerow([100, 'Jones', 24.98])
    writer.writerow([200, 'Richard', 375.67])
    writer.writerow([300, 'Helen', 0.98])
    writer.writerow([400, 'Phams', -4.98])
    writer.writerow([500, 'Stone', 224.18])


with open('accounts.csv', mode='r', newline='') as account:
    print(f'{"Account":<10}{"Name":<10}{"Balance":>10}')
    reader = csv.reader(account)
    for record in reader:
        acc, name, balance = record
        print(f'{acc:<10}{name:<10}{balance:>10}')


import pandas as pd

df = pd.read_csv('accounts.csv', names = ['account', 'name', 'balance'])

print(df)
