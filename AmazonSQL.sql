use capstone_sql_amazon;
select * from amazon;

-- 1. What is the count of distinct cities in the dataset?
select city, count(city) count_cities from amazon group by city;

/*This SQL query counts the number of occurrences of each city in the "amazon" dataset and groups the results by city. 
The count(city) function is used to count the occurrences of each city, and the result is stored in a column named count_cities. 
The group by city statement groups the data by city so that the count is calculated for each unique city in the dataset.*/


-- 2. For each branch, what is the corresponding city?
select branch, city from amazon group by branch, city;

/*the query is asking for the city corresponding to each branch in the "amazon" dataset. It groups the data so that it shows the 
relationship between each branch and the city where it is located.*/



-- 3. What is the count of distinct product lines in the dataset?
select product_line, count(product_line) count_productline from amazon group by product_line;

/*the query is asking how many times each product line appears in the "amazon" dataset. It then provides a count for each product line, 
showing the number of times each product line is mentioned in the dataset.*/



-- 4. Which payment method occurs most frequently?
select max(payment) most_payment, count(*) payment_count from amazon group by payment order by payment_count desc limit 1;

/*This SQL query calculates the most frequently occurring payment method in the "amazon" dataset. It groups the data by the payment method and counts 
the occurrences of each payment method using the count(*) function. The order by payment_count desc statement sorts the results in descending order 
based on the payment count. The limit 1 clause ensures that only the first row of the sorted result set is returned, which corresponds to the payment 
method that occurs most frequently.*/



-- 5. Which product line has the highest sales?
select product_line, sum(total) sales from amazon group by product_line order by sales desc limit 1;

/*This SQL query calculates the product line with the highest sales in the "amazon" dataset. It groups the data by product line and calculates the total sales 
for each product line using the sum(total) function. The order by sales desc statement sorts the results in descending order based on the total sales. 
The limit 1 clause ensures that only the first row of the sorted result set is returned, which corresponds to the product line with the highest sales.*/




-- 6. How much revenue is generated each month?
select month(STR_TO_DATE(date, '%Y-%m-%d')) as month, sum(gross_income) revenue from amazon group by month;

/*
This SQL query calculates the revenue generated each month in the "amazon" dataset. It uses the STR_TO_DATE(date, '%Y-%m-%d') function to convert the date 
column into a date format, extracts the month from the date using the month() function, and groups the data by month. The sum(gross_income) function calculates 
the total revenue for each month.*/




-- 7. In which month did the cost of goods sold reach its peak?
select month(STR_TO_DATE(date, '%Y-%m-%d')) as month, sum(total) revenue from amazon group by month order by revenue desc limit 1;

/*This SQL query calculates the month when the cost of goods sold (COGS) reached its peak in the "amazon" dataset. It converts the date column into a date format, 
extracts the month from the date, and groups the data by month. The sum(total) function calculates the total revenue for each month. 
The order by revenue desc statement sorts the results in descending order based on the total revenue. */





-- 8. Which product line generated the highest revenue?
select product_line, sum(unit_price * quantity) revenue from amazon group by product_line order by revenue desc limit 1;

/*the query is asking which product line generated the highest total revenue in the "amazon" dataset, and it provides the total revenue for that product line.*/






-- 9. In which city was the highest revenue recorded?
select city, sum(gross_income) as total_revenue from amazon group by city order by total_revenue desc limit 1;

/*
This query finds the city where the highest total revenue was recorded in the dataset. It calculates the total revenue for each 
city by summing the gross_income column, groups the results by city, and then orders them in descending order based on the total revenue. 
The LIMIT 1 clause ensures that only the city with the highest total revenue is returned.*/






-- 10. Which product line incurred the highest Value Added Tax?
select product_line, sum(vat) as total_vat from amazon group by product_line order by total_vat desc limit 1;

/*
This query identifies the product line that incurred the highest Value Added Tax (VAT). It calculates the total VAT for each product line by 
summing the vat column, groups the results by product line, and then orders them in descending order based on the total VAT. The LIMIT 1 clause ensures 
that only the product line with the highest total VAT is returned.*/






