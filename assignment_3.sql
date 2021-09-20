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
select City from Customers 
EXCEPT
select City from Employees

select distinct c.City
from  Customers c left join Employees e
on c.City = e.City
where e.City is Null

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
select c.City, count(1)
from Customers c
group by c.City
having count(1) >=2

--b.	Use sub-query and no union
select * from (select c.City,Count(c.CustomerID) total from Customers c
group by c.city) dt
where total >= 2

--6.	List all Customer Cities that have ordered at least two different kinds of products.
select * from [Order Details]
select * from Orders

select c.City, count(d.ProductID)
from Customers c join Orders o
on c.CustomerID = o.CustomerID
join [Order Details] d
on o.OrderID = d.OrderID
group by c.City
having count(d.ProductID) >=2


--7.	List all Customers who have ordered products, 
--      but have the ‘ship city’ on the order different from their own customer cities.
select * from Products
select * from orders
select * from [Order Details]
select * from Customers

select * from (select c.ContactName, c.City, o.ShipCity
from Customers c join Orders o
on c.CustomerID = o.CustomerID) dt
where dt.City != dt.ShipCity



--8.	List 5 most popular products, their average price, 
--      and the customer city that ordered most quantity of it.
select * from Products
select * from orders
select * from [Order Details]
select * from Customers

select top 5 p.ProductName, d.UnitPrice [average price], c.City,SUM(d.Quantity)
from Products p inner join [Order Details] d
on p.ProductID = d.ProductID
inner join Orders o
on d.OrderID = o.OrderID
inner join Customers c
on o.CustomerID = c.CustomerID
group by p.ProductName, d.UnitPrice, c.City
ORDER by SUM(d.Quantity) desc

--9.	List all cities that have never ordered something but we have employees there.
select * from Products
select * from [Order Details]
select * from orders
select * from Customers
select * from Employees

--a.	Use sub-query
select distinct e.City 
From Employees e
where e.City not in 
(select distinct c.City
from Customers c
where c.CustomerID in (select o.CustomerID from Orders o))


--b.	Do not use sub-query
select distinct e.City 
From Employees e
except
select distinct c.City
from Customers c join Orders o
on o.CustomerID = c.CustomerID

select distinct e.City 
from Customers c join Orders o
on c.CustomerID = o.CustomerID
right join Employees e
on c.City = e.City
where c.City is Null

--10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--      and also the city of most total quantity of products ordered from. (tip: join  sub-query)
select * from Products
select * from [Order Details]
select * from orders
select * from Customers
select * from Employees

select dt.City 
from (select e.City,count(o.OrderID) number, rank() over (order by count(o.OrderID) desc) as rnk
from Employees e join Orders o
on e.EmployeeID = o.EmployeeID
group by e.City) dt
where rnk = 1


select dt.City
from (select e.City, count(d.Quantity) number, rank() over (order by count(d.Quantity) desc) as rnk
from Employees e join Orders o
on e.EmployeeID = o.EmployeeID
join [Order Details] d
on d.OrderID = o.OrderID
group by e.City) dt
where rnk = 1

--11.   How do you remove the duplicates record of a table?
create table original_table (key_value int )

insert into original_table values (1)
insert into original_table values (1)
insert into original_table values (1)

insert into original_table values (2)
insert into original_table values (2)
insert into original_table values (2)
insert into original_table values (2)
select * from original_table
delete dt from (select *, ROW_NUMBER() over(partition by t.key_value order by (select NULL)) as rnk
from original_table t) dt
where dt.rnk >1
select * from original_table

--12.   Sample table to be used for solutions below-  ***
--      Employee ( empid integer, mgrid integer, deptid integer, salary integer) Dept (deptid integer, deptname text)
--      Find employees who do not manage anybody.

drop table Dept
drop table Employee


create table Dept(
	deptid int primary key identity(100,1),
	deptname varchar(32) unique
)

create table Employee(
	empid int primary key identity(1,1),
	mgrid int,
	deptid int REFERENCES Dept(deptid) ON DELETE CASCADE,
	salary decimal(6,2)
)

insert into Dept(deptname) values('dep_a'),('dep_b'),('dep_c'),('dep_d'),('dep_e'),('dep_f'),('dep_g'),('dep_h'),('dep_i'),('dep_j'),('dep_k');
insert into Employee values (1,100,6000.00),(1,100,5000.00),(1,100,4000.00),(1,100,3000.00),(1,100,2000.00),
(1,101,8000.00),(1,101,7000.00),(1,101,6000.00),(1,101,5000.00),(1,101,4000.00),
(1,102,3000.00),(1,102,2000.00),(1,103,4000.00),(1,103,3000.00),(1,104,2000.00),
(1,105,9000.00),(1,105,8000.00),(1,105,4000.00),(1,106,8000.00),(1,106,2000.00);
select * from Employee
select * from Dept
truncate table Employee

select e.empid
from Employee e
where e.empid not in (select m.mgrid from Employee m)

--13.   Find departments that have maximum number of employees. 
--      (solution should consider scenario having more than 1 departments that have maximum number of employees). 
--      Result should only have - deptname, count of employees sorted by deptname.
select dt.deptname, dt.[count of employees]
from (select d.deptname, count(e.empid) [count of employees],rank() over(order by count(e.empid) desc) rnk
from Dept d join Employee e
on d.deptid = e.deptid
group by d.deptname) dt
where rnk = 1
order by dt.deptname

--14.   Find top 3 employees (salary based) in every department. 
--      Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.

select dt.deptname,dt.empid,dt.salary
from (select d.deptname, e.empid, e.salary, rank() over (partition by d.deptname order by e.salary desc) as rnk
from Dept d join Employee e
on d.deptid = e.deptid) dt
where dt.rnk between 1 and 3

