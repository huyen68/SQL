


---tổng hợp dữ liệu của theo trường input và output theo từng tháng trong năm của từng product-- (xong)--

-- còn trường hợp theo từng ngày trong tuần nữa-- (chưa làm nhưng hướng làm cũng tương tự--

WITH input AS
	(SELECT 
	MONTH(createtime) as M,
	YEAR(createtime) as Y,
	productID,
	SUM(Quantity) as InputAmount
	from taskregister
	WHERE historytype = 0
	group by 
	MONTH(createtime),
	YEAR(createtime), 
	productID
),

output1
As (
	SELECT 
	MONTH(createtime) as M,
	YEAR(createtime) as Y,
	productID,
	SUM(Quantity) as OutputAmount
from taskregister
WHERE historytype = 1
group by  
MONTH(createtime),
YEAR(createtime), 
productID
)

select 
ISNULL(i1.M,i2.M) as M,
isnull(i1.Y, i2.Y) as Y,
isnull(i1.productID, i2.productID) as productID, 
OutputAmount,
InputAmount
from input as i1
full outer join output1 as i2 on 
	i1.M = i2.M
and i1.Y = i2.Y
and i1.productID = i2.productID
order by M ASC, Y ASC, productID ASC

