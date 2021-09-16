--Answer following questions
--1.	What is a result set?
-- The result set is output data from the tables with the conditions.

--2.	What is the difference between Union and Union All?
-- Union will show up result set of the two result sets with distinct data.
-- However, union all will show up result set of the two result sets with all data.

--3.	What are the other Set Operators SQL Server has?
-- Union, Union all, Intersect, except

--4.	What is the difference between Union and Join?
-- union: combining two result sets with same column as one result set
-- join: showing the result set from the two result sets with the same condictions. 

--5.	What is the difference between INNER JOIN and FULL JOIN?
--   inner join show up all match rows from two tables
--   full join show up all rows from two tables including non-match rows.

--6.	What is difference between left join and outer join
-- left join is sub-method of outer join.

--7.	What is cross join?
-- the result set of Cartesian products of the two tables

--8.	What is the difference between WHERE clause and HAVING clause?
-- both are for setting condition. However, where cannot accept function applying on columns. 
-- If there is function on selected columns, it required to use having such as count() or avg().

--9.	Can there be multiple group by columns?
-- Group by can contain multiple columns but cannot accept multiple clause of group by.

--Write queries for following scenarios
USE AdventureWorks2019
GO

--1.	How many products can you find in the Production.Product table?
SELECT DISTINCT COUNT(Name)
FROM Production.Product

--2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--      The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.


--3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--ProductSubcategoryID CountedProducts
---------------------- ---------------
SELECT ProductSubcategoryID, COUNT(Name) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID

--4.	How many products that do not have a product subcategory. 
SELECT COUNT(Name) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING ProductSubcategoryID IS NULL

--5.	Write a query to list the summary of products quantity in the Production.ProductInventory table.
SELECT ProductID, Quantity
FROM Production.ProductInventory

--6.	Write a query to list the summary of products in the Production.ProductInventory table 
--      and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--              ProductID    TheSum
-------------        ----------

SELECT ProductID, SUM(Quantity) AS TheSum 
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7.	Write a query to list the summary of products with the shelf information in the Production.
--      ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--Shelf      ProductID    TheSum
------------ -----------        -----------

SELECT Shelf, ProductID, SUM(Quantity) AS TheSum 
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf ,ProductID
HAVING SUM(Quantity) < 100


--8.	Write the query to list the average quantity for products 
--      where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID,LocationID, AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID, LocationID


--9.	Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
------------- ---------- -----------
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY Shelf,  ProductID
ORDER BY Shelf


--10.	Write query  to see the average quantity  of  products by shelf excluding rows 
--      that has the value of N/A in the column Shelf from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
------------- ---------- -----------
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY Shelf,  ProductID
ORDER BY Shelf


--11.	List the members (rows) and average list price in the Production.Product table. 
--      This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--Color           	Class 	TheCount   	 AvgPrice
----------------	- ----- 	----------- 	---------------------
SELECT Color, Class, COUNT(1) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class


--Joins:
--12.	  Write a query that lists the country and province names from person. 
--        CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

--Country                        Province
-----------                          ----------------------
SELECT *
FROM Person.CountryRegion

SELECT *
FROM Person.StateProvince

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

--13.	Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables  
--      and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

--Country                        Province
-----------                          ----------------------

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')
ORDER BY c.Name

--        Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind
GO
--14.	List all Products that has been sold at least once in last 25 years.

SELECT *
FROM Products
SELECT *
FROM Orders
SELECT *
FROM [Order Details]

SELECT p.ProductID, p.ProductName, COUNT(1) AS TIMES
FROM Products p JOIN [Order Details] d
ON p.ProductID = d.ProductID
JOIN Orders o 
ON d.OrderID = o.OrderID
WHERE DATEDIFF(yy,o.OrderDate,GETDATE())<25
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductID
--15.	List top 5 locations (Zip Code) where the products sold most.
SELECT *
FROM Products
SELECT *
FROM Orders
SELECT *
FROM [Order Details]

