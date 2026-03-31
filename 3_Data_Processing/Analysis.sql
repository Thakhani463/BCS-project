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
-- FINAL SQL QUERY FOR ANALYSIS
-- =========================================
SELECT
    -- Dates
    transaction_date AS purchase_date,
    dayname(transaction_date) AS Day_name,
    monthname(transaction_date) AS Month_name,
    dayofmonth(transaction_date) AS day_of_month,

    -- Day classification
    CASE
        WHEN dayname(transaction_date) IN ('Sun', 'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,

    -- Time
    date_format(transaction_time, 'HH:mm:ss') AS purchase_time,

    CASE
        WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
        WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
        WHEN date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
    END AS time_buckets,

    -- Counts
    COUNT(DISTINCT transaction_id) AS Number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores,

    -- Revenue
    SUM(transaction_qty * unit_price) AS revenue_per_day,
    SUM(transaction_qty) AS total_quantity,

    -- Spend bucket 
    CASE
        WHEN SUM(transaction_qty * unit_price) <= 50 THEN '01. Low Spend'
        WHEN SUM(transaction_qty * unit_price) BETWEEN 51 AND 100 THEN '02. Med Spend'
        ELSE '03. High Spend'
    END AS spend_bucket,

    -- Categorical columns
    store_location,
    product_category,
    product_detail

FROM case_study.default.bcs_analysis

GROUP BY
    transaction_date,
    dayname(transaction_date),
    monthname(transaction_date),
    dayofmonth(transaction_date),

    CASE
        WHEN dayname(transaction_date) IN ('Sun', 'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END,

    date_format(transaction_time, 'HH:mm:ss'),

    CASE
        WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
        WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
        WHEN date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
    END,

    store_location,
    product_category,
    product_detail;
