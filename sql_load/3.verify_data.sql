-- Sample data from olist_sellers
SELECT * FROM df_sellers LIMIT 10;

-- Sample data from olist_orders
SELECT * FROM df_orders LIMIT 10;

-- Sample data from olist_customers
SELECT * FROM df_customers LIMIT 10;

-- Sample data from olist_order_items
SELECT * FROM df_order_items LIMIT 10;

-- Sample data from olist_products
SELECT * FROM df_products LIMIT 10;

-- Sample data from olist_order_payments
SELECT * FROM df_order_payments LIMIT 10;

-- Sample data from olist_order_reviews
SELECT * FROM df_order_reviews LIMIT 10;

-- Sample data from product_category_name_translations
SELECT * FROM df_name_translation LIMIT 10;



-- Check the number of rows in olist_sellers
SELECT COUNT(*) AS seller_count FROM df_sellers;

-- Check the number of rows in olist_orders
SELECT COUNT(*) AS order_count FROM df_orders;

-- Check the number of rows in olist_customers
SELECT COUNT(*) AS customer_count FROM df_customers;

-- Check the number of rows in olist_order_items
SELECT COUNT(*) AS order_item_count FROM df_order_items;

-- Check the number of rows in olist_products
SELECT COUNT(*) AS product_count FROM df_products;

-- Check the number of rows in olist_order_payments
SELECT COUNT(*) AS payment_count FROM df_order_payments;

-- Check the number of rows in olist_order_reviews
SELECT COUNT(*) AS review_count FROM df_order_reviews;




SELECT review_id, COUNT(*)
FROM df_order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

