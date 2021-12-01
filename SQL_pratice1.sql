--Bài luyện tập lại code SQL cho các bài toán kinh tế--
/* Ex1: Write a query to get SalesOrderNumber, ProductKey, OrderDate from FactInternetSales then caculate:
- Total Revenue equal to OrderQuantity*UnitPrice
- Total Cost equal to ProductStandardCost + DiscountAmount
- Profit equal to Total Revenue - Total Cost
- Profit margin equal (Total Revenue - Total Cost)/Total Revenue
*/
SELECT SalesOrderNumber,
	ProductKey,
	OrderDate,
	OrderQuantity * UnitPrice as "Total Revenue",
	ProductStandardCost + DiscountAmount as "Total Cost",
	(OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount) as Profit,
	((OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount))/(OrderQuantity * UnitPrice) as "Profit margin"
FROM FactInternetSales
-- các công thức kinh tế cơ bản--
-- doanh thu = số lượng * giá mỗi sản phẩm
-- chi phí = chi phí tiêu chuẩn + tiền giảm giá (là 1 loại chi phí)
-- lợi nhuận = doanh thu - chi phí
-- biên lợi nhuận = lợi nhuận: tổng doanh thu 
-- biên lợi nhuận càng cao thì cho thấy sản phẩm đó kiếm được nhiều lợi nhuận hơn

/* Ex2: Write a query to get DateKey, ProductKey from FactProductInventory then caculate
- Number of product end of day equal to UnitsBalance + UnitsIn - UnitsOut
- Total Cost equal to Number of product end of day * UnitCost 
*/ 
/* tính toán hàng tồn kho cuối ngày và giá hàng tồn kho cuối ngày*/
-- bảng FactProductInventory là bảng chứa các dữ liệu về hàng tồn kho của sản phẩm
-- các thông tin cần thiết lấy là ngày và sản phẩm với lượng tồn kho tương ứng
-- công thức tính sản lượng hàng tồn kho cuối ngày = sản lượng vào - sản lượng ra + sản lượng cân bằng

SELECT DateKey,
	ProductKey,
	UnitsBalance + UnitsIn - UnitsOut as "No.Product end of day",
	(UnitsBalance + UnitsIn - UnitsOut) * UnitCost as "Tổng giá hàng tồn kho"
FROM FactProductInventory
-- bài tập bổ sung: lấy ra những ngày không có hàng vào, lấy ra những ngày không có hàng ra, lấy ra những ngày có dữ liệu về hàng nhập kho.
SELECT DateKey,
	ProductKey,
	UnitsIn,
	UnitsOut
FROM FactProductInventory
where UnitsIn <> 0 -- tìm ra những ngày có hàng vào thôi

-- bảng thông tin nhân viên
/* Practice 1 (slide buổi 2) : From DimEmployee table:
Calculate age of each Employee when they are hired. (HireDate - BirthDate)
Calculate age of each Employee today.
Get user name of each employee. Username is last part of login ID: adventure-works\jun0 -> Username = jun0
*/ -- Your script:
SELECT EmployeeKey,
	FirstName + ISNULL(MiddleName,'') + LastName as FullName,
	DATEDIFF (Year, BirthDate, HireDate) as "Employee Age", -- vì birthday và hiredate là dữ liệu kiểu datetime nên phải dùng hàm datediff để tính
	-- khoảng cách giữa 2 khoảng thời gian, year có thể thay thế bằng month...
	DATEDIFF (Year, BirthDate, GETDATE()) as "Current Employee Age" -- getdate() trả về ngày hiện tại
FROM DimEmployee
-- BỔ SUNG THÊM MỘT SỐ BÀI TOÁN:
-- TÍNH SỐ NHÂN VIÊN NỮ CỦA TỪNG PHÒNG BAN
-- HƯỚNG LOGIC:
-- lấy department name
-- số nhân viên nữ theo từng phòng ban = count(employeekey), điều kiện where là gender = F, group by (nhóm theo department name)

SELECT 
	DepartmentName,
	COUNT(EmployeeKey) as " số nhân viên nữ"
FROM DimEmployee
where Gender = 'F'
group by DepartmentName
-- Task 1: Lấy danh sách các giao dịch trong bảng [FactInternetSales] được đặt hàng kể từ ngày 2011-01-01 và được Ship đi trong năm 2011.
-- Your script:
-- sử dụng mệnh đề điều kiện thôi
select ProductKey,
	OrderDate,
	ShipDate
from FactInternetSales
where OrderDate >= '2011-01-01' and Year(ShipDate) = '2011'

-- Task 2: Lấy danh sách các ProductKey từ bảng [DimProduct] có tên sảm phẩm chứa "red"
-- Your script:

select ProductKey,
	 EnglishProductName
from DimProduct
where EnglishProductName Like '%Red%'