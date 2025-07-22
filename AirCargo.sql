use aircargo;
select * from customer;
select * from ticket_details;
select * from passengers_on_flights;
select * from routes;

-- #Q1 Write a query to display all the passengers who have traveled on routes 01 to 25 from the passengers_on_flights table.
select * from passengers_on_flights
where route_id between  1 and 25
order by route_id;

-- #Q2 Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
select sum(no_of_tickets) as Total_Passenger, sum(no_of_tickets * Price_per_ticket) as Total_Revenue
from ticket_details
where class_id = "Business";

-- #Q3 Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
select concat(first_name," ", last_name)
from customer;

-- #Q4 Write a query to extract the customers who have registered and booked a 
-- ticket from the customer and ticket_details tables. 
select t.customer_id, c.first_name, c.last_name, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id;

-- #Q5 Write a query to identify the customer’s first name and last name based 
-- on their customer ID and brand (Emirates) from the ticket_details table. 
select t.customer_id, c.first_name, c.last_name, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id
where t.brand = "Emirates";

-- #Q6 Write a query to identify the customers who have traveled by Economy 
-- Plus class using the sub-query on the passengers_on_flights table.
select customer_id, first_name, last_name
from customer
where customer_id in (select customer_id 
      from passengers_on_flights 
      where class_id = "Economy Plus");
      
-- #Q7 Write a query to determine whether the revenue has crossed 10000 using 
-- the IF clause on the ticket_details table. 
select sum(Price_per_ticket * no_of_tickets) as Revenue, if(sum(Price_per_ticket * no_of_tickets) >= 10000, 'Yes', 'No') as Revenuecheck
from ticket_details;

-- #Q8 Write a query to create and grant access to a new user to perform database operations.
create user 'Deepak'@'localhost' identified by 'Deepak!123';
grant select, insert, update, delete on aircargo.* 
to 'Deepak'@'localhost';

-- #Q9 Write a query to find the maximum ticket price for each class using 
-- window functions on the ticket_details table. 
select distinct(class_id),  max(Price_per_ticket) over (partition by class_id order by Price_per_ticket DESC) as MaxPrice
from ticket_details;

-- #Q10 Write a query to extract the passengers whose route ID is 4 by improving 
-- the speed and performance of the passengers_on_flights table using the index. 
create index route on passengers_on_flights(route_id);
select * 
from passengers_on_flights
where route_id = 4;
explain select * from passengers_on_flights
where route_id = 4;
-- #Q11 For route ID 4, write a query to view the execution plan of the passengers_on_flights table.
explain
select * 
from passengers_on_flights
where route_id = 4;

-- #Q12 Write a query to calculate the total price of all tickets booked by a 
-- customer across different aircraft IDs using the rollup function. 
select customer_id, aircraft_id, sum(no_of_tickets * Price_per_ticket) As TotalPrice
from ticket_details
group by customer_id, aircraft_id with rollup ;

-- #Q13 Write a query to create a view with only business class customers and the airline brand.
create view BusinessClass as
select t.customer_id,  concat(c.first_name," ", c.last_name) as CustomerName, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id
where class_id = 'Business';

select * from BusinessClass;

-- #Q14 Write a query to create a stored procedure that extracts all the details 
-- from the routes table where the traveled distance is more than 2000 miles.
delimiter //
create procedure TraveledDist (In miles INT)
begin
select * from routes
where distance_miles > miles;
end//
delimiter ;

call TraveledDist(2000);

-- #Q15 Using GROUP BY, determine the total number of tickets purchased by each customer and the total price paid.
select customer_id, count(no_of_tickets) as TotalTicket, sum(Price_per_ticket * no_of_tickets) as TPP
from ticket_details
group by customer_id
order by customer_id;
 
-- #Q16 Calculate the average distance and average number of passengers per 
-- aircraft, considering only those routes with more than one departure date.

-- Step 1: Find routes with more than one departure date
WITH multi_departure_routes AS (
    SELECT 
        route_id
    FROM 
        passengers_on_flights
    GROUP BY 
        route_id
    HAVING 
        COUNT(DISTINCT travel_date) > 1
)
-- Step 2: Join and aggregate
SELECT
    r.aircraft_id,
    AVG(r.distance_miles) AS avg_distance,
    AVG(passenger_count) AS avg_passengers_per_route
FROM
    routes r
    INNER JOIN multi_departure_routes mdr ON r.route_id = mdr.route_id
    LEFT JOIN (
        SELECT 
            route_id,
            COUNT(*) AS passenger_count
        FROM 
            passengers_on_flights
        GROUP BY 
            route_id
    ) pf ON r.route_id = pf.route_id
GROUP BY
    r.aircraft_id;