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

select * from passengers_on_flights

where route_id between  1 and 25

order by route_id;

