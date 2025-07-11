#selecting required schema
use ecommerce;

# selecting all values from required table
select * from customers;
select * from employees;
select * from order_items;
select * from orders;
select * from payments;
select * from products;
select * from sellers;

#selecting partcular columns from required table
select seller_id,seller_city from sellers;

#Finding all customers with state SP
select * from customers where customer_state='SP';

#Finding orders which are cancelled
select * from orders where order_status="canceled";

#Finding orders where payment is done by UPI and payment value is more than 500
select * from payments where payment_type="UPI" and payment_value>=500;

#finding detail where payment is done by credit card and number of installment is 2
select * from payments where payment_type='credit_card' and payment_installments=2 and payment_value>=1000;

#finding data of customers belonging to state SP or MG
select * from customers where customer_state='SP' or customer_state='MG';

#finding payment type,payment type and payment value details where payment method is other than UPI and credit card
select payment_type,payment_value,payment_type from payments where not(payment_type='UPI' or payment_type="credit_card");

#finding payment type and payment value details where payment value is in between 1000-3000
select payment_type,payment_value from payments where payment_value between 1000 and 3000;

#finding orders where order_status is delivered,canceled,shipped
select order_id,order_status from orders where order_status in ('delivered','canceled','shipped');

#finding order id.order status where order_status is other than delivered,canceled,shipped
select order_id,order_status from orders where order_status not in ('delivered','canceled','shipped');

#Finding list of all cities which name ends with p or starts with p
select customer_city from customers where customer_city like "%p";
select customer_city from customers where customer_city like "p%";

#Citi name which contains pr in name
select customer_city from customers where customer_city like "%pr%";

#Arranging all payments in ascending order of payment values
select * from payments order by payment_value;

#Arranging all payments in decending order of payment values and payment type
select * from payments order by payment_type,payment_value desc;

#finding ascending values of payments where payment installment is 1
select payment_installments,payment_value from payments where payment_installments=1 order by payment_value;

#selecting top 10 highest payment values
select payment_value from payments order by payment_value desc limit 10;

#finding payment_installments and payment_type details of top 20 lowest payment values
select payment_installments,payment_type,payment_value from payments order by payment_value limit 20;

#finding total of payment_value as total payment
select sum(payment_value) as total_payment from payments ;

#Rounding total_payment value to particular number of decimal places
select round(sum(payment_value),2) as total_payment from payments ;

#finding maximum and minimum value of payment
select max(payment_value) as max_payment from payments;
select min(payment_value) as min_payment from payments;

#Finding average of payment_value
select round(avg(payment_value),2) as avg_payment from payments;

#finding total number of customers
select count(customer_id) as total_customers from customers;

#finding count of cities with unique values
select count(distinct customer_city) from customers;

#finding lengh of seller_city
select seller_city,length(seller_city) from sellers;

#finding lengh of seller_city without white spaces
select seller_city,length(trim(seller_city)) from sellers;

#converting all city names into upper case
select upper(seller_city) from sellers;

#converting all customer_state names into lower case
select lower(customer_state) from customers;

#replacing a with b in the name of seller_city
select seller_city,replace(seller_city,"a","b") from sellers;

#Merging seller_city and seller_state columns
select seller_city,seller_state,concat(seller_city, "-",seller_state) as city_state from sellers;

#selecting order delivered customer date and then breaking it into day,month,year,month name
SELECT 
    order_delivered_customer_date,
    DAY(order_delivered_customer_date) as date,
    MONTH(order_delivered_customer_date) as month_no,
    MONTHNAME(order_delivered_customer_date) as month_name,
    YEAR(order_delivered_customer_date) as year,
    dayname(order_delivered_customer_date) as day_name

FROM
    orders;

#Braking order_delivered_customer_date time into hour,minutes,seconds
SELECT 
    order_delivered_customer_date,
    HOUR(order_delivered_customer_date) AS hour,
    MINUTE(order_delivered_customer_date) AS minute,
    SECOND(order_delivered_customer_date) AS second
FROM
    orders;
    
