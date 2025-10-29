create VIEW [passenger_travel_agancy] as 
select id_passenger , travel.manager as ID_manager

,DATEPART(YEAR,travel.date_time) as year
,DATEPART(MONTH,travel.date_time) as MONTH 
,SUM(price) as total_paid
,count(distinct d_city) as destination_count 

from travel 
INNER JOIN ticket ON travel.ID =  ticket.travel

GROUP BY id_passenger , travel.manager
,DATEPART(YEAR,travel.date_time)
,DATEPART(MONTH,travel.date_time ) 
