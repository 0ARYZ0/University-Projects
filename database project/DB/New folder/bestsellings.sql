select travel.id as travel_ID , sum_price 
from travel INNER JOIN ticket_summary ON travel.id = ticket_summary.id  
WHERE
manager = 0 