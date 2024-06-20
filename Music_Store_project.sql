create database music_store;
 use music_store;
 
 show tables;
 
/* ---------------------------  Question Set 1 - Easy ----------------------*/
                                
-- 1. Who is the senior most employee based on job title?

	select first_name, last_name, levels 
	from employee
	order by levels desc
	limit 1;

-- 2. Which countries have the most Invoices?

	select billing_country, count(*) as c from invoice
	group by billing_country
	order by c desc;

-- 3. What are top 3 values of total invoice?

	select round(total,3) as total from invoice
	order by total desc
	limit 3;

/*-- 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals.
-- Return both the city name & sum of all invoice totals */

	select billing_city, round(sum(total),3) as total_sum from invoice
    group by billing_city
    order by total_sum desc 
    limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money

	select * from customer;
	select * from invoice;
	
    select c.customer_id, c.first_name, c.last_name, round(sum(i.total),2) as money_spend
    from customer c
    inner join invoice i
    on c.customer_id = i.customer_id
    group by c.customer_id, c.first_name,c.last_name
    order by money_spend desc
    limit 1;
    
    /* ------------------- Question Set 2 – Moderate ------------------------- */
    
-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A

	select distinct c.email, c.first_name, c.last_name from customer c
    inner join invoice iv
		using (customer_id)
    inner join invoice_line ivl
		using (invoice_id)
    where track_id in (
		select t.track_id from track t
		inner join genre g
		on t.genre_id = g.genre_id
		where g.name like "Rock")
    order by email asc;
    
    /*   method-2 */
    
    select distinct c.email, c.first_name, c.last_name from customer c
    inner join invoice iv
		using (customer_id)
    inner join invoice_line ivl
		using (invoice_id)
	inner join track t
		using (track_id)
	inner join genre g
		using (genre_id)
	where g.name = 'rock'
    order by email asc;
    
-- 2. Let's invite the artists who have written the most rock music in our dataset.
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

	select ar.artist_id, ar.name, count(ar.artist_id) as trackcount from artist ar
    inner join album al
		using (artist_id)
    inner join track t
		using (album_id)
	inner join genre g
		using (genre_id)
	where g.name like 'rock'
	group by ar.artist_id,ar.name
    order by trackcount desc
    limit 10;
    
-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select * from track;
	
    select name, milliseconds from track
    where milliseconds >
    (select avg(milliseconds) from track)
    order by milliseconds desc; 
    
	/* ------------------- Question Set 3 – Advance ------------------------------ */


-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

	select concat(c.first_name,'  ',c.last_name) as customer_name,ar.name as artist_name, 
    round(sum(iv.total),3) as money_spend
    from customer c
    inner join invoice iv
		using (customer_id)
    inner join invoice_line ivl
		using (invoice_id)
	inner join track t
		using (track_id)
	inner join album ab
		using (album_id)
	inner join artist ar
		using (artist_id)
	group by customer_name, artist_name
    order by money_spend desc;

-- 2. We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

	with popular_genre as
	(
		select count(invoice_line.quantity) as purchase, customer.country, genre.name, genre.genre_id,
		row_number() over(partition by customer.country order by count(invoice_line.quantity) DESC) as rn from customer 
		join invoice using (customer_id)
		join invoice_line using (invoice_id)
		join track using (track_id)
		join genre using (genre_id)
		group by customer.country, genre.name, genre.genre_id
		order by 2 ASC
    )
    select * from popular_genre where rn = 1;
   
   
-- 3. Write a query that determines the customer that has spent the most on music for each country.
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount

	with customer_country as 
	(
    select c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as money_spent, 
    row_number() over(partition by i.billing_country order by sum(i.total) desc) as rn from customer c 
    join invoice i using (customer_id)
    group by c.customer_id, c.first_name, c.last_name, i.billing_country
    order by i.billing_country asc, money_spent desc
    )
    select * from customer_country where rn = 1;
    
   