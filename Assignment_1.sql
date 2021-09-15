USE AdventureWorks2019
GO

--Q1
SELECT P.ProductID, P.Name, P.Color, P.ListPrice 
FROM Production.Product P;
GO

--Q2
SELECT P.ProductID, P.Name, P.Color, P.ListPrice 
FROM Production.Product P
WHERE P.ListPrice = 0;
GO

--Q3
SELECT P.ProductID, P.Name, P.Color, P.ListPrice 
FROM Production.Product P
WHERE P.Color IS NULL;
GO

--Q4
SELECT P.ProductID, P.Name, P.Color, P.ListPrice 
FROM Production.Product P
WHERE P.Color IS NOT NULL;
GO

--Q5
SELECT P.ProductID, P.Name, P.Color, P.ListPrice 
FROM Production.Product P
WHERE P.Color IS NOT NULL and P.ListPrice > 0;
GO

--Q6
SELECT P.Name, P.Color
FROM Production.Product P
WHERE P.Color IS NOT NULL;
GO

--Q7 RESULTS TO TEXT
SELECT ('NAME: '+P.NAME+' -- COLOR:'+P.Color) AS [Name And Color]
FROM Production.Product P
WHERE ('NAME: '+P.NAME+' -- COLOR:'+P.Color) IS NOT NULL;
GO

--Q8
SELECT P.ProductID, P.Name
FROM Production.Product P
WHERE P.ProductID BETWEEN 400 AND 500;
GO

--Q9
SELECT P.ProductID, P.Name, P.Color
FROM Production.Product P
WHERE P.Color IN ('black','blue');
GO

--Q10
SELECT P.Name
FROM Production.Product P
WHERE P.Name LIKE 'S%';
GO

--Q11 RESULTS TO TEXT
SELECT P.Name, P.ListPrice 
FROM Production.Product P
ORDER BY P.NAME;
GO

--Q12 RESULTS TO TEXT
SELECT P.Name, P.ListPrice 
FROM Production.Product P
WHERE P.Name LIKE 'A%' OR P.Name LIKE 'S%'
ORDER BY P.NAME;
GO

--Q13
SELECT P.Name
FROM Production.Product P
WHERE P.Name LIKE 'SPO%'
INTERSECT
SELECT P.Name
FROM Production.Product P
WHERE P.Name NOT LIKE 'SPOK%';
GO

-- or this method
SELECT Name
FROM (SELECT P.Name
FROM Production.Product P
WHERE P.Name LIKE 'SPO%') AS [NEW]
WHERE Name NOT LIKE '___K%';
GO

--Q14
SELECT DISTINCT P.Color
FROM Production.Product P
ORDER BY P.Color DESC;
GO

--Q15****
SELECT DISTINCT P.ProductSubcategoryID, P.Color
FROM Production.Product P
WHERE P.ProductSubcategoryID IS NOT NULL AND P.Color IS NOT NULL
ORDER BY P.ProductSubcategoryID, P.Color;
GO

--Q16
SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE NOT (Color IN ('Red','Black') 
      AND NOT ProductSubCategoryID = 1) 
	  OR ListPrice BETWEEN 1000 AND 2000
ORDER BY ProductID;
GO

--Q17 RESULTS TO TEXT-- not yet
SELECT DISTINCT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE ProductSubCategoryID BETWEEN 3 AND 11
	OR (ListPrice =539.99 AND ProductSubCategoryID=1)
	OR (ListPrice =1700.99 AND ProductSubCategoryID=2)
	OR (ListPrice =1364.50 AND ProductSubCategoryID=12)
	OR (ListPrice =1431.50 AND ProductSubCategoryID=14 AND (Color = 'Red' OR Name LIKE '%Black, 58'))
ORDER BY ProductSubCategoryID DESC, ListPrice DESC;

GO

