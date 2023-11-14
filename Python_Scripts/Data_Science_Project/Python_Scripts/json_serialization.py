# Serializing an Object to JSON

a = {'Records': [
    {'James': "Unizik", 'Grade': 'Upper', 'Salary': 10000, 'food': 'eba'},
    {"Feh": "Delsu", 'Grade': 'Lower', 'Salary': 13100, 'food': 'rice'},
    {'Cy': 'PTI', 'Grade': 'Pass', 'Salary': 100, 'food': 'fries'},
    {'Fred': 'PTI', 'Grade': 'Distinction', 'Salary': 141000, 'food': 'capsalon'},
    {'Matilda': 'PTI', 'Grade': 'Upper', 'Salary': 15000, 'food': 'noodles'}
]}

import json

# create a json file and inserting the dictionary above in the file
# with open('account.json', mode='w') as accounts:
#     json.dump(a, accounts)


# Deserializing the JSON Text i.e to read each dictionary in the json file
with open('account.json', mode='r') as account:
    #accounts_json = json.load(account)
    print(json.dumps(json.load(account), indent=4))  # dumps means 'dump string': this displays the output in indented format(pretty printing)
# print(accounts_json)
# print(accounts_json['Records'])
# print(accounts_json['Records'][2])
