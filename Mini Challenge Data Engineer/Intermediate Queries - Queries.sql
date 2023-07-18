/*USE Northwind;*/

/*1. Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.*/
/*
SELECT DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate) - 1, '1900-01-01')) Month, COUNT(*) as 'Total Customer'
FROM Orders
WHERE YEAR(OrderDate) = '1997'
GROUP BY MONTH(OrderDate);
*/

/*2. Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.*/
/*
SELECT CONCAT(FirstName, LastName) as 'Employees Name'
FROM Employees
WHERE title = 'Sales Representative';
*/

/*3. Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.*/
/*
SELECT TOP 5 p.ProductID, p.ProductName, SUM(od.Quantity) as 'Quantity'
FROM Orders as o
JOIN [Order Details] as od on od.OrderID = o.OrderID
JOIN Products as p on p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate) = '1997' AND MONTH(o.OrderDate) = '1'
GROUP BY p.ProductID, p.ProductName
ORDER BY 3 DESC;
*/

/*4. Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.*/
/*
SELECT c.CompanyName
FROM Orders as o
JOIN [Order Details] as od on od.OrderID = o.OrderID
JOIN Products as p on p.ProductID = od.ProductID
JOIN Customers as c on c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = '1997' AND MONTH(o.OrderDate) = '6' AND p.ProductName = 'Chai';
*/

/*5. Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500.*/
/*
SELECT od.OrderID, 
		CASE
			WHEN SUM(od.Quantity*od.UnitPrice) <= 100 THEN '<=100'
			WHEN SUM(od.Quantity*od.UnitPrice) > 100 AND SUM(od.Quantity*od.UnitPrice) <= 250 THEN '100<x<=250'
			WHEN SUM(od.Quantity*od.UnitPrice) > 250 AND SUM(od.Quantity*od.UnitPrice) <= 500 THEN '250<x<=500'
			WHEN SUM(od.Quantity*od.UnitPrice) > 500 THEN '>500'
		END as 'Total Order'
FROM [Order Details] as od
GROUP BY od.OrderID
*/

/*6. Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997.*/
/*
SELECT DISTINCT(c.CompanyName)
FROM Customers as c
JOIN Orders as o on o.CustomerID = c.CustomerID
JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE od.Quantity*od.UnitPrice > 500;
*/

/*7. Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997.*/
/*
;WITH MonthsCTE(m) as
(
    SELECT 1 m
    UNION ALL 
    SELECT m+1
    FROM MonthsCTE
    WHERE m < 12
)
SELECT m [Month], t.*
FROM MonthsCTE
CROSS APPLY 
(
    SELECT TOP 5
		p.ProductName, 
		SUM(od.Quantity*od.UnitPrice) as 'Sales'
    FROM [Order Details] as od
	JOIN Products as p on p.ProductID = od.ProductID
	JOIN Orders as o on o.OrderID = od.OrderID
    WHERE  MONTH(o.OrderDate) = MonthsCTE.m
    GROUP BY p.ProductName
    ORDER BY 2 DESC
) t
*/

/*8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.*/
/*
CREATE VIEW details AS
SELECT od.OrderID, od.ProductID, p.ProductName, od.UnitPrice, od.Quantity, od.Discount, 
		((od.Quantity*od.UnitPrice)-(od.Quantity*od.UnitPrice*od.Discount)) as 'Total'
FROM [Order Details] as od
JOIN Products as p on p.ProductID = od.ProductID;

SELECT * FROM details;
*/

/*9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu.*/
/*
CREATE PROCEDURE Invoice @CustomerID nvarchar(5) AS
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate, o.RequiredDate, o.ShippedDate
FROM Customers as c
JOIN Orders as o on o.CustomerID = c.CustomerID
WHERE c.CustomerID = @CustomerID;

EXEC Invoice @CustomerID = 'ALFKI';
*/


