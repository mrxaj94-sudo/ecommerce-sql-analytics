# E-Commerce Sales & Customer Analytics

## Project Overview

This project analyzes an e-commerce business using PostgreSQL.

The objective is to extract business insights related to:
- Customer spending
- Product performance
- Category revenue
- Sales trends
- Customer segmentation
- Payment performance
- Product profitability
- Customer behavior

## Dataset

The project contains six relational tables:

1. Customers
2. Categories
3. Products
4. Orders
5. Order Items
6. Payments

## Database

PostgreSQL

## SQL Concepts Used

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- CASE WHEN
- INNER JOIN
- LEFT JOIN
- Aggregate Functions
- CTEs
- Window Functions
- ROW_NUMBER()
- DENSE_RANK()
- LAG()
- DATE_TRUNC()
- Conditional Aggregation
- Self Joins
- NULL Handling

## Project Analysis

### Basic Analysis

The project answers questions such as:

- Customers from specific cities
- Most expensive products
- Products within a price range
- Order status distribution
- Average product price
- Inventory analysis
- Payment method distribution

### Advanced Business Analysis

The project analyzes:

- Revenue by customer city
- Top customers by spending
- Revenue by product category
- Best-selling products
- Average Order Value
- Customers with no orders
- Products never ordered
- Monthly revenue
- Customer spending rankings
- Highest-revenue product in each category
- Repeat customers
- Customer value segmentation
- Product profitability
- Cancellation rate
- Payment success rate
- Month-over-month revenue growth
- Customer lifetime value
- Frequently purchased product combinations
- Customer purchasing behavior
- Customer ranking within cities

## Repository Structure

```text
Ecommerce-SQL-Analytics/
│
├── README.md
│
├── sql/
│   ├── 01_tables.sql
│   ├── 02_basic_queries.sql
│   └── 03_advanced_analysis.sql
│
└── data/
    ├── customers.csv
    ├── categories.csv
    ├── products.csv
    ├── orders.csv
    ├── order_items.csv
    └── payments.csv