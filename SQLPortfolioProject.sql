SELECT * FROM CustomersData;
SELECT * FROM SellersDAta
SELECT * FROM geolocationdata
SELECT * FROM OrderData
SELECT * FROM PaymentData
SELECT * FROM ProdtuctData
SELECT * FROM ReviewsDataCorrect
SELECT * FROM OrderConfirmationData

--1. How many Customers do we have by state?

SELECT
	customer_state,
	COUNT (customer_id)
	AS Total_Number_of_Customers
FROM CustomersData
	GROUP BY 
	customer_state;

--2. Count of customers per state
CREATE TABLE states (
    state VARCHAR(50) PRIMARY KEY
);

SELECT 
    s.state,
    COUNT(c.customer_id) AS total_customers
FROM 
    states s
LEFT JOIN 
    CustomersData c ON s.state = c.customer_state
GROUP BY 
    s.state;

	
--3. How many sellers do we have by state?
-- sol 3,095

SELECT
	seller_state,
	COUNT(seller_id)
	AS Total_Number_of_Sellers
FROM 
	SellersDAta
Group by 
	seller_state 
ORDER BY
	Total_number_of_Sellers DESC;

--4. Total revenue generated per order?
SELECT 
    order_id, 
    (price + freight_value) AS order_revenue,
    (SELECT SUM(price + freight_value) FROM OrderDAta) AS total_revenue
FROM 
    OrderDAta;

--5. Top selling products and sellers by revenue?
SELECT 
    p.product_category_name,
    o.product_id,
    SUM(o.price + o.freight_value) AS total_revenue
FROM
    OrderData o
INNER JOIN 
    ProdtuctData p ON o.product_id = p.product_idd
GROUP BY
    p.product_category_name, o.product_id
ORDER BY 
    total_revenue DESC

--6. Customer lifetime value based on total revenue generated 
SELECT 
    n.customer_id,
    SUM(o.price + o.freight_value) AS lifetime_value
FROM 
    orderdata o
INNER JOIN
    OrderConfirmationData n ON o.order_id = n.order_id
GROUP BY 
    n.customer_id
ORDER BY 
    lifetime_value DESC;


--7. Top Sellers by Revenue?
SELECT 
    o.seller_id,
    SUM(o.price + o.freight_value) AS total_revenue
FROM 
    orderdata o
GROUP BY 
    o.seller_id
ORDER BY 
    total_revenue DESC

 
--8. Top Rated Products		
SELECT 
    r.order_id, 
    r.review_score,
    SUM(o.price + o.freight_value) AS revenue
FROM 
    OrderData o
INNER JOIN 
    ReviewsDataCorrect r ON r.order_id = o.order_id
GROUP BY
    r.order_id, r.review_score
ORDER BY
    r.review_score DESC;

--9. Average order rating
SELECT 
    order_id,
	AVG(review_score) AS avg_review_score
FROM 
   ReviewsDataCorrect o
GROUP BY 
    order_id
ORDER BY 
    avg_review_score DESC;



--10. Payment Distribution. Which is the most used payment channel?
SELECT 
    p.payment_type,
    COUNT(p.payment_sequential) AS payment_count
FROM 
    PaymentData p
GROUP BY 
    p.payment_type
ORDER BY 
    payment_count DESC;


--11. Monthly revenue growth

SELECT 
    FORMAT(n.order_delivered_customer_date, 'yyyy-MM') AS month,
    SUM(o.price + o.freight_value) AS total_revenue
FROM 
    OrderData o
INNER JOIN 
	OrderConfirmationData n ON n.order_id = o.order_id
GROUP BY 
    FORMAT(n.order_delivered_customer_date, 'yyyy-MM')
ORDER BY 
    month;

  -- Bonus Questions: Top 10 Customers by Revenue

	SELECT TOP 10
    n.customer_id,
    SUM(o.price + o.freight_value) AS lifetime_value
FROM 
    orderdata o
INNER JOIN
    OrderConfirmationData n ON o.order_id = n.order_id
GROUP BY 
    n.customer_id
ORDER BY 
    lifetime_value DESC;

-- Categorize rating as excellent, good, average, poor and very poor
SELECT 
    o.order_id,
    r.review_score,
    CASE 
        WHEN r.review_score = 5 THEN 'Excellent'
        WHEN r.review_score = 4 THEN 'Good'
        WHEN r.review_score = 3 THEN 'Average'
        WHEN r.review_score = 2 THEN 'Poor'
        WHEN r.review_score = 1 THEN 'Very Poor'
        ELSE 'Unknown'
    END AS rating_category
FROM 
    orderdata o
INNER JOIN 
    ReviewsDataCorrect r ON o.order_id = r.order_id;
