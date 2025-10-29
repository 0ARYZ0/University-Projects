import psycopg2
from datetime import datetime

import create_tables
import chating
import super_admin
import passenger
           
def Go_to_chat(cursor, chat_id):
    query = f""" SELECT * FROM message  
                WHERE message.chat_id = {chat_id};
    """
    cursor.execute(query)
    connection.commit()

try:
        connection = psycopg2.connect(
                host = "localhost",
                database= "postgres",
                user= "postgres",
                password ="mahdi")

        cursor = connection.cursor()

        #print(connection.get_dsn_parameters())
        #cursor.execute("Select version();")
        #record = cursor.fetchone()
        #print("You are connected to - ", record, "\n")
        
        
        # Create_Table_Users(cursor)
        # Create_Table_Super_admin(cursor)
        # Create_Table_Chat(cursor)
        # Create_Table_Message(cursor)
        #Send_message_SuperAdmin(cursor,"test", 0)
        #New_Chat(cursor, 1)
        # Answering_a_chat(cursor, 1, 4)
        # Find_Unanswered_chats(cursor)
        
        
        
        # record = cursor.fetchall()
        # print(record)
        

except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")