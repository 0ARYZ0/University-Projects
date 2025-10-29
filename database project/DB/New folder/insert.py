from my_lib import query,conn,maxId
maxid = maxId
def insert(agency,date,time,vType,dest,src):
    global maxid
    try:
        if not (lambda date : all([len(date[0]) == 4,len(date[1]) == 2,len(date[2]) == 2 ,-1 < int(date[1])  < 13 , -1 < int(date[2]) < 32] ))(date.split('-')):
            raise TypeError('Date')
    except:
        raise TypeError('Date')
    
    
    try:
        if not (lambda time : all([len(x) == 2 for x in time]+[-1 < int(time[0])  < 25 , -1 < int(time[1]) < 61 , -1 < int(time[2]) < 61 ] ))(time.split(':')):
            raise TypeError('Time')
    except:
        raise TypeError('Time')
    
    if not vType in ["CAR","BUS","AIRPLANE"]:
        raise TypeError('vehichle_type')
    
    if not dest:
        raise TypeError('destination')
    
    if not src:
        raise TypeError('source')
    
    def Create_Table_travel(cursor):
        query = """ CREATE TABLE  travel (
                id INT PRIMARY KEY,
                d_country TEXT,
                d_city TEXT,
                s_country TEXT,
                s_city TEXT,
                vehicle TEXT,
                date_time TIMESTAMP ,
                manager INT FOREIGN KEY REFERENCES manager(id)
        );"""
    
    query("INSERT INTO travel (manager , id , vehicle , d_city , s_city , s_country , d_country)" + (
    f" VALUES (\'{agency}\' , {maxid + 1}  , \'{vType}\' , \'{dest}\' , \'{src}\',\'IRAN\' , \'IRAN\' )"
    ))
    maxid += 1

agency = input("Enter manager id : ")
while input("Press Enter to exit"):
    insert(*([agency] + [input('Please Enter '+i+': ') for i in ['date','time','vehicle_type','destination','source']]))
conn.close()
