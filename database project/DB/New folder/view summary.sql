CREATE VIEW [ticket_summary]  as
select  
travel.id , 
count(*) as ticket_count , 
AVG(ticket.rate) as rate_AVG ,
sum(ticket.price) as sum_price 

from travel 
INNER JOIN ticket ON travel.ID =  ticket.travel

where ticket.status LIKE 'COMPLETED'

GROUP BY travel.ID   
