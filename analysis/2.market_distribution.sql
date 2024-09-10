/* How is the market distributed? 
*/

-- orders which do not have seller id
SELECT
*
FROM df_orders o
LEFT JOIN df_order_items i ON i.order_id = o.order_id
WHERE i.seller_id IS NULL 

-- Total sales per seller and their percentage of the market
SELECT DISTINCT
    i.seller_id,
    SUM(i.price * i.order_item_id) OVER (PARTITION BY i.seller_id) AS sales,
    SUM(i.order_item_id) OVER (PARTITION BY i.seller_id) AS order_volume,
    (SUM(i.price * i.order_item_id) OVER (PARTITION BY i.seller_id) * 100.0 / 
        (SELECT SUM(price * order_item_id) FROM df_order_items WHERE seller_id IS NOT NULL)) AS market_share
FROM df_order_items i
WHERE i.seller_id IS NOT NULL
ORDER BY sales DESC


/* Some orders in the `df_orders` table do not have matching rows in the 
`df_order_items` table, which provides details about the purchased items. 
As a result, we cannot identify the sellers responsible for these orders. 
Therefore, we will focus on analyzing the market distribution using only 
the orders with complete information. */


-- Total sales per seller and their percentage of the Health & beauty products market


SELECT DISTINCT
    i.seller_id,
    SUM(i.price * i.order_item_id) OVER (PARTITION BY i.seller_id) AS sales,
    SUM(i.order_item_id) OVER (PARTITION BY i.seller_id) AS order_volume,
    (SUM(i.price * i.order_item_id) OVER (PARTITION BY i.seller_id) * 100.0 / 
        (SELECT SUM(price * order_item_id) FROM df_order_items i1 
            LEFT JOIN df_products p1 ON p1.product_id = i1.product_id
            LEFT JOIN df_name_translation n1 ON n1.product_category_name = p1.product_category_name
            WHERE i1.seller_id IS NOT NULL
            AND n1.product_category_name_english = 'health_beauty')) AS market_share
FROM df_order_items i
LEFT JOIN df_products p ON p.product_id = i.product_id
LEFT JOIN df_name_translation n ON n.product_category_name = p.product_category_name
WHERE 
    i.seller_id IS NOT NULL
    AND n.product_category_name_english = 'health_beauty'
ORDER BY sales DESC


