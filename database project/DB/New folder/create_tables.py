import pyodbc
connection = pyodbc.connect('Driver={SQL Server};'
                      'Server=LAPTOP-K7OUA5O9\ABCD;'
                      'Database=mid_night_project;'
                      'Trusted_Connection=yes;')

cursor =  connection.cursor()

def Create_Table_Users(cursor):
        query = """ CREATE TABLE  users (
                        id INT PRIMARY KEY,
                        fullname TEXT,
                        phonenumber TEXT,
                        OTP int,
                        otp_expire TIMESTAMP,
                        email TEXT,
                        password TEXT
        );"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Super_admin(cursor):
        query = """ CREATE TABLE  super_admin (
                        id INT PRIMARY KEY,
                        fullname TEXT,
                        phonenumber TEXT,
                        OTP int,
                        otp_expire TIMESTAMP,
                        email TEXT,
                        password TEXT
        );"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Coupon(cursor):
        query = """ CREATE TABLE  coupon (
                        id INT PRIMARY KEY,
                        amount int,
                        limit int
        );"""

def Create_Table_passenger(cursor):
        query = """ CREATE TABLE  PASSENGER (
                        id INT PRIMARY KEY,
                        fullname TEXT,
                        phonenumber TEXT,
                        OTP int,
                        otp_expire TIMESTAMP,
                        email TEXT,
                        password TEXT,
                        coupon_id INT
        );"""

        #query = """ CREATE TABLE  passenger (
       #         coupon_id INT         
       # ) INHERITS (users);"""
        cursor.execute(query)
        connection.commit()

def Create_Table_manager(cursor):
        query = """ CREATE TABLE  MANAGER (
                        id INT PRIMARY KEY,
                        fullname TEXT,
                        phonenumber TEXT,
                        OTP int,
                        otp_expire TIMESTAMP,
                        email TEXT,
                        password TEXT
        );"""
        
        cursor.execute(query)
        connection.commit()


def Create_Table_Message(cursor):
        query = """
                CREATE TABLE  message (
                id INT PRIMARY KEY,
                chat_id int,
                direction INT,
                data TEXT,
                time TIMESTAMP,
                status INT               
        ); """
        cursor.execute(query)
        connection.commit()

def Create_Table_Chat(cursor):
        query = """ CREATE TABLE  chat (
                id INT PRIMARY KEY,
                id_super_admin int,
                id_pOrM int
        );"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Ticket(cursor):
        query = """ CREATE TABLE  ticket (
                id INT PRIMARY KEY,
                status TEXT,
                price int,
                rate int,
                travel INT FOREIGN KEY REFERENCES travel (id) ,
                id_passenger INT FOREIGN KEY REFERENCES passenger (id)
        );"""
        cursor.execute(query)
        connection.commit()
        
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
        cursor.execute(query)
        connection.commit()
        
        
        
        

# Create_Table_Users(cursor)
# Create_Table_Super_admin(cursor)
# Create_Table_Coupon(cursor)
# Create_Table_passenger(cursor)
# Create_Table_manager(cursor)
# Create_Table_Message(cursor)
# Create_Table_Chat(cursor)
# Create_Table_travel(cursor)
# Create_Table_Ticket(cursor)
