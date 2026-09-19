-- 1 Customer filtering
select 
	* from customers 
	where city = 'Pune';
	

-- 2 Product filtering
select
	* from products 
where
	price > 10000;


-- 3 Top 10 most expensive products.
select 
	* from products 
order by
	price DESC limit 10;


-- 4 Product categories
select 
	distinct category_name 
from 
	categories; 
	

-- 5 Customer registration
select 
	* from customers 
where 
	signup_date > '2024-01-01';


-- 6 Product price range
select
	* from products 
where
	price between 1000 and 5000;

-- 7 Order status
select 
	order_status, 
	count(order_status) 
from 
	orders 
group by 
	order_status;
	

-- 8 Average product price
select 
	avg(price) as average_product_price 
from
	products;


	
-- 9 Total inventory
select 
	sum(stock_quantity) as Total_inventory 
from 
	products;
	

-- 10 Payment methods
select 
	payment_method ,
    count(payment_method) 
from 
	payments 
group by
   payment_method;





