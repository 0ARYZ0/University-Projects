from my_lib import *

def Best_sellings (manager_ID) :
    return '''
    select travel.id as travel_ID , sum_price 
    from travel INNER JOIN ticket_summary ON travel.id = ticket_summary.id  
    WHERE
    manager = {manager_ID}
    order by sum_price
    '''

def Best_highest_ratings (manager_ID) :
    return  '''
    select travel.id as travel_ID , rate_AVG as rate  
    from travel INNER JOIN ticket_summary ON travel.id = ticket_summary.id  
    WHERE
    manager = {manager_ID}

    ORDER by rate 
    '''

def popularity(manager_ID) :
    return '''
    select d_country,d_city,sum(ticket_count) as popularity 
    from travel INNER JOIN ticket_summary ON travel.id = ticket_summary.id  
    WHERE
    manager = {manager_ID}
    GROUP by d_country,d_city

    order by popularity
    '''
    
def passenger_highest_total_paid_price(manager_ID) :
    return '''
    select * 
    from passenger_travel_agancy as pta 
    INNER JOIN passenger ON pta.id_passenger = passenger.id 

    where ID_manager = {manager_ID}

    order by total_paid
    
    '''
