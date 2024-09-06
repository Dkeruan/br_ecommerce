/* Which product categories generate the most revenue?" 

order_items
    - product_id
    - price

products
    - product_id
    - product_category_name
*/

SELECT 
    n.product_category_name_english AS product_category,
    SUM(price) AS revenue
FROM df_order_items i
LEFT JOIN df_products p ON p.product_id = i.product_id
LEFT JOIN df_name_translation n ON n.product_category_name = p.product_category_name
GROUP BY n.product_category_name_english
ORDER BY SUM(price) DESC
LIMIT 20