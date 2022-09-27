--Check the tables
SELECT * FROM orders_1 limit 5;
SELECT * FROM orders_2 limit 5;
SELECT * FROM customer limit 5;


--Total of Sales in Quarters 1 and 2
SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceEach) AS revenue
FROM orders_1
WHERE status = 'Shipped';

SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceEach) AS revenue
FROM orders_2
WHERE status = 'Shipped';


--Calculating the percentage of overall sales
SELECT 
	quarter,
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceEach) AS revenue
FROM
	(SELECT orderNumber, status, quantity, priceEach,
	 '1' AS quarter FROM orders_1
	 UNION
	 SELECT orderNumber, status, quantity, priceEach,
	 '2' AS quarter FROM orders_2) AS tabel_a
WHERE status = 'Shipped'
GROUP BY quarter;


--Looking to find out if the number of customers is growing
SELECT 
	quarter,
	COUNT(DISTINCT customerID) as total_customers
FROM 
	(SELECT customerID, createDate, QUARTER(createDate) AS quarter
	FROM customer
	WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30') AS tabel_b
GROUP BY quarter;


--Find out how many customers have already made transactions
SELECT
	quarter,
	COUNT(DISTINCT customerID) AS total_customers
FROM
	(SELECT
	customerID, 
	createDate,
	QUARTER(createDate) AS quarter
	FROM customer
	WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30') AS tabel_b
WHERE customerID IN 
	(SELECT DISTINCT customerID FROM orders_1
	UNION
	SELECT DISTINCT customerID FROM orders_2)
GROUP BY quarter;


--Find out which products were ordered by customers the most in Quarter-2
SELECT * FROM(
SELECT 
	categoryID,
	COUNT(DISTINCT orderNumber) AS total_order,
	SUM(quantity) AS total_penjualan
FROM 
	(SELECT
	productCode,
	orderNumber,
	quantity,
	status,
	LEFT(productCode, 3) AS categoryid
	FROM orders_2
	WHERE status = 'Shipped') AS tabel_c
GROUP BY categoryid) a
ORDER BY total_order DESC;


--Looking to find out how many customers are still actively transacting after the first transaction
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;

SELECT 
	1 AS quarter,
	ROUND(COUNT(DISTINCT customerID)/
	(SELECT COUNT(DISTINCT customerID)FROM orders_1)* 100)* 10000
AS Q2
FROM orders_1
WHERE customerID IN (SELECT DISTINCT customerID FROM orders_2)


