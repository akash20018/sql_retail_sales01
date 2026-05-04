use  akash;
show databases;
-- sql data retail analysis project
-- create table
create table retail_sails(
    transactions_id int primary	key,
	sale_date date,	
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy	int,
    price_per_unit float,
	cogs float,
	total_sale float

);

select* from retail_sails
limit 20;

select count(*)from retail_sails;
select* from retail_sails
where transactions_id is null;
-- data cleaning
select* from retail_sails
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or	
quantiy is  null
or
price_per_unit is null	
or
cogs is null
or
total_sale is null;

-- data exploration
-- How many sales we have?
select count(*) as total_sales from retail_sails;

-- How many customers we have?
select count(customer_id) as total_sales from retail_sails;

-- How many unique customers we have?
select count(distinct customer_id) as total_sales from retail_sails;

select distinct category from retail_sails; 

-- Data analysis & Business Key problems and answers

-- Q1. Write a sql query to retrieve all columns for sales made  on 2022-11-05

select* 
from retail_sails
where sale_date= '2022-11-05';


-- Q2.Write a sql query to retrieve  all transctions where the category 'clothing' and the quantity sold is more than 10 in month of Nov-2022

SELECT *
FROM retail_sails
WHERE category = 'clothing'
  AND sale_date > 10
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  and
  quantiy >=4;
  
  -- Q3. Write a sql query to calculate the total sales (total_sale) for each category.

SELECT category,
       SUM(total_sale) AS net_sales
FROM retail_sails
GROUP BY category;

-- Q4.Write a sql query to find the average age of customers who  purchased items from the 'beauty' category.

select
round (avg(age),2)as avg_age
from retail_sails
where category='Beauty';

-- Q5 .Write a sql query to find all transactions where the total_sale is greater than 1000.

select *from retail_sails
where total_sale >1000;

-- Q6. Write a sql  query to find the total number of transcations (transcations_id) made by each gender in each category.


select
category,
gender,
count(*) as total_trans
from retail_sails
group
by 
category,
gender;

-- Q7. Write a sql query  to calculate the average sale for each month.find out best selling month in each year.

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sails
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t
WHERE rnk = 1;

-- Q8. Write a sql query to find the top 5 customers based on the highest total sales

 select
 customer_id,
 sum(total_sale) as total_sales
 from retail_sails
 group by 1
 order by 2 desc
 limit 5

-- Q9.Write a sql query to find the number of unique customers who purchased items from each category.

select
category,
count(distinct customer_id) as cnt_uniques_cs
from retail_sails
group by category;

-- Q10 Write a sql query to create each shift and number of orders (example  morning <=12,afternoon between 12 & 17,evening >17)

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
            ELSE 'evening'
        END AS shift
    FROM retail_sails
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


-- End of project
