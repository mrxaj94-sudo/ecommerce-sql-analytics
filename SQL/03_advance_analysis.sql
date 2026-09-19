-- 11 City-wise revenue
select 
	c.city,
	sum(oi.unit_price * oi.quantity) as total_revenue
from
	customers c 
join 
	orders o on c.customer_id = o.customer_id
join
	order_items oi on o.order_id = oi.order_id
group by 
	c.city 
order by
	total_revenue;


	
-- 12 Top 10 customers by completed payment spending
select 	
	  o.customer_id , concat(c.first_name,' ', c.last_name) as Customer_name,
	  sum(p.amount) as Total_spending
from
	orders o 
join
	customers c on o.customer_id = c.customer_id
join 
	payments p on o.order_id = p.order_id
where 
	p.payment_status = 'Completed'
group by 
	   o.customer_id ,c.first_name , c.last_name 
order by 
		total_spending desc limit 10;
		
		
-- 13 Category revenue calculation
select 
	ca.category_name , 
	sum(oi.unit_price * oi.quantity) as total_revenue
from 
	categories ca 
join
	products p on ca.category_id = p.category_id
join 
	order_items oi on p.product_id = oi.product_id
group by
	ca.category_name;

	
	
-- 14 Top 10 products by quantity sold
select 
	oi.product_id, p.product_name , 
	sum(oi.quantity) as quantity_sold
from 
	products p
join
	order_items oi on p.product_id = oi.product_id
group by
	p.product_name ,oi.product_id  
order by
	quantity_sold desc limit 10;



-- 15 Average Order Value

select 
	(sum(oi.quantity * oi.unit_price)/ count(distinct oi.order_id))
	 as average_order_value
from
	order_items oi;

	

-- 16 Customers with no orders
select 
	c.customer_id , 
	concat(c.first_name ,'  ',c.last_name)as customer_name
from 
	customers c
left join 
	orders o on c.customer_id = o.customer_id
where
	o.order_id is null ;

	

-- 17 Products never ordered
select 
	p.product_id ,
	p.product_name 
from
	products p
left join
	order_items oi on p.product_id = oi.product_id
where
	oi.order_item_id is null;
	



-- 18 Monthly revenue
select 
	to_char(o.order_date, 'yyyy-mm') as sales_month,
	sum(oi.quantity * oi.unit_price) as total_revenue_by_months
from 
	orders o 
join
	order_items oi on o.order_id = oi.order_id
group by 
	to_char(o.order_date , 'yyyy-mm')
order by
	sales_month;

	

-- 19 Customer ranking according to there spending
select 	
	o.customer_id, concat(c.first_name , ' ', c.last_name) as customer_name,
	sum(p.amount) as total_spending,
	dense_rank() over(order by sum(p.amount) desc) as customer_rank
from 
	customers c
join 
	orders o on c.customer_id = o.customer_id
join 
	payments p on o.order_id = p.order_id
where 
	p.payment_status = 'Completed'
group by
	o.customer_id , c.first_name , c.last_name
order by 
	total_spending desc ;

	

-- 20 Top product in every category
with product_revenue as(
	select 
		p.product_id ,
		p.product_name , 
		c.category_name ,
		round(sum(oi.quantity * oi.unit_price * (1 - oi.discount / 100)),2)
		as total_revenue
	from
		products p 
	join 
		categories c on p.category_id = c.category_id
	join
		order_items oi on oi.product_id = p.product_id 
	group by 
		p.product_id , p.product_name , c.category_name 
),
  ranked_product as(
  select 
	product_id ,
	product_name,
	category_name, 
	total_revenue,
	row_number() over(
	partition by category_name 
	order by total_revenue desc) as rnk
	from product_revenue

  )

select 
	product_id , product_name , category_name, total_revenue 
from 
	ranked_product
where
	rnk = 1
order by
	category_name;



-- 21 customers who placed more than 3 orders
select 
	c.customer_id , 
	concat(c.first_name , ' ', c.last_name) as customer_name,
	count(distinct oi.order_id) as number_of_orders
from 
	customers c
join
	orders o on o.customer_id = c.customer_id
join
	order_items oi on o.order_id = oi.order_id
group by 
	c.customer_id
HAVING
	count(oi.order_id) > 3	
order by
	number_of_orders desc;


-- 22 Customer segmentation
select
    c.customer_id,
	concat(c.first_name , '  ', c.last_name) as customer_name,
	sum(p.amount) as total_spending,
case
	when sum(p.amount)> 50000 then 'High Value'
	when sum(p.amount) between 20000 and 50000 then 'Medium Value'
	else 'Low Value' 
