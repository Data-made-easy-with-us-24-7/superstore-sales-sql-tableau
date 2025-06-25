USE superstore_db;

-- Row Count Check
SELECT COUNT(*) FROM superstore_sales;
-- count(*) = 2823

-- Duplicate Order Check
SELECT ORDERNUMBER, ORDERLINENUMBER, COUNT(*) AS cnt
FROM superstore_sales
GROUP BY ORDERNUMBER, ORDERLINENUMBER
HAVING cnt > 1;
-- ORDERNUMBER, ORDERLINENUMBER, cnt
-- blank, balnk, blank


-- Missing Values Check
SELECT 
  SUM(ORDERNUMBER IS NULL) AS missing_ordernumber,
  SUM(PRODUCTCODE IS NULL) AS missing_productcode,
  SUM(SALES IS NULL) AS missing_sales,
  SUM(ORDERDATE IS NULL) AS missing_orderdate
FROM superstore_sales;
-- missing_ordernumber,missing_productcode,missing_sales,missing_orderdate
-- 0, 0, 0, 0

-- checking null across the data
SELECT 
  SUM(ORDERNUMBER IS NULL) AS missing_ordernumber,
  SUM(QUANTITYORDERED IS NULL) AS missing_quantityordered,
  SUM(PRICEEACH IS NULL) AS missing_priceeach,
  SUM(ORDERLINENUMBER IS NULL) AS missing_orderlinenumber,
  SUM(SALES IS NULL) AS missing_sales,
  SUM(ORDERDATE IS NULL) AS missing_orderdate,
  SUM(STATUS IS NULL) AS missing_status,
  SUM(QTR_ID IS NULL) AS missing_qtr_id,
  SUM(MONTH_ID IS NULL) AS missing_month_id,
  SUM(YEAR_ID IS NULL) AS missing_year_id,
  SUM(PRODUCTLINE IS NULL) AS missing_productline,
  SUM(MSRP IS NULL) AS missing_msrp,
  SUM(PRODUCTCODE IS NULL) AS missing_productcode,
  SUM(CUSTOMERNAME IS NULL) AS missing_customername,
  SUM(PHONE IS NULL) AS missing_phone,
  SUM(ADDRESSLINE1 IS NULL) AS missing_addressline1,
  SUM(ADDRESSLINE2 IS NULL) AS missing_addressline2,
  SUM(CITY IS NULL) AS missing_city,
  SUM(STATE IS NULL) AS missing_state,
  SUM(POSTALCODE IS NULL) AS missing_postalcode,
  SUM(COUNTRY IS NULL) AS missing_country,
  SUM(TERRITORY IS NULL) AS missing_territory,
  SUM(CONTACTLASTNAME IS NULL) AS missing_contactlastname,
  SUM(CONTACTFIRSTNAME IS NULL) AS missing_contactfirstname,
  SUM(DEALSIZE IS NULL) AS missing_dealsize
FROM superstore_sales;
-- result 0 for all

-- Compute the total revenue (sales) across all transactions to understand overall business performance.
SELECT 
  ROUND(SUM(SALES), 2) AS TotalRevenue
FROM superstore_sales;
-- TotalRevenue
-- 10032628.85

-- Top 10 Best-Selling Products by Revenue
SELECT 
  PRODUCTCODE,
  ROUND(SUM(SALES), 2) AS ProductRevenue
FROM superstore_sales
GROUP BY PRODUCTCODE
ORDER BY ProductRevenue DESC
LIMIT 10;
-- PRODUCTCODE  ProductRevenue 
-- 'S18_3232','288245.42'
-- 'S10_1949','191073.03'
-- 'S10_4698','170401.07'
-- 'S12_1108','168585.32'
-- 'S18_2238','154623.95'
-- 'S12_3891','145332.04'
-- 'S24_3856','140626.90'
-- 'S12_2823','140006.16'
-- 'S18_1662','139421.97'
-- 'S12_1099','137177.01'


--  Region-wise revenue Summary
SELECT 
  TERRITORY,
  ROUND(SUM(SALES), 2) AS TotalRevenue
FROM superstore_sales
GROUP BY TERRITORY
ORDER BY TotalRevenue DESC;
-- TERRITORY, TotalRevenue
-- 'EMEA','4979272.41'
-- 'NA','3852061.39'
-- 'APAC','746121.83'
-- 'Japan','455173.22'


-- Average Discount by Category (PRODUCTLINE)
SELECT 
  PRODUCTLINE,
  ROUND(AVG(MSRP - PRICEEACH), 2) AS AvgDiscount
FROM superstore_sales
GROUP BY PRODUCTLINE
ORDER BY AvgDiscount DESC;
-- PRODUCTLINE, AvgDiscount
-- 'Classic Cars','32.55'
-- 'Trucks and Buses','14.94'
-- 'Motorcycles','14.07'
-- 'Vintage Cars','8.31'
-- 'Planes','7.03'
-- 'Ships','2.27'
-- 'Trains','-2.67'


-- Monthly Sales Trend
SELECT 
  YEAR_ID,
  MONTH_ID,
  ROUND(SUM(SALES), 2) AS MonthlyRevenue
FROM superstore_sales
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;
-- YEAR_ID, MONTH_ID, MonthlyRevenue
-- '2003','1','129753.60'
-- '2003','2','140836.19'
-- '2003','3','174504.90'
-- '2003','4','201609.55'
-- '2003','5','192673.11'
-- '2003','6','168082.56'
-- '2003','7','187731.88'
-- '2003','8','197809.30'
-- '2003','9','263973.36'
-- '2003','10','568290.97'
-- '2003','11','1029837.66'
-- '2003','12','261876.46'
-- '2004','1','316577.42'
-- '2004','2','311419.53'
-- '2004','3','205733.73'
-- '2004','4','206148.12'
-- '2004','5','273438.39'
-- '2004','6','286674.22'
-- '2004','7','327144.09'
-- '2004','8','461501.27'
-- '2004','9','320750.91'
-- '2004','10','552924.25'
-- '2004','11','1089048.01'
-- '2004','12','372802.66'
-- '2005','1','339543.42'
-- '2005','2','358186.18'
-- '2005','3','374262.76'
-- '2005','4','261633.29'
-- '2005','5','457861.06'


-- Top Customers by Revenue
SELECT 
  CUSTOMERNAME,
  ROUND(SUM(SALES), 2) AS CustomerRevenue
FROM superstore_sales
GROUP BY CUSTOMERNAME
ORDER BY CustomerRevenue DESC
LIMIT 10;
-- CUSTOMERNAME, CustomerRevenue
-- 'Euro Shopping Channel','912294.11'
-- 'Mini Gifts Distributors Ltd.','654858.06'
-- 'Australian Collectors, Co.','200995.41'
-- 'Muscle Machine Inc','197736.94'
-- 'La Rochelle Gifts','180124.90'
-- 'Dragon Souveniers, Ltd.','172989.68'
-- 'Land of Toys Inc.','164069.44'
-- 'The Sharp Gifts Warehouse','160010.27'
-- 'AV Stores, Co.','157807.81'
-- 'Anna's Decorations, Ltd','153996.13'

-- Loss-making segments (Profit < 0)
SELECT 
  PRODUCTLINE,
  ROUND(SUM(SALES - (QUANTITYORDERED * MSRP)), 2) AS TotalProfit
FROM superstore_sales
GROUP BY PRODUCTLINE
HAVING TotalProfit < 0
ORDER BY TotalProfit;
-- PRODUCTLINE, TotalProfit
-- 'Classic Cars','-164601.34'






  
  
