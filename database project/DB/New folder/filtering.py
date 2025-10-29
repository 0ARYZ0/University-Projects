from my_lib import query

agency = input("Enter agency name : ")

my_query = 'SELECT * From travel '
my_query += f'WHERE agency = \'{agency}\' '

while input("press Enter to end Conditions") :
    print(*[('manager' , 'id' , 'vehicle' , 'd_city' , 's_city' , 's_country' , 'd_country')])
    condition_field = input('Enter the condition field () : ')
    condition = input("enter filter")
    my_query += 'AND '
    my_query += condition_field + ' ' + condition

print(*query(my_query,0))
    

    