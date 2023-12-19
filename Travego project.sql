create database Travego

use Travego

-- Create the passenger table
CREATE TABLE passenger (
    Passenger_id INT,
    Passenger_name VARCHAR(20),
    Category VARCHAR(20),
    Gender CHAR(1),
    Boarding_City VARCHAR(20),
    Destination_City VARCHAR(20),
    Distance INT,
    Bus_Type VARCHAR(20)
);

-- Insert data into the passenger table
INSERT INTO passenger (Passenger_id, Passenger_name, Category, Gender, Boarding_City, Destination_City, Distance, Bus_Type)
VALUES
    (1, 'Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
    (2, 'Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', 700, 'Sitting'),
    (3, 'Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', 600, 'Sleeper'),
    (4, 'Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', 1500, 'Sleeper'),
    (5, 'Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', 1000, 'Sleeper'),
    (6, 'Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', 500, 'Sitting'),
    (7, 'Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', 700, 'Sleeper'),
    (8, 'Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', 500, 'Sitting'),
    (9, 'Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting');


-- Create the price table
CREATE TABLE price (
    id INT,
    Bus_type VARCHAR(20),
    Distance INT,
    Price INT
);

-- Insert data into the price table
INSERT INTO price (id, Bus_type, Distance, Price)
VALUES
    (1, 'Sleeper', 350, 770),
    (2, 'Sleeper', 500, 1100),
    (3, 'Sleeper', 600, 1320),
    (4, 'Sleeper', 700, 1540),
    (5, 'Sleeper', 1000, 2200),
    (6, 'Sleeper', 1200, 2640),
    (7, 'Sleeper', 1500, 2700),
    (8, 'Sitting', 500, 620),
    (9, 'Sitting', 600, 744),
    (10, 'Sitting', 700, 868),
    (11, 'Sitting', 1000, 1240),
    (12, 'Sitting', 1200, 1488),
    (13, 'Sitting', 1500, 1860);


select * from passenger
select * from price


--  a. How many females and how many male passengers traveled a minimum distance of 600 KMs?
		SELECT GENDER, COUNT(*) FROM passenger
        WHERE DISTANCE >= 600
        GROUP BY GENDER;

--  b. Find the minimum ticket price of a Sleeper Bus.
		SELECT BUS_TYPE, MIN(PRICE) AS MIN_PRICE FROM PRICE
		WHERE BUS_TYPE = 'SLEEPER';
        
--  c. Select passenger names whose names start with character 'S'
		SELECT  passenger_name FROM passenger where passenger_name like 'S%';
        
--  d. Calculate price charged for each passenger displaying Passenger name, Boarding City, Destination City, Bus_Type, Price in the output
		SELECT a.passenger_name,b.price, a.Boarding_City, a.Destination_City, b.Bus_Type FROM passenger a
        inner join price b
        on a.bus_type = b.bus_type;
        
        
--  e. What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in a bus?
        SELECT * FROM passenger;
		SELECT * FROM price;
        
        select a.passenger_name,b.price, b.Distance, b.bus_type FROM passenger a 
        inner join price b 
        on a.bus_type = b.bus_type 
        where b.Distance = 1000 and b.bus_type='sitting'
      
--  f. What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?

        select  a.passenger_name,a.boarding_city,a.destination_city,Sum(b.price),b.bus_type FROM passenger a 
        inner join price b 
        on a.bus_type = b.bus_type  
        where a.passenger_name = 'pallavi' and a.boarding_city ='bengaluru' and a.destination_city = 'Panaji' 
        Group by b.bus_type;
        
		select  a.passenger_name,a.boarding_city,a.destination_city,Sum(b.price),b.bus_type FROM passenger a 
        inner join price b 
        on a.bus_type = b.bus_type  
        where a.passenger_name = 'pallavi' and a.boarding_city ='Panaji' and a.destination_city = 'bengaluru' 
        Group by b.bus_type;
        
--  g. List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order.
        
        select distinct(distance) from passenger order by distance desc;
        
--  h. Display the passenger name and percentage of distance traveled by that passenger from the total distance traveled by all passengers without using user variables

		SELECT passenger_name,
		(distance / total_distance) * 100 AS percentage_distance
		FROM passenger,
		(SELECT SUM(distance) AS total_distance FROM passenger) AS total;
        
        
--  i. find the 3rd highest salary using grou by department wise
        
        select * from 
			(select salary, dense_rank() over (partition by department_id order by salary desc ) as rnk from employees) as fk 
				where rnk = 3;





