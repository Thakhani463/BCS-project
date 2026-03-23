-- =========================================
-- BRIGHT COFFEE SHOP ANALYSIS
-- TABLE: case_study.default.bcs_analysis
-- =========================================

-- 1. Preview the dataset
SELECT *
FROM case_study.default.bcs_analysis
LIMIT 10;

-- 2. Check the date range
SELECT
    MIN(transaction_date) AS start_date,
    MAX(transaction_date) AS end_date
FROM case_study.default.bcs_analysis;

-- 3. Check store locations
SELECT DISTINCT
    store_location
FROM case_study.default.bcs_analysis
ORDER BY store_location;

-- 4. Count number of stores
SELECT
    COUNT(DISTINCT store_id) AS number_of_stores
FROM case_study.default.bcs_analysis;

-- 5. Check product categories
SELECT DISTINCT
    product_category
FROM case_study.default.bcs_analysis
ORDER BY product_category;

-- 6. Check product types
SELECT DISTINCT
    product_type
FROM case_study.default.bcs_analysis
ORDER BY product_type;

-- 7. Check product details
SELECT DISTINCT
    product_detail
FROM case_study.default.bcs_analysis
ORDER BY product_detail;

-- 8. Product hierarchy
SELECT DISTINCT
    product_category,
    product_type,
    product_detail
FROM case_study.default.bcs_analysis
ORDER BY product_category, product_type, product_detail;

-- 9. Check price range
SELECT
    MIN(unit_price) AS cheapest_price,
    MAX(unit_price) AS highest_price
FROM case_study.default.bcs_analysis;

-- 10. Dataset summary
SELECT
    COUNT(*) AS number_of_rows,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores
FROM case_study.default.bcs_analysis;

-- 11. Revenue per transaction
SELECT
    transaction_id,
    transaction_date,
    DAYNAME(transaction_date) AS day_name,
    MONTHNAME(transaction_date) AS month_name,
    transaction_qty * unit_price AS revenue_per_tnx
FROM case_study.default.bcs_analysis;

-- 12. Revenue per day
SELECT
    transaction_date,
    DAYNAME(transaction_date) AS day_name,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty * unit_price) AS revenue_per_day
FROM case_study.default.bcs_analysis
GROUP BY
    transaction_date,
    DAYNAME(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY transaction_date;

-- =========================================
-- OBJECTIVE QUERIES
-- =========================================

-- 13. Total revenue
SELECT
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis;

-- 14. Revenue by product type
SELECT
    product_type,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis
GROUP BY product_type
ORDER BY total_revenue DESC;

-- 15. Best and worst products
SELECT
    product_detail,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis
GROUP BY product_detail
ORDER BY total_revenue DESC;

-- 16. Peak sales time
SELECT
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END AS transaction_time_bucket,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis
GROUP BY
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END
ORDER BY total_revenue DESC;

-- 17. Revenue by product type and time bucket
SELECT
    product_type,
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END AS transaction_time_bucket,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis
GROUP BY
    product_type,
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END
ORDER BY product_type, total_revenue DESC;

-- 18. Revenue by product category and time bucket
SELECT
    product_category,
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END AS transaction_time_bucket,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM case_study.default.bcs_analysis
GROUP BY
    product_category,
    CASE
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 10 THEN 'Morning Rush'
        WHEN HOUR(transaction_time) >= 10 AND HOUR(transaction_time) < 12 THEN 'Lunch'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Day'
        WHEN HOUR(transaction_time) >= 17 THEN 'Evening'
        ELSE 'Other'
    END
ORDER BY product_category, total_revenue DESC;