#Finding difference between order_delivered_customer_date and order_estimated_delivery_date
select datediff(order_estimated_delivery_date,order_delivered_customer_date) from orders;

#ceil will give upper round of values and floor will give lower round up value
#converting payment value to upper round
select payment_value,ceil(payment_value) from payments;
select payment_value,floor(payment_value) from payments;

#Changing blanks values in order_delivered_customer_date with null
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';
select order_delivered_customer_date from orders;    

#Finding all details where order_delivered_customer_date is null
select * from orders where order_delivered_customer_date is null;

#Counting different types of order counts
select order_status,count(order_status) from orders group by order_status ORDER BY COUNT(order_status) DESC;

#Counting top 10 total count of each type of payment installments
select payment_installments,count(payment_installments) from payments group by payment_installments ORDER BY COUNT(payment_installments) DESC limit 10;

#Finding average of each payment type
select payment_type,round(avg(payment_value),2) from payments group by payment_type;

#find the count of order_status where count is more than 100
select order_status,count(order_status) from orders group by order_status having count(order_status)>100;

#joints are used to join two tables together
#joining customers and orders to find order status of each customer id
select customers.customer_id ,orders.order_status from customers join orders on customers.customer_id = orders.customer_id;

#finding customer id where order status is shipped
select customers.customer_id,orders.order_status from customers join orders on customers.customer_id=orders.customer_id where order_status='shipped';

#finding total payment value for each year
SELECT 
    YEAR(orders.order_purchase_timestamp) AS years,
    round(SUM(payments.payment_value),2) total_payment
FROM
    orders
		JOIN
    payments ON orders.order_id = payments.order_id
GROUP BY years order by years;

#Find values where payment values are same
select t1.order_id,t2.order_id from payments as t1,payments as t2 where t1.payment_type=t2.payment_type;

#find  products id and there total value also finding top value product id
SELECT 
    products.product_id, sum(payments.payment_value) as total_sales
FROM
    products
        JOIN
    order_items ON products.product_id = order_items.product_id
        JOIN
    payments ON payments.order_id = order_items.order_id group by product_id order by total_sales desc limit 1 ;
    
#FINDING TOP SELING 5 PRODUCT_ID
SELECT 
    product_id
FROM
    (SELECT 
        products.product_id,
            SUM(payments.payment_value) AS total_sales
    FROM
        products
    JOIN order_items ON products.product_id = order_items.product_id
    JOIN payments ON payments.order_id = order_items.order_id
    GROUP BY product_id
    ORDER BY total_sales DESC
    LIMIT 5) AS top_selling;
    
#Divide all payment value into low medium and max category as per value and product id
with a as (SELECT 
        (products.product_id) product_id,
		SUM(payments.payment_value) AS total_sales
    FROM
        products
    JOIN order_items ON products.product_id = order_items.product_id
    JOIN payments ON payments.order_id = order_items.order_id
    GROUP BY product_id
    ORDER BY total_sales DESC)
    select *, case 
    when total_sales<=5000 then "low"
    when total_sales>=10000 then "Max"
    else "Medium"
    end as sales_type
    from a;
    
#Finding payment value as per order date
select order_date, sales,sum(sales) over (order by order_date) from 
(select date(orders.order_purchase_timestamp) as order_date,round(sum(payments.payment_value),2) as sales
from orders join payments on orders.order_id=payments.order_id group by order_date) as a;

#Ranking sales as per order date-if two values of sales are same use denserank
create view order_date_sales_rank as
with a as(select date(orders.order_purchase_timestamp) as order_date,round(sum(payments.payment_value),2) as sales
from orders join payments on orders.order_id=payments.order_id group by order_date)
select order_date,sales,rank() over(order by sales desc) as rk from a;


#Ranking sales as per order date-if two values of sales are same use denserank
with a as(select date(orders.order_purchase_timestamp) as order_date,round(sum(payments.payment_value),2) as sales
from orders join payments on orders.order_id=payments.order_id group by order_date),

b as(select order_date,sales,rank() over(order by sales desc) as rk from a)
select order_date,sales from b where rk<=5;


