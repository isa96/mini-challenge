use Northwind

/*
1. Shipper Analysis
Cari total shipping dari setiap kota dan rata-rata quantity dalam sekali pengiriman dan disortir ber
*/
SELECT o.ShipCountry, o.ShipCity, COUNT(*) as 'Total Shipping', AVG(od.Quantity) as 'Average Quantity'
FROM Orders o
JOIN [Order Details] od on od.OrderID = o.OrderID
JOIN Products p on p.ProductID = od.ProductID
JOIN Categories c on c.CategoryID = p.CategoryID
GROUP BY o.ShipCountry, o.ShipCity
ORDER BY  [Total Shipping] DESC, 'Average Quantity' DESC;

/*
2. Stock Analysis
Melihat total sales dan stock produk yang terdaftar dan membuat status untuk mempermudah dalam melakukan restock dengan ketentuan:
a. Jika ReorderLevel nya 0 dan UnitInStock nya kurang dari 20 dan UnitsOnOrder nya 0, maka statusnya 'Need to restock'
b. Jika UnitsInStock kurang dari ReorderLevel dan UnitsOnOrder = 0, maka statusnya 'Need to restock'
c. Jika UnitsInStock kurang dari ReorderLevel dan UnitsOnOrder lebih dari 0, maka statusnya 'On Order'
d. Jika UnitInStock lebih dari ReorderLevel, maka statusnya 'Ready'
*/
SELECT s.ProductName, s.Sales, p.UnitsInStock, p.UnitsOnOrder, 
		(p.UnitsInStock + p.UnitsOnOrder) as 'Total Stock',
		CASE
			WHEN p.ReorderLevel = 0 AND p.UnitsInStock < 20 AND p.UnitsOnOrder = 0  THEN 'Need to restock' 
			WHEN p.UnitsInStock < p.ReorderLevel AND p.UnitsOnOrder = 0  THEN 'Need to restock'
			WHEN p.UnitsInStock < p.ReorderLevel AND p.UnitsOnOrder > 0  THEN 'On Order'
			WHEN p.UnitsInStock > p.ReorderLevel THEN 'Ready'
		END as 'Stock Status',
		sup.CompanyName
FROM (
		SELECT DISTINCT(p.ProductName),
			SUM(od.Quantity * od.UnitPrice) as 'Sales'
		FROM Products p
		JOIN [Order Details] od on od.ProductID = p.ProductID
		GROUP BY p.ProductName
) as s
JOIN Products p on p.ProductName = s.ProductName
JOIN Suppliers sup on sup.SupplierID = p.SupplierID
ORDER BY s.Sales DESC


/*
3. Employee Analysis
Cari total sales dan transaksi tiap employee pada tahun 1998
*/

SELECT e.FirstName, e.LastName, e.Title,
	SUM(od.Quantity*od.UnitPrice) as 'Sales',
	r.RegionDescription,
	COUNT(od.OrderID) as 'Total Transaction'
FROM Orders o
LEFT JOIN [Order Details] od on od.OrderID = o.OrderID
LEFT JOIN Employees e on e.EmployeeID = o.EmployeeID
LEFT JOIN EmployeeTerritories et on et.EmployeeID = e.EmployeeID
LEFT JOIN Territories t on t.TerritoryID = et.TerritoryID
LEFT JOIN Region r on r.RegionID = t.RegionID
WHERE YEAR(o.OrderDate) = '1998'
GROUP BY r.RegionDescription, e.FirstName, e.LastName, e.Title
ORDER BY 'Sales' DESC