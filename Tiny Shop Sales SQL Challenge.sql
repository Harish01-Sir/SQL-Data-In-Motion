-- Case Study Questions

#1) Which product has the highest price? # Only return a single row.

Select product_id,product_name,price 
from products
where price = (Select max(price) as highest_price from products)
 
#2) Which customer has made the most orders?

Select concat(first_name,' ',last_name) as full_name,count(*) as most_orders
from customers
join orders using (customer_id)
group by full_name
limit 3

#3) What’s the total revenue per product?

Select product_name,sum(quantity * price) as total_revenue
from products
join order_items using (product_id)
group by product_name
order by total_revenue desc

#4) Find the day with the highest revenue.

Select order_date as Date,DAYNAME(order_date) as Name_of_the_day,sum(quantity * price) as highest_revenue 
from products
join order_items using (product_id)
join orders using (order_id)
group by order_date
order by highest_revenue desc


#5) Find the first order (by date) for each customer.

Select x.customer_id,x.full_name,x.order_date from (
Select customer_id,Concat(first_name,' ',last_name) as full_name,order_date,
rank() over (partition by customer_id order by order_date) as rnk
from customers
join orders using (customer_id)) as x
where rnk =1


#6) Find the top 3 customers who have ordered the most distinct products

Select Concat(first_name,' ',last_name) as full_name,count(distinct(product_name)) as distinct_products
from customers
join orders using (customer_id)
join order_items using (order_id)
join products using (product_id)
group by full_name
order by distinct_products desc
limit 3

#7) Which product has been bought the least in terms of quantity?

Select product_name,sum(quantity) as total_quantity
from products
join order_items using (product_id)
group by product_name
order by total_quantity


#8) What is the median order total?

Select product_name,round(avg(quantity),2)
from order_items
join products using (product_id)
group by product_name

#9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

Select order_id,
   Case when sum(quantity * price) > 300  then 'Expensive'
        when sum(quantity * price) > 100 then 'Affordable'
        else 'Cheap'
        end as cost
from orders
join order_items using (order_id)
join products using (product_id)
group by order_id


#10) Find customers who have ordered the product with the highest price.

Select Concat(first_name,' ',last_name) as full_name,max(price) as highest_price
from products
join order_items using (product_id)
join orders using (order_id)
join customers using (customer_id)
group by full_name
order by highest_price desc
limit 2