SELECT TOP 5 o.ShipPostalCode, COUNT(1) AS TIMES
FROM Products p JOIN [Order Details] d
ON p.ProductID = d.ProductID
JOIN Orders o 
ON d.OrderID = o.OrderID
WHERE DATEDIFF(yy,o.OrderDate,GETDATE())<25
GROUP BY  o.ShipPostalCode
ORDER BY TIMES DESC

--16.	List top 5 locations (Zip Code) where the products sold most in last 20 years.
SELECT TOP 5 o.ShipPostalCode, COUNT(1) AS TIMES
FROM Products p JOIN [Order Details] d
ON p.ProductID = d.ProductID
JOIN Orders o 
ON d.OrderID = o.OrderID
WHERE DATEDIFF(yy,o.OrderDate,GETDATE())<20
GROUP BY  o.ShipPostalCode
ORDER BY TIMES DESC

--17.	 List all city names and number of customers in that city.     
SELECT *
FROM Customers

SELECT DISTINCT c.City, COUNT(1) AS Numbers
FROM Customers c
GROUP BY c.City

--18.	List city names which have more than 10 customers, and number of customers in that city 
SELECT DISTINCT c.City, COUNT(1) AS Numbers
FROM Customers c
GROUP BY c.City
HAVING COUNT(1) >=10

--19.	List the names of customers who placed orders after 1/1/98 with order date.
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Customers

SELECT c.CompanyName, COUNT(1) AS TIMES
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '1/1/1998' AND GETDATE()
GROUP BY c.CompanyName

--20.	List the names of all customers with most recent order dates ****
SELECT c.CompanyName, COUNT(1) AS TIMES, o.OrderDate
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName, o.OrderDate
ORDER BY o.OrderDate DESC

--21.	Display the names of all customers  along with the  count of products they bought 
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM Customers
SELECT * FROM [Order Details]

SELECT c.CompanyName, COUNT(d.Quantity) AS Q
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] d
ON o.OrderID = d.OrderID
JOIN Products p
ON d.ProductID = p.ProductID
GROUP BY c.CompanyName
ORDER BY Q

--22.	Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CompanyName, COUNT(d.Quantity) AS Q
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] d
ON o.OrderID = d.OrderID
JOIN Products p
ON d.ProductID = p.ProductID
GROUP BY c.CompanyName
HAVING COUNT(d.Quantity) > 100
ORDER BY Q
--23.	List all of the possible ways that suppliers can ship their products. Display the results as below
--Supplier Company Name   	Shipping Company Name
-----------------------------------            ----------------------------------
SELECT AS [Supplier Company Name],   	AS [Shipping Company Name]
FROM 

--24.	Display the products order each day. Show Order date and Product Name.
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM Customers
SELECT * FROM [Order Details]

SELECT o.OrderDate, p.ProductName
FROM Orders o JOIN [Order Details] d
ON o.OrderID = d.OrderID
JOIN Products p
ON d.ProductID = p.ProductID
ORDER BY o.OrderDate

--25.	Displays pairs of employees who have the same job title.
SELECT * FROM Employees

SELECT Title,COUNT(1) 
FROM Employees
GROUP BY Title

--26.	Display all the Managers who have more than 2 employees reporting to them.


--27.	Display the customers and suppliers by city. The results should have the following columns
--City 
--Name 
--Contact Name,
--Type (Customer or Supplier)
SELECT * FROM Employees
SELECT * FROM Suppliers

SELECT e.City, e.FirstName+e.LastName AS [Name], s.ContactName, AS [Type (Customer or Supplier)]
FROM Employees e FULL JOIN Suppliers s
ON e.City = s.City
-- 28. Have two tables T1 and T2
--F1.T1	F2.T2
--1	2
--2	3
--3	4

--Please write a query to inner join these two tables and write down the result of this query.


-- 29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
