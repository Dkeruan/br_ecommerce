/* How does customer purchasing behavior vary with time? (Year, month, day of week, hour of day) */

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

SELECT
    EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
    COUNT(order_id) FILTER(WHERE EXTRACT(YEAR FROM order_purchase_timestamp)='2017') AS monthly_orders_2017,
    COUNT(order_id) FILTER(WHERE EXTRACT(YEAR FROM order_purchase_timestamp)='2018') AS monthly_orders_2018
FROM df_orders
GROUP BY purchase_month
ORDER BY purchase_month