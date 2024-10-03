USE TBMS;

SHOW TABLES;

SELECT * FROM BOOKINGS;
SELECT * FROM BUSES;
SELECT * FROM CARS;
SELECT * FROM CRUISE;
SELECT * FROM CUSTOMERDETAILS;
SELECT * FROM DESTINATION;  
SELECT * FROM EMPLOYEES;
SELECT * FROM FLIGHTS;
SELECT * FROM PAYMENTS;
SELECT * FROM TRAINS;

/* ----------------------------------------------------------------------------------------------------------------------------- */

/*  1. Update employee ID 2's position to Driver ? */
	
    update employees set emp_position = 'Driver' where employeeid = 2;
    
/*  2. Write a query to create new table CustomerTravelDoc with columns CustomerID, Full Name and Identity_proof selected from table 
	CustomerDetails */

	create table CustomerTravelDoc as select CustomerID, FullName, Identity_proof from CustomerDetails;
    select * from CustomerTravelDoc;
    
/* 3. Rename CustomerTravelDoc to Customer_documents */

	alter table CustomerTravelDoc rename Customer_documents;
	select * from Customer_documents;
    
/* 4. Add check constraint such that email of customers should end with @gmail.com */
	
	alter table customerdetails add constraint ck_email check(email like '%@gmail.com');
	SHOW CREATE TABLE customerdetails;
    
/* 5. Set default value of booking status to pending */

	alter table bookings modify column booking_status varchar(20) not null default 'Pending';
    
/* 6. Add booking with following details; BookingID: 11, CustomerID: 7, PaymentID: 111, Booking_time: 11th March 2024 1am, 
	Transport: AI103, Origin: Delhi, Destination:Chennai */  -- (before inserting the booking table data we need to insert payment table data)
    
    -- INSERT INTO Payments (PaymentID, PaymentMethod, PaymentAmount, PaymentDate, CustomerID)
	-- VALUES (111, 'Debit Card', 3000.00, NULL , 7);

    INSERT INTO Bookings (BookingID, CustomerID, PaymentID, Booking_time, Transport, Origin, Destination) VALUES 
    (11, 7, 111, '2024-03-11 01:00:00', 'AI103', 'Delhi', 'Chennai');
    
/* 7. Update the payment amounts for customers who have made payments using a credit card by increasing their payment amount by 10%.
	Include only those customers whose IDs are in the list (1, 3, 5). */
    
    update payments set paymentamount = paymentamount * 1.1 
    where paymentmethod = 'Credit Card' and customerid in (1,3,5);
    
/* 8. Display flight details of airline that starts with an A and ends with an A */

	select * from flights where airline like 'A%A';
    
/* 9. Update distance to 500 where distance = 0 and display destinations in india with distance between 500 and 1500. */

	set sql_safe_updates = 0;     -- disable safe update
    update destination set distance = 500 where distance = 0;
    
    set sql_safe_updates = 1;     -- enable safe update
    select * from destination where country = 'India' and distance between 500 and 1500;
    
/* 10. Display each destination country */

	select distinct country from destination order by country;
    
/* 11. Describe structure of booking_chahel table. */

	describe bookings;
    
/* 12. Find out details of those bookings for which origin of one booking is same as destination of another booking. */

	select b1.bookingid as origin_bookingid , b1.customerid as origin_custid, b1.booking_status as origin_sataus, b1.origin,
    b2.bookingid as dest_bookingid , b2.customerid as dest_custid, b2.booking_status as dest_sataus, b2.destination
    from bookings b1
    join bookings b2 on b1.origin = b2.destination;
    
/* 13. Display details of various modes of transport available to go to Singapore */

	select distinct d.destinationname as destination, 
    t.trainname as train,
    b.busnumber as bus, flightnumber as flight, cu.cruisename as cruise from destination d
    left join trains t using(destinationid)
	left join buses b using (destinationid)
    left join flights f using(destinationid)
    left join cruise cu using (destinationid)
    where d.destinationname = 'singapore';

/* 14. Display booking and customer details of customers who paid via credit card */

	select * from bookings b
    join customerdetails d 
    on b.customerid = d.customerid
    join payments p
    on b.customerid = p.customerid
    where p.paymentmethod = 'credit card';
    
/* 15. Display payment and customer details in order of most expensive trip booked to cheapest trip. */ 

	select c.customerid, c.fullname,c.email,c.phone,c.identity_proof, p.paymentamount from customerdetails c 
    join payments p 
    on c.customerid = p.customerid
    order by p.paymentamount desc;
    
/* 16. How many flights fly in and out of Mumbai? */

	select count(*) as Cnt_flight from flights
    where fl_origin = 'mumbai' or fl_destination = 'mumbai';
    
/* 17. Retrieve maximum and minimum salary of employee for each department */

	select  department, min(emp_salary) as min_sal, max(emp_salary) as max_sal
	from employees
	group by department;
    
/* 18. Find destinations that have both train and flight services. Also, find destinations that have bus services but not car services. */

	select distinct t_destination from trains t
    join flights f
    on t.destinationid = f.destinationid;
    
    select b_destination from buses 
    where b_destination not in (select c_destination from cars);
    
/* 19. Find the total number of bookings made by each customer and display only those customers who made 2 or more bookings. */

	select customerid, count(*) as cnt from bookings
    group by customerid
    having cnt >=2;
    
/* 20. Retrieve total income by Travel Booking system. */ 

	select sum(paymentamount) as total_amount from payments;
    
/* 21. Create a view that provides a summary of booking statistics, such as the total number of bookings, 
	the total amount paid, and the average booking amount. */
    
    Create view booking_summary as select count(*) as total_booking, sum(p.paymentamount) as total_amount_paid,
    avg(p.paymentamount) as avg_amount_paid from bookings b
    join payments p 
    on b.paymentid = p.paymentid;
    select * from booking_summary;
    
/* 22. Create a view showing the number of bookings made for each destination. */
	
    create view destination1 as select destination, count(*) from bookings
    group by destination;
    select * from destination1;
    
/* 24. Delete booking where transport is a TrainName and then display booking table starting with null values. */

	set sql_safe_updates = 0;
    delete from bookings where transport in (select trainname from trains);

/* 25. Which mode of transport is most frequently used for bookings? */

	select transport,count(*) from bookings
    group by transport
    order by count(*) desc
    limit 1;
    
    
    