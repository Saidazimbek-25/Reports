-- CREATE SALES DATA TABLE
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

-- INSERT DATA INTO SALES DATA TABLE
INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East');

-- EASY QUERIES

-- 1. Compute Running Total Sales per Customer
SELECT customer_id, customer_name, SUM(total_amount) AS running_total_sales
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY customer_id;

-- 2. Count the Number of Orders per Product Category
SELECT product_category, COUNT(*) AS number_of_orders
FROM sales_data
GROUP BY product_category;

-- 3. Find the Maximum Total Amount per Product Category
SELECT product_category, MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category;

-- 4. Find the Minimum Price of Products per Product Category
SELECT product_category, MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category;

-- 5. Compute the Moving Average of Sales of 3 Days (prev day, curr day, next day)
WITH sales_with_dates AS (
    SELECT sale_id, order_date, total_amount
    FROM sales_data
)
SELECT a.sale_id, a.order_date,
       (a.total_amount + b.total_amount + c.total_amount) / 3 AS moving_avg_sales
FROM sales_with_dates a
JOIN sales_with_dates b ON a.sale_id = b.sale_id - 1
JOIN sales_with_dates c ON a.sale_id = c.sale_id + 1;

-- 6. Find the Total Sales per Region
SELECT region, SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;

-- 7. Compute the Rank of Customers Based on Their Total Purchase Amount
SELECT customer_id, customer_name, SUM(total_amount) AS total_purchase_amount,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank
FROM sales_data
GROUP BY customer_id, customer_name;

-- 8. Calculate the Difference Between Current and Previous Sale Amount per Customer
WITH sales_with_diff AS (
    SELECT customer_id, sale_id, total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY sale_id) AS prev_sale_amount
    FROM sales_data
)
SELECT customer_id, sale_id, total_amount, prev_sale_amount,
       (total_amount - prev_sale_amount) AS sale_diff
FROM sales_with_diff;

-- 9. Find the Top 3 Most Expensive Products in Each Category
SELECT product_category, product_name, unit_price,
       RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS product_rank
FROM sales_data
WHERE product_rank <= 3;

-- 10. Compute the Cumulative Sum of Sales Per Region by Order Date
SELECT region, order_date, SUM(total_amount) AS cumulative_sales
FROM sales_data
GROUP BY region, order_date
ORDER BY region, order_date;

-- MEDIUM QUERIES

-- 1. Compute Cumulative Revenue per Product Category
SELECT product_category, order_date, SUM(total_amount) AS cumulative_revenue
FROM sales_data
GROUP BY product_category, order_date
ORDER BY product_category, order_date;

-- HARD QUERIES

-- 1. Identify Products that prices are above the average product price
SELECT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- 2. Sum of Val1 and Val2 for Each Group (Sum Pre-Values)
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

SELECT Id, Grp, Val1, Val2, 
       (SELECT SUM(Val1 + Val2) FROM MyData WHERE Grp = A.Grp) AS Tot
FROM MyData A;

-- 3. Sum of Cost and Quantity
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136