-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
with avg_sales as (select avg(total) as avg_total from amazon)
select product_line, total, case when total > (select avg_total from avg_sales) then 'Good' else 'Bad' end as sales_indicator from amazon;

/*This query adds a column to each row in the dataset indicating whether the sales for that product line are above or below the average sales 
across all product lines. It first calculates the average total sales (avg_total) using a subquery and assigns it to a temporary table avg_sales. 
Then, for each row in the dataset, it compares the total sales (total) for that product line with the average total sales. If the total sales are 
greater than the average, it assigns the value 'Good' to the sales_indicator column; otherwise, it assigns 'Bad'.*/





-- 12. Identify the branch that exceeded the average number of products sold.
with avg_products as (select avg(quantity) as avg_quantity from amazon)
select branch, sum(quantity) as total_quantity from amazon group by branch
having sum(quantity) > (select avg_quantity from avg_products);

/*This query identifies the branch that exceeded the average number of products sold. It first calculates the average quantity of products sold (avg_quantity) 
using a subquery and assigns it to a temporary table avg_products. Then, it calculates the total quantity of products sold for each branch using the SUM(quantity) 
function and groups the results by branch. Finally, it uses the HAVING clause to filter the results to only include branches where the total quantity of products 
sold exceeds the average quantity.*/






-- 13. Which product line is most frequently associated with each gender?
select gender, product_line, count(*) as frequency from amazon group by gender, product_line order by gender, frequency desc;

/*This query determines which product line is most frequently associated with each gender in the dataset. It counts the occurrences of each combination 
of gender and product line using the COUNT(*) function, groups the results by gender and product line, and then orders them first by gender and then by 
frequency in descending order.*/






-- 14. Calculate the average rating for each product line.
select product_line, avg(rating) as average_rating from amazon group by product_line;

/*This query calculates the average rating for each product line in the dataset. It uses the AVG(rating) function to calculate the average rating 
for each product line, grouping the results by product line. The result set includes the product line and its corresponding average rating.*/






-- 15. Count the sales occurrences for each time of day on every weekday.
select dayofweek(date) as weekday, dayname(date) as weekday_name, hour(time) as hour_of_day, count(*) as sales_occurrences
from amazon where dayofweek(date) between 2 and 6 group by dayofweek(date), hour(time) order by dayofweek(date), hour(time);

/*This query counts the sales occurrences for each hour of the day from Monday to Friday. It groups the data by weekday, weekday name, and hour of the day, 
providing the count of sales occurrences for each combination.*/






-- 16. Identify the customer type contributing the highest revenue.
select customer_type, sum(total) as total_revenue
from amazon group by customer_type order by total_revenue desc limit 1;

/* This query identifies the customer type that contributes the highest revenue in the dataset. It calculates the total revenue for each customer 
type using the SUM(total) function, groups the results by customer type, and then orders them in descending order based on the total revenue. */






-- 17. Determine the city with the highest VAT percentage.
select city, sum(vat) as total_vat, sum(total) as total_sales, (sum(vat) / sum(total)) * 100 as vat_percentage
from amazon group by city order by vat_percentage desc limit 1;

/*
This query determines the city with the highest Value Added Tax (VAT) percentage in the dataset. It calculates the total VAT and total sales for 
each city using the SUM(vat) and SUM(total) functions, respectively. Then, it calculates the VAT percentage for each city by dividing the total VAT 
by the total sales and multiplying by 100. The results are then ordered in descending order based on the VAT percentage*/





-- 18. Identify the customer type with the highest VAT payments.
select customer_type, sum(vat) as total_vat_payments
from amazon group by customer_type order by total_vat_payments desc limit 1;

/*This query identifies the customer type that has the highest VAT payments in the dataset. It calculates the total VAT payments for each customer type 
using the SUM(vat) function, groups the results by customer type, and then orders them in descending order based on the total VAT payments.*/






