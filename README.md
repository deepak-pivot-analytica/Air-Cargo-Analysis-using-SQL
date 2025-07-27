# Air-Cargo-Analysis-using-SQL
**Overview**
analyze and optimize data for Air Cargo, an aviation company, to improve the customer experience and operational efficiency. Focus will be on identifying regular customers, analyzing the busiest routes, and preparing ticket sales details.

**Situation**
Air Cargo provides air transportation services for passengers and freight. The company aims to enhance customer satisfaction and operational efficiency. To achieve this, they must identify regular customers for personalized offers, analyze the busiest routes to optimize aircraft allocation, and prepare detailed ticket sales reports.

**Input Dataset**

**Customer: Contains the information of customers**

● customer_id – ID of the customer

● first_name – First name of the customer

● last_name – Last name of the customer

● date_of_birth – Date of birth of the customer

● gender – Gender of the customer

**passengers_on_flights: Contains information about the travel details**

● aircraft_id – ID of each aircraft in a brand

● route_id – Route ID of the from and to location

● customer_id – ID of the customer

● depart – Departure place from the airport

● arrival – Arrival place in the airport

● seat_num – Unique seat number for each passenger

● class_id – ID of the travel class

● travel_date – Travel date of each passenger

● flight_num – Specific flight number for each route

**ticket_details: Contains information about the ticket details**

● p_date – Ticket purchase date

● customer_id – ID of the customer

● aircraft_id – ID of each aircraft in a brand

● class_id – ID of travel class

● no_of_tickets – Number of tickets purchased

● a_code – Code of each airport

● price_per_ticket – Price of a ticket

● brand – Aviation service provider for each aircraft

**routes: Contains information about the route details**

● Route_id – Route ID of from and to location

● Flight_num – Specific fight number for each route

● Origin_airport – Departure location

● Destination_airport – Arrival location

● Aircraft_id – ID of each aircraft in a brand

● Distance_miles – Distance between departure and arrival location

**Task**
1.Create an ER diagram for the given airlines' database

<img width="624" height="282" alt="image" src="https://github.com/user-attachments/assets/7dfd1558-1215-4a63-9256-3e445508d5b6" />

2.Write a query to display all the passengers who have traveled on routes 01 to 25 from the passengers_on_flights table.

Query:

<pre>
select * from passengers_on_flights

where route_id between  1 and 25

order by route_id;
</pre>

Q4. Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
Query:
<pre>
select sum(no_of_tickets) as Total_Passenger, sum(no_of_tickets * Price_per_ticket) as Total_Revenue
from ticket_details
where class_id = "Business";
</pre>

Q5. Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
Query:
<pre>
select concat(first_name," ", last_name)
from customer;
</pre>

Q6. Write a query to extract the customers who have registered and booked a ticket from the customer and ticket_details tables.
Query:
<pre>
select t.customer_id, c.first_name, c.last_name, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id;
</pre>

Q7. Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
Query:
<pre>
select t.customer_id, c.first_name, c.last_name, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id
where t.brand = "Emirates";
</pre>

Q8. Write a query to identify the customers who have traveled by Economy Plus class using the sub-query on the passengers_on_flights table.
Query:
<pre>
select customer_id, first_name, last_name
from customer
where customer_id in (select customer_id 
      from passengers_on_flights 
      where class_id = "Economy Plus");
</pre>

Q9. Write a query to determine whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
Query:
<pre>
select sum(Price_per_ticket * no_of_tickets) as Revenue, if(sum(Price_per_ticket * no_of_tickets) >= 10000, 'Yes', 'No') as Revenuecheck
from ticket_details;
</pre>

Q10. Write a query to create and grant access to a new user to perform database operations
Query:
<pre>
create user 'Deepak'@'localhost' identified by 'Deepak!123';
grant select, insert, update, delete on aircargo.* 
to 'Deepak'@'localhost';
</pre>
Q11. Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.
Query:
<pre>
select distinct(class_id),  max(Price_per_ticket) over (partition by class_id order by Price_per_ticket DESC) as MaxPrice
from ticket_details;
</pre>

Q12. Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table using the index.
Query:
<pre>
create index route on passengers_on_flights(route_id);
select * 
from passengers_on_flights
where route_id = 4;
</pre>

Q13. For route ID 4, write a query to view the execution plan of the passengers_on_flights table.
Query:
<pre>
select * 
from passengers_on_flights
where route_id = 4;
</pre>

Q14. Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using the rollup function.
Query:
<pre>
select customer_id, aircraft_id, sum(no_of_tickets * Price_per_ticket) As TotalPrice
from ticket_details
group by customer_id, aircraft_id with rollup ;
</pre>

Q15. Write a query to create a view with only business class customers and the airline brand.
Query:
<pre>
create view BusinessClass as
select t.customer_id,  concat(c.first_name," ", c.last_name) as CustomerName, t.brand
from ticket_details as t
inner join customer as c
on t.customer_id = c.customer_id
where class_id = 'Business';
</pre>


Q16. Write a query to create a stored procedure that extracts all the details from the routes table where the traveled distance is more than 2000 miles.
Query:
<pre>
For creating Stored Procedure
delimiter //
create procedure TraveledDist (In miles INT)
begin
select * from routes
where distance_miles > miles;
end//
delimiter ;

-- To call the Procedure
call TraveledDist(2000);
</pre>

Q17. Using GROUP BY, determine the total number of tickets purchased by each customer and the total price paid.
Query:
<pre>
select customer_id, count(no_of_tickets) as TotalTicket, sum(Price_per_ticket * no_of_tickets) as TPP
from ticket_details
group by customer_id
order by customer_id;
</pre>
Q18. Calculate the average distance and average number of passengers per aircraft, considering only those routes with more than one departure date.
Query:
<Pre>-- Step 1: Find routes with more than one departure date
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
</Pre>
