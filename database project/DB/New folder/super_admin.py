def add_super_admin(cursor, full_name, phone_number, email, password):
    password = hash(password)
    query = f""" INSERT INTO super_admin(fullname, phonenumber, email, password)
                    VALUES('{full_name}', '{phone_number}', '{email}', '{password}');
    """
    cursor.execute(query)
    connection.commit()
    
def Answering_a_chat(cursor, id_super_admin, chat_id):
        query = f""" UPDATE CHAT
                        SET id_super_admin = {id_super_admin}
                        WHERE ID = {chat_id};
        """
        cursor.execute(query)
        connection.commit()
        
def Current_Chats_super_admin(cursor, id_super_admin):
        query = """ SELECT chat.id
                        FROM chat JOIN super_admin ON chat.id_super_admin = super_admin.id;  
        """
        cursor.execute(query)
        connection.commit()
        
def Find_Unanswered_chats(cursor):
        query = """ SELECT * FROM CHAT
                        WHERE "id_super_admin" IS NULL;
        """
        cursor.execute(query)
        connection.commit()
        
