create database sql_project_p2;

--Create Table
Drop Table if Exists retail_sales;
Create Table retail_sales(
 transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
);
--Data Cleaning
select * from retail_sales
limit 10;

select 
   count(*)
   from retail_sales;

select * from retail_sales
where transaction_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE from retail_sales
where transaction_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;
-- Data Exploration

--How manny sales we have?
select count(*) as total_sale from retail_sales;

--How many unique customer we have ?
select count(distinct customer_id) as total_customer from retail_sales;

-- How many unique category ?
select count(distinct category) as total_category from retail_sales;

--Data Analysis & Business key problems & Answers .
--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
   select *
   from retail_sales
   where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
   SELECT *
   FROM retail_sales
   WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;

--Q.3 Write a SQl query to calculate the total sales(total_sale) each category.
   select 
     category,
	 sum(total_sale) as net_sale,
	 count(*) as total_orders
	 from retail_sales
	 group by 1;

--Q.4 Write a SQL query to find the average age of customer who purchased items from the 'Beauty' category.
    select
	Round(AVG(age),2) as avg_age
	from retail_sales
	where category = 'Beauty';

--Q.5 Write the sql query to find all transections where the total_sale is greater than 1000 with gender wise sale.
   select 
   gender,
   count(*) as gender_wise_sale
   from retail_sales
   where total_sale > 1000
   group by 1;

--Q.6 Write the sql query to find the total number of transactions(transaction_id) made by each gender in each category.
  select 
  category,
  gender,
  count(*) as total_trans
  from retail_sales
  group by 1,2
  order by 1;

--Q.7 Write a sql query to calculate the average sale for each month. Find out best selling month in each year.
   select
     Extract(Year from sale_date) as year,
	 Extract(Month from sale_date) as month,
	 AVG(total_sale) as avg_monthly_sale
	 from retail_sales
	 group by 
	    year , month
	 order by 
		year , month;

    SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

--Q.8 Write the sql query to find the top 5 customer based on th higest total sales;
   select 
     customer_id,
	 SUM(total_sale) as total_sales
   from retail_sales
   Group by 1
   order by 2 desc
   limit 5;

--Q.9 Write a sql query to find the number of unique customers who purchased items from each category.
  select 
    category,
	count(distinct customer_id) as cnt_unique_cs
	from retail_sales
	group by category;
 	
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
