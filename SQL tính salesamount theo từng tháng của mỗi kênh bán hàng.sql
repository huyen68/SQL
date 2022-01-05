-- Mọi bài toán extract dữ liệu dưới đây đều được lấy dataset: AdventureWorksDW2019
-- Bài 1: retrieve total SalesAmount monthly of internet_sales and reseller_sales.
 --OUTPUT:  Year, Month, Internet_Sale_amount, Reseller_Sale_amount
 --INPUT1 = Year, Month, Internet_Sale_amount
 --INPUT2 = Year, Month, Reseller_Sale_amount
--(TÍNH GIÁ TRỊ BÁN HÀNG THEO TỪNG THÁNG CỦA MỖI NĂM CỦA MỖI KÊNH BÁN HÀNG LÀ RESELLER VÀ INTERNET)

 -- hướng giải quyết vấn đề--
 -->> cần xem dữ liệu 2 bảng như nào
 SELECT TOP 10 * FROM FactResellerSales
 SELECT TOP 10 * FROM FactInternetSales
 --2 bảng là bảng fact chứa dữ liệu bán hàng của 2 kênh bán hàng là internet và reseller theo từng ngày
 -->> các vấn đề cần giải quyết:
 /* 1. SalesAmount cần được tổng hợp theo từng tháng bằng hàm aggregate SUM() và group by theo tháng (ở đây group theo year và month)
	2. Ta cần một bảng thời gian liên tục nên ta sẽ tạo ra 1 bảng tạm thời gian gồm year và month từ bảng dữ liệu dimdate của bộ dữ liệu.
	3. Tạo ra 2 bảng tạm tiếp theo từ 2 bảng fact là factinternetsales và factresellersales gồm year, month, sum(salesamount)
	4. join lần lượt 3 bảng với nhau
*/
WITH YM AS 
(select distinct 
MonthNumberOfYear, 
CalendarYear 
from DimDate),

FIS AS (SELECT 
YEAR(OrderDate) AS YEAR_NUM,
MONTH(OrderDate) AS MONTH_NUM,
SUM(SalesAmount) AS FIS_SALE
FROM FactInternetSales 
GROUP BY YEAR(OrderDate), MONTH(OrderDate)), 

FRS AS (
SELECT 
YEAR(OrderDate) AS YEAR_NUM,
MONTH(OrderDate) AS MONTH_NUM,
SUM(SalesAmount) AS FRS_SALE
FROM FactResellerSales 
GROUP BY YEAR(OrderDate), MONTH(OrderDate))

SELECT CalendarYear, 
MonthNumberOfYear, 
ISNULL(FIS_SALE, 0) AS FIS_SALE,
ISNULL(FRS_SALE, 0) AS FRS_SALE
FROM ym
LEFT JOIN FIS 
ON FIS.YEAR_NUM = ym.CalendarYear
AND FIS.MONTH_NUM = ym.MonthNumberOfYear
left JOIN FRS
ON FRS.YEAR_NUM = ym.CalendarYear
AND FRS.MONTH_NUM = YM.MonthNumberOfYear
ORDER BY CalendarYear, MonthNumberOfYear