End 
	as total_spending_status
from 
	customers c 
join 
	orders o on o.customer_id = c.customer_id
join 
	payments p on o.order_id = p.order_id
where 
	p.payment_status = 'Completed'
group by
	c.customer_id , c.first_name , c.last_name ;


-- 23 Product profitability
select 
	p.product_name, 
    sum(oi.unit_price * oi.quantity) as revenue,
	sum(p.cost_price * oi.quantity)as cost_,
	sum((oi.unit_price - p.cost_price) * oi.quantity) as profit
from
	products p 
join 
	order_items oi on p.product_id = oi.product_id
group by 
	p.product_id , p.product_name
order by 
	profit desc;


-- 24 Orders cancellation rate
select 
	count(o.order_id) as total_orders,
	count(o.order_status)
filter
	(where o.order_status = 'Cancelled') as cancelled_orders,
round
	(100.0 * count(o.order_status) 
	filter (where o.order_status = 'Cancelled') / count(o.order_id),2)
	as calcellation_percent
from 
	orders o ;



-- 25 payment success rate for each payment method.
select 
	payment_method,
	count(payment_status) as total_payments,
	count(case 
	when payment_status = 'Completed' then 1 end
	) as succesful_payments,
round
	(count(case when payment_status = 'Completed' then 1 end )* 100.0 
	/ count(payment_status),2)as succese_rate
from
	payments
group by
	payment_method
order by
	succese_rate desc;


-- 26 Month-over-month revenue growth.
SELECT 
	TO_CHAR(o.order_date, 'mm-yyyy') AS months,
	SUM(oi.quantity * oi.unit_price) AS revenue ,
LAG
	(SUM(oi.quantity * oi.unit_price), 1, 0) 
	OVER(ORDER BY Extract(month from o.order_date))
	AS previous_month_revenue,
ROUND(
   coalesce(
	    (SUM(oi.quantity * oi.unit_price) - LAG(SUM(oi.quantity * oi.unit_price))
	    OVER(ORDER BY Extract (month from o.order_date)))/
	    nullif
		    (Lag(SUM(oi.quantity * oi.unit_price))
			 over(order by Extract(month from o.order_date)),0)
	         *100,0),2)
	         AS growth_percent
FROM
	order_items oi
JOIN
	orders o ON o.order_id = oi.order_id
GROUP BY 
    
	Extract(month from o.order_date)
	
ORDER BY 
	Extract(month from o.order_date);


-- 27 Customer lifetime value
select 
	c.customer_id , 
	concat(c.first_name, ' ', c.last_name) as customer_name,
	sum(p.amount) as lifetime_value,
	dense_rank()over(order by sum(p.amount) desc) as rank_
from 
	customers c
join 
	orders o on c.customer_id = o.customer_id
join
	payments p on o.order_id = p.order_id
where 	
	payment_status = 'Completed'
group by 
	c.customer_id, 
	c.first_name,
	c.last_name
order by 
	rank_ ;



-- 28 Most popular product combination
select
	p1.product_name as Product_1,
	p2.product_name as Product_2,
	count(distinct oi.order_id) as order_counts
from
	order_items oi
join
   order_items o on oi.order_id= o.order_id
join 
	products p1 on oi.product_id = p1.product_id
join 
	products p2 on o.product_id = p2.product_id
where 
	oi.product_id < o.product_id
group by
	p1.product_name,
	p2.product_name
order by 
	order_counts desc
	
	

-- 29 Customer purchase behavior
select 
	c.customer_id ,
	min(o.order_date) as first_order_date,
	max(o.order_date) as latest_order_date,
	count(distinct o.order_id) total_orders, 
	sum(p.amount) as total_spending,
    round(sum(p.amount) / count(DISTINCT o.order_id),2)
	as average_order_value
from 
	customers c
join
	orders o on c.customer_id = o.customer_id
join 
	payments p on o.order_id = p.order_id
where 
	payment_status = 'Completed'
group by 
	c.customer_id
order by 
    total_orders desc;
	
	
-- 30 Customer ranking within city
select 
    c.customer_id,
	concat(c.first_name, ' ', c.last_name) as customer_name,
	c.city,
	sum(p.amount) as Spending ,
	dense_rank() over(partition by city order by sum(p.amount)desc) 
	as rank_within_city
from
	customers c
join
	orders o on c.customer_id = o.customer_id
join
	payments p on o.order_id = p.order_id
where
	payment_status = 'Completed'
group by 
    c.customer_id,
	c.city,
	c.first_name,
	c.last_name
order by 
	c.city,
	rank_within_city
	;

