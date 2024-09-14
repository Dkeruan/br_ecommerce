/* Find distribution of customers by purchase location 

- Calculate each customer's average spending

FROM order_items data to get price and customer id
LEFT JOIN orders to get customer id
LEFT JOIN df_customers on customer_id and location
*/

WITH geo AS (
SELECT
    geolocation_zip_code_prefix,
    MIN(geolocation_lat) AS geolocation_lat,
    MIN(geolocation_lng) AS geolocation_lng
FROM df_geolocations 
WHERE 
    geolocation_lat <= 5.27438888
    AND geolocation_lng >= -73.98283055
    AND geolocation_lat >= -33.75116944
    AND geolocation_lng <= -34.79314722
GROUP BY geolocation_zip_code_prefix
)
SELECT DISTINCT
    o.customer_id,
    ROUND(SUM(i.price * i.order_item_id)OVER (PARTITION BY o.customer_id), 2) AS total_order_amount,
    COUNT(i.order_id) OVER (PARTITION BY o.customer_id) AS num_orders,
    ROUND(AVG(i.price * i.order_item_id)OVER (PARTITION BY o.customer_id), 2) AS avg_order_amount,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    geo.geolocation_lat,
    geo.geolocation_lng
FROM df_order_items i
LEFT JOIN df_orders o ON o.order_id = i.order_id
LEFT JOIN df_customers c ON c.customer_id = o.customer_id
LEFT JOIN geo ON geo.geolocation_zip_code_prefix = c.customer_zip_code_prefix
ORDER BY total_order_amount DESC


-- Find year-monthly total sales for each region
WITH geo AS (
SELECT
    geolocation_zip_code_prefix,
    MIN(geolocation_lat) AS geolocation_lat,
    MIN(geolocation_lng) AS geolocation_lng
FROM df_geolocations 
WHERE 
    geolocation_lat <= 5.27438888
    AND geolocation_lng >= -73.98283055
    AND geolocation_lat >= -33.75116944
    AND geolocation_lng <= -34.79314722
GROUP BY geolocation_zip_code_prefix
)
SELECT
    CASE
        WHEN region_name = 'Norte' THEN 'North'
        WHEN region_name = 'Centro-Oeste' THEN 'Central-West'
        WHEN region_name = 'Nordeste' THEN 'Northeast'
        WHEN region_name = 'Sudeste' THEN 'Southeast'
        WHEN region_name = 'Sul' THEN 'South'
        ELSE region_name
    END AS region_name,
    --TO_CHAR(o.order_purchase_timestamp, 'YYYYmm') AS purchase_year_month, --used for postgresql
    strftime('%Y-%m', order_purchase_timestamp) AS purchase_year_month, --used for sqlite3
    SUM(i.price * i.order_item_id) AS total_sales,
    COUNT(i.order_id) AS total_orders
FROM df_order_items i 
LEFT JOIN df_orders o ON o.order_id = i.order_id
LEFT JOIN df_customers c ON c.customer_id = o.customer_id
LEFT JOIN geo ON geo.geolocation_zip_code_prefix = c.customer_zip_code_prefix
LEFT JOIN df_region r ON r.sigla = c.customer_state
GROUP BY region_name, purchase_year_month
ORDER BY region_name, purchase_year_month


-- Find average spending amount for customers in each state 
WITH customer_spending AS (
SELECT DISTINCT
    o.customer_id,
    ROUND(SUM(i.price * i.order_item_id)OVER (PARTITION BY o.customer_id), 2) AS total_order_amount,
    COUNT(i.order_id) OVER (PARTITION BY o.customer_id) AS num_orders,
    ROUND(AVG(i.price * i.order_item_id)OVER (PARTITION BY o.customer_id), 2) AS avg_order_amount,
    customer_city,
    customer_state,
    CASE
        WHEN region_name = 'Norte' THEN 'North'
        WHEN region_name = 'Centro-Oeste' THEN 'Central-West'
        WHEN region_name = 'Nordeste' THEN 'Northeast'
        WHEN region_name = 'Sudeste' THEN 'Southeast'
        WHEN region_name = 'Sul' THEN 'South'
        ELSE region_name
FROM df_order_items i
LEFT JOIN df_orders o ON o.order_id = i.order_id
LEFT JOIN df_customers c ON c.customer_id = o.customer_id
LEFT JOIN df_region r ON c.customer_state = r.sigla
ORDER BY total_order_amount DESC
)
SELECT DISTINCT
    customer_state AS state,
    region_name,
    AVG(avg_order_amount) OVER (PARTITION BY state) AS avg_order_amount
FROM customer_spending
ORDER BY avg_order_amount DESC



WITH geo AS (
    SELECT
        geolocation_zip_code_prefix,
        MIN(geolocation_lat) AS geolocation_lat,
        MIN(geolocation_lng) AS geolocation_lng
    FROM df_geolocations 
    WHERE 
        geolocation_lat <= 5.27438888
        AND geolocation_lng >= -73.98283055
        AND geolocation_lat >= -33.75116944
        AND geolocation_lng <= -34.79314722
    GROUP BY geolocation_zip_code_prefix
),
orders_info AS (
    SELECT
        i.order_id,
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-mm') AS purchase_year_month,
        i.price * i.order_item_id AS order_amount
        o.customer_id,
        CASE
            WHEN region_name = 'Norte' THEN 'North'
            WHEN region_name = 'Centro-Oeste' THEN 'Central-West'
            WHEN region_name = 'Nordeste' THEN 'Northeast'
            WHEN region_name = 'Sudeste' THEN 'Southeast'
            WHEN region_name = 'Sul' THEN 'South'
            ELSE region_name
        END AS region_name
    FROM df_order_items i
    LEFT JOIN df_orders o ON o.order_id = i.order_id
    LEFT JOIN df_customers c ON c.customer_id = o.customer_id
    LEFT JOIN geo ON geo.geolocation_zip_code_prefix = c.customer_zip_code_prefix
    LEFT JOIN df_region r ON r.siglaa = c.customer_state
)
SELECT
    region_name,
    purchase_year_month,
    ROUND(AVG(order_amount), 2) AS monthly_avg_spending
FROM customer_spending
GROUP BY region_name, purchase_year_month, customer_id
ORDER BY region_name, purchase_year_month, customer_id