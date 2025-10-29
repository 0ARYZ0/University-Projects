def Create_Table_Users(cursor):
        query = """ CREATE TABLE IF NOT EXISTS users (
                        id SERIAL PRIMARY KEY,
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
        query = """ CREATE TABLE IF NOT EXISTS super_admin (           
        ) INHERITS (users);"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Coupon(cursor):
        query = """ CREATE TABLE IF NOT EXISTS coupon
                        id SERIAL PRIMARY KEY,
                        amount int,
                        limit int
        );"""

def Create_Table_passenger(cursor):
        query = """ CREATE TABLE IF NOT EXISTS passenger (
                coupon_id INT         
        ) INHERITS (users);"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Message(cursor):
        query = """
                CREATE TABLE IF NOT EXISTS message (
                id SERIAL PRIMARY KEY,
                chat_id int,
                direction BOOLEAN,
                data TEXT,
                time TIMESTAMP,
                status BOOLEAN               
        ); """
        cursor.execute(query)
        connection.commit()

def Create_Table_Chat(cursor):
        query = """ CREATE TABLE IF NOT EXISTS chat (
                id SERIAL PRIMARY KEY,
                id_super_admin int,
                id_pOrM int
        );"""
        cursor.execute(query)
        connection.commit()

def Create_Table_Ticket(cursor):
        query = """ CREATE TABLE IF NOT EXISTS ticket (
                id SERIAL PRIMARY KEY,
                status TEXT,
                price int,
                rate int,
                id_passenger
        );"""
        cursor.execute(query)
        connection.commit()
        
def Create_Table_travel(cursor):
        query = """ CREATE TABLE IF NOT EXISTS travel (
                id SERIAL PRIMARY KEY,
                d_country TEXT,
                d_city TEXT,
                s_country TEXT,
                s_city TEXT,
                vehicle TEXT,
                date_time TIMESTAMP
        );"""
        cursor.execute(query)
        connection.commit()