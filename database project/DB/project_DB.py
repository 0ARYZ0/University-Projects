import psycopg2


conn = psycopg2.connect(
    host="localhost",
    database="DB",
    user="postgres",
    password="Abcd1234")

cur = conn.cursor()

def create_panel(passenger_id):
    cur.execute("SELECT name, email, phone FROM passengers WHERE id = %s", (passenger_id,))
    result = cur.fetchone()
    if result:
        name, email, phone = result
        print(f"Welcome {name}!")
        print(f"Your email is {email}")
        print(f"Your phone is {phone}")
    else:
        print("Invalid passenger id")

# Define a function to reserve a ticket for a passenger
def reserve_ticket(passenger_id, ticket_id):
    cur.execute("SELECT price, status FROM tickets WHERE id = %s status = available ", (ticket_id,))
    result = cur.fetchone()
    if result:
        price, status = result
        if status == "available":
            cur.execute("INSERT INTO ticket (passenger_id, ticket_id, price, status) VALUES (%s, %s, %s, %s)", (passenger_id, ticket_id, price, 'reserved'))
            conn.commit()
            print(f"You have reserved ticket {ticket_id} for {price}")
        else:
            print("Sorry, this ticket is not available")
    else:
        print("Invalid ticket id")

# Define a function to order a ticket for a passenger with an optional discount code
def order_ticket(passenger_id, ticket_id, coupon_id=None):
    cur.execute("SELECT ticket_id, price, status FROM ticket WHERE id = %s AND passenger_id = %s", (ticket_id, passenger_id))
    result = cur.fetchone()
    if result:
        ticket_id, price, status = result
        if status == 'reserved':
            final_price = price
            if coupon_id:
                cur.execute("SELECT amount FROM passenger WHERE code = %s", (coupon_id,))
                discount_result = cur.fetchone()
                if discount_result:
                    amount, limit = discount_result
                    discounted_price = price - (price * amount)
                    if price*amount > limit:
                        discounted_price = price - limit
                    final_price = discounted_price
                    print(f"You have applied discount code {coupon_id} and saved {amount}")
                     
                else:
                    print("Invalid discount code")
            cur.execute("UPDATE ticket SET price = %s, status = %s WHERE id = %s AND passenger_id = %s", (final_price, 'ordered', ticket_id, passenger_id))
            conn.commit()
            print(f"You have ordered ticket {ticket_id} for {final_price}")
        else:
            print("Sorry, you can only order a reserved ticket")
    else:
        print("Invalid order id or passenger id")

def pay_ticket(passenger_id, ticket_id):
    cur.execute("SELECT ticket_id, price, status FROM ticket WHERE id = %s AND passenger_id = %s", (ticket_id, passenger_id))
    result = cur.fetchone()  
    if result:
        ticket_id, price, status = result
        if status == 'ordered':
            print(f"Processing payment for ticket {ticket_id} for {price}...")
            cur.execute("UPDATE ticket SET status = %s WHERE id = %s AND passenger_id = %s", ('paid', ticket_id, passenger_id))
            conn.commit()
            print(f"You have paid for ticket {ticket_id}")
        else:
            print("Sorry, you can only pay for an ordered ticket")
    else:
        print("Invalid order id or passenger id")

# Define a function to track the order status for a passenger
def track_order(passenger_id, ticket_id):
    cur.execute("SELECT ticket_id, status FROM ticket WHERE id = %s AND passenger_id = %s", (ticket_id, passenger_id))
    result = cur.fetchone()
    if result:
        ticket_id, status = result
        print(f"Your order for ticket {ticket_id} is {status}")
    else:
        print("Invalid order id or passenger id")


def search_tickets(source=None, destination=None, date=None, rating=None, price=None):
    params = []
    conditions = ""
    if source:
        params.append(source)
        conditions += "source = %s"
    if destination:
        params.append(destination)
        if conditions:
            conditions += " AND "
        conditions += "destination = %s"
    if date:
        params.append(date)
        if conditions:
            conditions += " AND "
        conditions += "date = %s"
    if rating:
        params.append(rating)
        if conditions:
            conditions += " AND "
        conditions += "rating >= %s"
    if price:
        params.append(price)
        if conditions:
            conditions += " AND "
        conditions += "price <= %s"
    if params:
        params = tuple(params)
        query = "SELECT id, source, destination, date, price, rating FROM tickets WHERE " + conditions
        cur.execute(query, params)
        results = cur.fetchall()
        if results:
            print("Search results:")
            for result in results:
                id, source, destination, date, price, rating = result
                print(f"Ticket {id}: {source} to {destination} on {date} for {price} with rating {rating}")
        else:
            print("No tickets found with your search criteria")
    else:
        print("Please provide at least one parameter to search for tickets")

def rate_travel(passenger_id, ticket_id, rating):
    if rating >= 1 and rating <= 5:
        cur.execute("SELECT ticket_id, status FROM orders WHERE id = %s AND passenger_id = %s", (ticket_id, passenger_id))
        result = cur.fetchone()
        if result:
            ticket_id, status = result
            if status == 'paid':
                cur.execute("INSERT INTO ratings (passenger_id, ticket_id, rating) VALUES (%s, %s, %s)", (passenger_id, ticket_id, rating))
                conn.commit()
                print(f"You have rated ticket {ticket_id} with {rating} stars")
            else:
                print("Sorry, you can only rate a paid ticket")
        else:            print("Invalid order id or passenger id")
    else:
        print("Invalid rating. Please enter a number between 1 and 5")


conn.close()