-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as distinct_customer_types from amazon;

/*
This query calculates the count of distinct customer types in the dataset. It uses the COUNT(DISTINCT customer_type) function to count the number of 
unique customer types in the "amazon" dataset and assigns the result to a column named distinct_customer_types.*/






-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct payment) as distinct_payment_methods from amazon;

/*This query calculates the count of distinct payment methods in the dataset. It uses the COUNT(DISTINCT payment) function to count the number of 
unique payment methods in the "amazon" dataset and assigns the result to a column named distinct_payment_methods.*/






-- 21. Which customer type occurs most frequently?
select customer_type, count(*) as frequency
from amazon group by customer_type order by frequency desc limit 1;

/*
This query identifies the customer type that occurs most frequently in the dataset. It counts the occurrences of each customer type using the 
COUNT(*) function, groups the results by customer type, and then orders them in descending order based on the frequency.*/





-- 22. Identify the customer type with the highest purchase frequency.
select customer_type, count(*) as purchase_frequency
from amazon group by customer_type order by purchase_frequency desc limit 1;

/*This query identifies the customer type with the highest purchase frequency in the dataset. It counts the number of purchases made by each customer type using 
the COUNT(*) function, groups the results by customer type, and then orders them in descending order based on the purchase frequency.*/





-- 23. Determine the predominant gender among customers.
select gender, count(*) as customer_count
from amazon group by gender order by customer_count desc limit 1;

/*
This query determines the predominant gender among customers in the dataset. It counts the occurrences of each gender 
using the COUNT(*) function, groups the results by gender, and then orders them in descending order based on the customer count.*/





-- 24. Examine the distribution of genders within each branch.
select branch, gender, count(*) as gender_count
from amazon group by branch, gender order by branch, gender;

/*
This query examines the distribution of genders within each branch in the dataset. It counts the occurrences of each gender within each branch 
using the COUNT(*) function, groups the results by branch and gender, and then orders them first by branch and then by gender.*/






-- 25. Identify the time of day when customers provide the most ratings.
select hour(time) as hour_of_day,
count(*) as rating_count from amazon where rating is not null group by hour(time) order by rating_count desc limit 1;

/*This query identifies the time of day when customers provide the most ratings in the dataset. It extracts the hour of the day from the time column 
using the HOUR(time) function, counts the occurrences of ratings (where the rating is not null), groups the results by the hour of the day, and then orders 
them in descending order based on the rating count.*/






-- 26. Determine the time of day with the highest customer ratings for each branch.
select branch, hour(time) as hour_of_day,
avg(rating) as average_rating from amazon where rating is not null group by branch, hour(time) order by branch, average_rating desc;

/* This query determines the time of day with the highest customer ratings for each branch in the dataset. It extracts the hour of the day from the 
time column using the HOUR(time) function, calculates the average rating (excluding null ratings), groups the results by branch and hour of the day, 
and then orders them first by branch and then by average rating in descending order.*/






-- 27. Identify the day of the week with the highest average ratings.
select dayname(date) as day_of_week, avg(rating) as average_rating
from amazon where rating is not null group by dayofweek(date) order by average_rating desc limit 1;

/* This query identifies the day of the week with the highest average ratings in the dataset. It extracts the day of the week from the date column using the 
DAYNAME(date) function, calculates the average rating (excluding null ratings), groups the results by the day of the week, and then orders them in descending 
order based on the average rating.*/





-- 28. Determine the day of the week with the highest average ratings for each branch.
select branch, dayname(date) as day_of_week, avg(rating) as average_rating
from amazon where rating is not null group by branch, dayofweek(date) order by branch, average_rating desc;

/* This query determines the day of the week with the highest average ratings for each branch in the dataset. It extracts the branch, day of the week from the 
date column using the DAYNAME(date) function, calculates the average rating (excluding null ratings), groups the results by branch and day of the week, and 
then orders them first by branch and then by average rating in descending order.*/

































