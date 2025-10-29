def add_passenger(cursor, full_name, phone_number, email, password):
    password = hash(password)
    query = f""" INSERT INTO super_admin(fullname, phonenumber, email, password)
                    VALUES('{full_name}', '{phone_number}', '{email}', '{password}');
    """
    cursor.execute(query)
    connection.commit()

def Create_panel(cursor, id):
    query = f""" SELECT full_name, phone_number, email, password
                 FROM passenger
                 WHERE passenger.id = {id};
    """
    cursor.execute(query)
    connection.commit()

def New_Chat_passenger(cursor,  id_pOrM):
        query =  f""" INSERT INTO chat ( id_pOrM) 
                        VALUES( {id_pOrM});
        """ 
        cursor.execute(query)
        connection.commit()
        
def Current_Chats_passenger(cursor, id_super_admin):
        query = """ SELECT chat.id
                        FROM chat JOIN passenger ON chat.id_pOrM = passenger.id;
        """
        cursor.execute(query)
        connection.commit()
#search for the available tickets
def See_Available_Tickets(cursor, min_price, max_price):
    query =f""" SELECT price, rating, d_city, d_country, s_city, s_country
               FROM ticket JOIN travel ON ticket.travel_id = travel.id
               WHERE ticket.status = 'available'
                    AND ticket.price < {max_price} AND ticket.price > {min_price}
               ORDER BY rating DESC;
    """
    cursor.execute(query)
    connection.commit()

def Search_Tickets_by_country(cursor, country, min_price, max_price):
    query = f""" SELECT price, rating, d_city, s_city, s_country
                 FROM ticket JOIN travel ON ticket.travel_id = travel.id
                 WHERE ticket.status = 'available' AND travel.d_country = '{country}'
                    AND ticket.price < {max_price} AND ticket.price > {min_price}
                 ORDER BY rating DESC;
    """
    cursor.execute(query)
    connection.commit()
    
def Search_Tickets_by_city(cursor, city, country, min_price, max_price):
    query = f""" SELECT price, rating, d_city, s_city, s_country
                 FROM ticket JOIN travel ON ticket.travel_id = travel.id
                 WHERE ticket.status = 'available' AND travel.d_country = '{country}' AND travel.d_city = '{city}'
                    AND ticket.price < {max_price} AND ticket.price > {min_price}
                 ORDER BY rating DESC;
    """
    cursor.execute(query)
    connection.commit()
    
# ticket_ids is a tuple
def Reserve_Ticket(cursor, ticket_ids):
    query= f"""  UPDATE ticket 
                SET status = 'reserved'
                WHERE ticket.id IN {ticket_ids};
    """
    cursor.execute(query)
    connection.commit()
    
def Buy_Ticket(cursor, ticket_ids,id_passenger):
    query=f"""  UPDATE ticket
                SET status = 'bought'
                    id_passenger = {id_passenger}
                WHERE ticket.id IN {ticket_ids};
    """
    cursor.execute(query)
    connection.commit()

def track_ticket(cursor, id_passenger):
    query = f""" SELECT * FROM ticket JOIN passenger ON ticket.id = {id_passenger};
    """
    cursor.execute(query)
    connection.commit()

def Rate_Ticket(cursor, id_passenger, ticket_ids, rate):
    query = f"""UPDATE ticket
                SET rate = {rate}
                WHERE ticket.id_passenger = id_passenger;
    """
    cursor.execute(query)
    connection.commit()