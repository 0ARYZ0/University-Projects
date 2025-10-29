import pyodbc
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=LAPTOP-K7OUA5O9\ABCD;'
                      'Database=mid_night_project;'
                      'Trusted_Connection=yes;')

cursor =  conn.cursor()
maxId = (list(cursor.execute('SELECT MAX(Id) FROM travel'))[0][0])
maxId = maxId if maxId else 0
def query (s,commit=1) :
    print(s)
    res = cursor.execute(s)
    if commit: conn.commit()
    else:
        return list(res)
