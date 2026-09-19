create table categories(
	category_id INT Primary Key,
    category_name Varchar(64)

);


create table customers(
	customer_id INT Primary key,
	first_name Varchar(32) NOT NULL,
	last_name Varchar(32) Not Null,
	email   Varchar(32) Unique,
	gender Varchar(15),
	city   Varchar(32),
	states  Varchar(32),
	signup_date date

);


create table order_items(
		order_item_id INT Primary Key ,
		order_id INT References orders(order_id),
		product_id INT References products(product_id),
		quantity INT,
		unit_price Numeric(10,2),
		discount Numeric(10,2)

);


create table orders(
	order_id Int Primary Key,
	customer_id Int references customers(customer_id),
	order_date date,
	order_status varchar(32),
	shipping_city varchar(32)

);


create table payments(
	payment_id int Primary key,
	order_id int References orders(order_id),
	payment_date date,
	payment_method varchar(32),
	payment_status varchar(32),
	amount Numeric(12,2)

);


create table products(
	product_id int Primary Key,
	product_name varchar(64),
	category_id int references categories(category_id),
	price Numeric(10,2),
	cost_price Numeric(10,2),
	stock_quantity Int,
	rating Numeric(2,1),
	added_date date


);