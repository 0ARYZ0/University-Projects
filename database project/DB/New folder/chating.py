def Send_message_SuperAdmin(cursor, message,chat_id):
        time = datetime.now()
        query = f""" INSERT INTO message(chat_id, direction, data, time, status)
                        VALUES({chat_id}, true, '{message}', '{time}', false);
        """
        cursor.execute(query)
        connection.commit()

def Send_message_Normal(cursor, message, chat_id):
        time = datetime.now()
        query = f""" INSERT INTO message(chat_id, direction, data, time, status)
                        VALUES({chat_id}, false, '{message}', '{time}', false);
        """
        cursor.execute(query)
        connection.commit()