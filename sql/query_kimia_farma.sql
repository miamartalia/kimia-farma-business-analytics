CREATE OR REPLACE TABLE `kimia_farma.analisis_kimia_farma` AS
WITH base_data AS( 
  SELECT 
    t.transaction_id, 
    t.date, 
    t.branch_id, 
    kc.branch_name,
    kc.branch_category, 
    kc.kota, 
    kc.provinsi, 
    kc.rating AS rating_cabang, 
    t.customer_name, 
    p.product_id, 
    p.product_name, 
    p.product_category,
    t.price AS actual_price, 
    t.discount_percentage,
    t.rating AS rating_transaksi,
    CASE
      WHEN t.price <= 50000 THEN 0.1
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba
  FROM 
    `rakaminkfanalytics-476815.kimia_farma.kf_final_transaction` AS t
  JOIN 
    `rakaminkfanalytics-476815.kimia_farma.kf_kantor_cabang` AS kc
  ON 
    t.branch_id = kc.branch_id
  JOIN 
    `rakaminkfanalytics-476815.kimia_farma.kf_product` AS p 
  ON 
    t.product_id = p.product_id
)
SELECT
  *,
  (actual_price * (1 - discount_percentage)) AS nett_sales,
  (actual_price * (1 - discount_percentage)) * persentase_gross_laba AS nett_profit
FROM
  base_data


