# -------- create the Database --------- #
create database Walmart ;

use walmart;

select * from walmart_sales;

# ----------------------------------- Data Cleaning  ---------------------
# Rename the table name 
	ALTER TABLE `walmartsalesdata.csv` RENAME TO  walmart_sales;
    
#  ----------- find the day name ? -----------
	select dayname(date)  from walmart_sales;

#  ---------- Add column Day_name --------------
	alter table walmart_sales add column Day_name varchar(20);

# ------- update the column with day_name ----------
	update walmart_sales set Day_name = dayname(date);

# ------- find the name of the month ? ------------
	select monthname(date) from walmart_sales;

# ------- Add month name column --------------
	alter table walmart_sales 
		add column month_name varchar(20);
        
# ------ Update the month name in that column ---------
	update walmart_sales set month_name = monthname(date);

# ------- find the time of the day ? ---------------
select time, (case when time between "00:00:00" and "12:00::00" then "Morning" 
when time between "12:01:00" and "16:00:00" then "Afternoon" 
else "Evening"  end ) as time_of_day from walmart_sales; 

# ----------------- add the column time of the day -----------------
alter table walmart_sales add time_of_day varchar(20);

# -------------- update the column values with time of the day ------------
update walmart_sales set time_of_day = (case when time between "00:00:00" and "12:00::00" then "Morning" 
when time between "12:01:00" and "16:00:00" then "Afternoon" 
else "Evening"  end ) ;

# ---- Rename the column names --------#
alter table walmart_sales rename column `Tax 5%` to tax;
alter table walmart_sales rename column `Product line` to product_line;
alter table walmart_sales rename column `Customer type` to customer_type;
alter table walmart_sales rename column `Unit price` to unit_price;

select * from walmart_sales;

# ----------------------------------------------- Business Questions To Answer ----------------------------------------------------- #
# -------------- Generic Question ---------------#

# 1. How many unique cities does the data have? 
	select distinct City from walmart_sales;
    
# 2. In which city is each branch?
	select distinct City, branch from walmart_sales;

select * from walmart_sales;

/*------------------------------------------------------------------------------------------------
----------------------------------------    Product    ------------------------------------------
--------------------------------------------------------------------------------------------------*/

-- How many unique product lines does the data have?
	select `Product line` from walmart_sales;

-- What is the most common payment method?
	select payment,count(payment) from walmart_sales
		group by payment ;

-- What is the most selling product line?
	select `Product line`, sum(quantity) from walmart_sales
		group by `Product line`
        order by sum(quantity) desc;
    
-- What is the total revenue by month?
	select month_name, round(sum(total),2) as total_rev from walmart_sales
		group by month_name
        order by total_rev desc;

-- What month had the largest COGS?
	select month_name, round(sum(cogs),2) as large from walmart_sales
		group by month_name
		order by large desc;
        
-- What product line had the largest revenue?
	select product_line, round(sum(total),2) as total_rev from walmart_sales
		group by product_line
        order by total_rev desc;

-- What is the city with the largest revenue?
	select city, round(sum(total),2) as total_rev from walmart_sales
		group by city
        order by total_rev desc;

-- What product line had the largest VAT?
	select product_line, round(avg(tax),2) as largest_vat from walmart_sales
		group by product_line
		order by largest_vat desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
	select avg(quantity) from  walmart_sales;  
    
    select product_line, (case when avg(quantity) > 6 then "Good"
		else "Bad" end) as remark from walmart_sales
		group by product_line;
    
-- Which branch sold more products than average product sold?
select * from walmart_sales;

	select branch, sum(quantity) as qty from walmart_sales
		group by branch
			having qty > avg(quantity);

-- What is the most common product line by gender?
select gender, product_line, count(gender) from walmart_sales
	group by gender, product_line
    order by count(gender) desc;

-- What is the average rating of each product line?
	select product_line, round(avg(rating),2) as avg_rating from walmart_sales
		group by product_line
		order by avg_rating;

/*------------------------------------------------------------------------------------------------
----------------------------------------      Sales     ------------------------------------------
--------------------------------------------------------------------------------------------------*/

-- Number of sales made in each time of the day per weekday
	select * from walmart_sales;

	select time_of_day, count(*) total_sales from walmart_sales
		where day_name not in ("sunday", "saturday")
			group by time_of_day
				order by total_sales desc;
    
-- Which of the customer types brings the most revenue?
	select customer_type, round(sum(total),2) as total_rev from walmart_sales
		group by customer_type
			order by total_rev desc;
	
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
	select city, round(avg(tax),2) as tax from walmart_sales
		group by city
		order by tax;

-- Which customer type pays the most in VAT?
	select customer_type, round(avg(tax),2) as total_tax from walmart_sales
		group by customer_type
        order by total_tax desc;

/*------------------------------------------------------------------------------------------------
----------------------------------------    Customer    ------------------------------------------
--------------------------------------------------------------------------------------------------*/

-- How many unique customer types does the data have?
	select distinct(customer_type) from walmart_sales;

-- How many unique payment methods does the data have?
	select distinct(payment) from walmart_sales;

-- What is the most common customer type?
	select customer_type, count(*) as count from walmart_sales
		group by customer_type
        order by count desc;
    
-- Which customer type buys the most?
	select customer_type, count(*) from walmart_sales
		group by customer_type;
    
-- What is the gender of most of the customers?
	select gender, count(*) as gender_count from walmart_sales
		group by gender
        order by gender_count desc;

-- What is the gender distribution per branch?
    select branch, count(gender) as gender_count from walmart_sales
    group by branch
    order by gender_count desc;

-- Which time of the day do customers give most ratings?	
	select time_of_day, round(avg(rating),2) as avg_rating from walmart_sales
		group by time_of_day
        order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?
	select  time_of_day, count(branch) as branch_count from walmart_sales
    group by time_of_day
    order by branch_count desc;

-- Which day fo the week has the best avg ratings?
	select day_name, round(avg(rating),3) as avg_rating from walmart_sales
		group by day_name
        order by avg(rating) desc;

-- Which day of the week has the best average ratings per branch?
	select day_name, branch, round(avg(rating),2) as avg_rating from walmart_sales
		group by day_name, branch
        order by avg_rating desc;
