/* Which product categories generate the most sales?" 
*/

-- Rank product categories by total sales
SELECT 
    n.product_category_name_english AS product_category,
    SUM(price * order_item_id) AS total_sales
FROM df_order_items i
LEFT JOIN df_products p ON p.product_id = i.product_id
LEFT JOIN df_name_translation n ON n.product_category_name = p.product_category_name
GROUP BY n.product_category_name_english
ORDER BY total_sales DESC
LIMIT 20

-- Find revenue growth of top categories over the past 2 years
/* 

order_items
    -order id
    -order_item_id
    -product_id
    -price

products
    -product_id
    -product_category_name == joining name translation on category name

orders
    -order_id
    -order purchase_date 

extract year, month, day, hour from all orders first
*/

SELECT
    order_id,
    order_purchase_timestamp AS purchase_date,
    TO_CHAR(order_purchase_timestamp, 'YYYYMM') AS purchase_year_month,
    EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
    EXTRACT(DAY FROM order_purchase_timestamp) AS purchase_day,
    TO_CHAR(order_purchase_timestamp, 'Day') AS purchase_day_of_week,
    EXTRACT(HOUR FROM order_purchase_timestamp) AS purchase_hour,
    CASE
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 5 THEN 'Night'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS purchase_time_of_day
FROM df_orders
LIMIT 10


/*
Find monthly sales trend for top 5 product categories.
*/


WITH top_products AS (
    SELECT
        product_category_name_english AS category,
        SUM(price * order_item_id) AS sales
    FROM df_order_items i
    LEFT JOIN df_products p ON p.product_id = i.product_id
    LEFT JOIN df_name_translation n ON n.product_category_name = p.product_category_name
    GROUP BY n.product_category_name_english
    ORDER BY sales DESC
    LIMIT 5
)
SELECT
    n.product_category_name_english AS category_name,
    TO_CHAR(order_purchase_timestamp, 'YYYYmm') AS purchase_year_month,
--    strftime('%Y-%m', order_purchase_timestamp) AS purchase_year_month --For sqlite3
    SUM(price * order_item_id) AS monthly_sales
FROM df_orders o
LEFT JOIN df_order_items i ON o.order_id = i.order_id
LEFT JOIN df_products p ON p.product_id = i.product_id
LEFT JOIN df_name_translation n ON n.product_category_name = p.product_category_name
WHERE n.product_category_name_english IN (SELECT category FROM top_products)
GROUP BY purchase_year_month, category_name
ORDER BY purchase_year_month, category_name

-- Get total monthly sales for general ecommerce trend.
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYYmm') AS purchase_year_month,
    SUM(i.price * i.order_item_id) AS monthly_sales
FROM df_orders o
JOIN df_order_items i ON o.order_id = i.order_id
GROUP BY purchase_year_month
ORDER BY purchase_year_month;

