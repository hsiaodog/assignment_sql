--Answer following questions
--1.	In SQL Server, assuming you can find the result by using both joins and subqueries, 
--      which one would you prefer to use and why?

--  Generally, using joins is better than subqueries. However, we should check the efficiency by using clause "set statistics IO on".

--2.	What is CTE and when to use it?
--  Create a recursive query.
--  Substitute for a view when the general use of a view is not required; that is, you do not have to store the definition in metadata.
--  Using a CTE offers the advantages of improved readability and ease in maintenance of complex queries. The query can be divided into separate, simple, logical building blocks. These simple blocks can then be used to build more complex, interim CTEs until the final result set is generated. 
--  CTEs can be defined in user-defined routines, such as functions, stored procedures, triggers, or views.


--3.	What are Table Variables? What is their scope and where are they created in SQL Server?
--  Table variables is same as temporary table. Single query cannot be executed. It can process a few operation. It is stored in the RAM use less memory.

--4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
--  Although they both processes on table, there are several difference between them.
--  1. Truncate reseeds identity values, whereas delete doesn't. Truncate will reset the identity values to be initial value.
--  2. Truncate removes all records and doesn't fire triggers.
--  3. Truncate is faster compared to delete as it makes less use of the transaction log.
--  4. Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.
--  5. Delete processes one or more rows, while Truncate porcesses all.

--5.	What is Identity column? How does DELETE and TRUNCATE affect it?
--  The identity column is the title of column which represents a column. 
--  If DELETE processes whole table, the whole table will be eliminated. But TRUNCATE only clean the all values but does not eliminate table.
--  Therefore, identity column will be eliminated after DELETE, while identity column will not be eliminated after TRUNCATE.

--6.	What is difference between “delete from table_name” and “truncate table table_name”?
--  “delete from table_name” processes whole table and the whole table will be eliminated. But keeping the value in memory.
--  “truncate table table_name” cleans the all values. The 


--Write queries for following scenarios
--All scenarios are based on Database NORTHWND.
USE Northwind
GO
--1.	List all cities that have both Employees and Customers.
select City from Employees
union 
select City from Customers

--2.	List all cities that have Customers but no Employee.
set statistics IO on
--a.	Use sub-query
select distinct c.City from Customers c
where c.City not in (select distinct e.City from Employees e)
--b.	Do not use sub-query ***
select distinct City from Customers 
EXCEPT
select distinct City from Employees

--3.	List all products and their total order quantities throughout all orders.
select * from Products
select * from orders
select * from [Order Details]

select p.ProductName, SUM(d.Quantity) Total
from Products p left join [Order Details] d
on p.ProductID = d.ProductID
group by p.ProductName
--4.	List all Customer Cities and total products ordered by that city.
select * from Products
select * from orders
select * from [Order Details]
select * from Customers

select c.City, SUM(d.Quantity) Total
from Customers c left join Orders o
on c.CustomerID = o.CustomerID
left join [Order Details] d
on o.OrderID = d.OrderID
Group by c.City

--5.	List all Customer Cities that have at least two customers.
select * from Customers

--a.	Use union
select City from Customers
select City from 

--b.	Use sub-query and no union

--6.	List all Customer Cities that have ordered at least two different kinds of products.


--7.	List all Customers who have ordered products, 
--      but have the ‘ship city’ on the order different from their own customer cities.
--8.	List 5 most popular products, their average price, 
--      and the customer city that ordered most quantity of it.
select * from Products
select * from orders
select * from [Order Details]
select * from Customers

select top 5 p.ProductName, d.UnitPrice [average price], c.City, SUM(d.Quantity)
from Products p left join [Order Details] d
on p.ProductID = d.ProductID
left join Orders o
on d.OrderID = o.OrderID
left join Customers c
on o.CustomerID = c.CustomerID
group by p.ProductName, d.UnitPrice, c.City
ORDER by SUM(d.Quantity) desc

--9.	List all cities that have never ordered something but we have employees there.
--a.	Use sub-query
--b.	Do not use sub-query
--10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--      and also the city of most total quantity of products ordered from. (tip: join  sub-query)
--11.   How do you remove the duplicates record of a table?
--12.   Sample table to be used for solutions below- 
--      Employee ( empid integer, mgrid integer, deptid integer, salary integer) Dept (deptid integer, deptname text)
--      Find employees who do not manage anybody.
--13.   Find departments that have maximum number of employees. 
--      (solution should consider scenario having more than 1 departments that have maximum number of employees). 
--      Result should only have - deptname, count of employees sorted by deptname.
--14.   Find top 3 employees (salary based) in every department. 
--      Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
