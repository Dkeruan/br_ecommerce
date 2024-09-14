COPY df_customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_products (product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_order_reviews (review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_name_translation (product_category_name, product_category_name_english)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY df_geolocations (geolocation_zip_code_prefix, geolocation_lat,geolocation_lng,geolocation_city,geolocation_state)
FROM 'C:\Users\dkeru\Desktop\portfolio\br_ecommerce\tables\olist_geolocation_dataset.csv'
WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

--DELETE ALL TABLES
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

--DUPLICATES FOUND IN REVIEW_ID, TEMPORARILY DROPPING THE UNIQUE CONSTRAINT
ALTER TABLE df_order_reviews DROP CONSTRAINT df_order_reviews_pkey;
ALTER TABLE df_geolocations DROP CONSTRAINT df_geolocations_pkey;
