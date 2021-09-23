--Answer following questions
--1.	What is View? What are the benefits of using views? 
--  view is considered as an temp table. however, it is working on the base table directly. 
--  It is good for pre-porcess some table for someone who are not get used to utlize the query.

--2.	Can data be modified through views?
--  yes, we can.

--3.	What is stored procedure and what are the benefits of using it?
--  it package the procedure and callable function. 
--  However, it is not good to process the calcuation. if you want, use function. 
--  It can prevent the sql injection problem.

--4.	What is the difference between view and stored procedure?
--  
--5.	What is the difference between stored procedure and functions?
--  stored procedure is not good to process the calcuation. if you want, use function.

--6.	Can stored procedure return multiple result sets?
--  yes, it can.

--7.	Can stored procedure be executed as part of SELECT Statement? Why?
--  No. stored procedure is for processing the table with update, insert, delete, and etc. 
--  However, if we want to process the data in select, we need to use function.

--8.	What is Trigger? What types of Triggers are there?
--  Trigger is considered as a automatically stored procedure. there are delete and insert.

--9.	What are the scenarios to use Triggers?
--  If you want to process a procedure automatically, you can use trigger.

--10.	What is the difference between Trigger and Stored Procedure?
--  Trigger is to work automatically. stored procedure is to work manually.

--Write queries for following scenarios
--Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. 
USE Northwind
GO
--When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
--1.	Lock tables Region, Territories, EmployeeTerritories and Employees. Insert following information into the database. 
--      In case of an error, no changes should be made to DB.
select * into #Region from Region
select * into #Territories from Territories
select * into #EmployeeTerritories from EmployeeTerritories
select * into #Employees from Employees

--a.	A new region called “Middle Earth”;
select * from #Region
insert into #Region values(5,'Middle Earth')
--b.	A new territory called “Gondor”, belongs to region “Middle Earth”;
select * from #Region
select * from #Territories
select * from #EmployeeTerritories
select * from #Employees
Alter table #Territories
	add constraint FK_temp_region Foreign key(RegionID)
		references #Region(RegionID)
		on delete cascade
		on update cascade

insert into #Territories values (98105,'Gondor',(select r.RegionID from #Region r where r.RegionDescription = 'Middle Earth'))

--c.	A new employee “Aragorn King” who's territory is “Gondor”.
select * from #Region
select * from #Territories
select * from #EmployeeTerritories
select * from #Employees

alter table #EmployeeTerritories add foreign key (EmployeeID) references #EmployeeTerritories(EmployeeID)
alter table #EmployeeTerritories add foreign key (TerritoryID) references #Territories(TerritoryID)

insert into #Employees values ('King','Aragorn', null,null, null, null, null, null, null, null, null, null, null, null, null, null, null)
delete from #Employees where EmployeeID = 12
insert into #EmployeeTerritories 
values ((select e.EmployeeID from #Employees e where e.FirstName+' '+e.LastName='Aragorn King'),
(select t.TerritoryID from #Territories t where t.TerritoryDescription = 'Gondor'))

--2.	Change territory “Gondor” to “Arnor”.
select * from #Territories where TerritoryDescription = 'Gondor' or TerritoryDescription = 'Arnor'
update #Territories set TerritoryDescription = 'Arnor' where TerritoryDescription = 'Gondor'
select * from #Territories where TerritoryDescription = 'Gondor' or TerritoryDescription = 'Arnor'

--3.	Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) 
--      In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
delete from #Region where RegionDescription = 'Middle Earth'
select * from #Region where RegionDescription = 'Middle Earth'
--4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
select * from Products
select * from [Order Details]
select * from Orders

create view view_product_order_hsiao
as
select TOP (100) PERCENT p.ProductName, count(o.Quantity) total
from [Order Details] o join Products p
on o.ProductID = p.ProductID
group by p.ProductName
order by p.ProductName


select * from view_product_order_hsiao

drop view view_product_order_hsiao

--5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” 
--      that accept product id as an input and total quantities of order as output parameter.
select * from Products
select * from [Order Details]
select * from Orders

Create procedure sp_product_order_quantity_hsiao
@productid int,
@ttlqnty int out
as
begin
	select @ttlqnty = count(d.OrderID)
	from [Order Details] d
    where d.ProductID = @productid
	group by d.ProductID 
end

drop proc sp_product_order_quantity_hsiao

declare @ttl int
execute sp_product_order_quantity_hsiao 1, @ttl out
print(@ttl)

select d.ProductID, count(d.OrderID)
from [Order Details] d
group by d.ProductID
having d.ProductID = 1


--6.	Create a stored procedure “sp_product_order_city_[your_last_name]” 
--      that accept product name as an input and top 5 cities 
--      that ordered most that product combined with the total quantity of that product ordered from that city as output.
select * from Products
select * from [Order Details]
select * from Orders

create proc sp_product_order_city_hsiao
@porductname varchar(20)
as
begin
	select top 5 o.ShipCity
	from Products p join [Order Details] d
	on p.ProductID = d.ProductID
	join Orders o
	on o.OrderID = d.OrderID
	where p.ProductName = @porductname
	group by o.ShipCity
	order by sum(d.Quantity) desc
end

execute sp_product_order_city_hsiao 'Chai'

drop proc sp_product_order_city_hsiao

select top 5 o.ShipCity
from Products p join [Order Details] d
on p.ProductID = d.ProductID
join Orders o
on o.OrderID = d.OrderID
where p.ProductName = @porductname
group by o.ShipCity
order by sum(d.Quantity) desc

--7.	Lock tables Region, Territories, EmployeeTerritories and Employees. 
--      Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”; 
--      if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, 
--      and then move those employees to “Stevens Point”.
select * from Region
select * from Territories
select * from EmployeeTerritories
select * from Employees


create proc sp_move_employees_hsiao
as
begin
	set tran isolation level serializable
	begin tran
		declare @terr_num int
		set @terr_num =
			(select count(1)
			from Employees e join EmployeeTerritories et
			on e.EmployeeID = et.EmployeeID
			join Territories t
			on et.TerritoryID = t.TerritoryID
			where t.TerritoryDescription = 'Troy')
		print('num_terr: '+ CONVERT(varchar(10),@terr_num))
		if @terr_num > 0
			begin
				declare @terrid_tory int = (select TerritoryID from Territories where TerritoryDescription = 'Troy')
				insert into Territories values (98105,'Stevens Point', (select r.RegionID from Region r where r.RegionDescription = 'North'))
				update EmployeeTerritories set TerritoryID = 98105 where TerritoryID = @terrid_tory
			end
	commit	
end



--8.	Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. 
--      (After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.
create trigger tgr_100_emp_terr
on Employees
after insert
as
begin
	declare @num_terr int
	set @num_terr = 
	(select count(1)
	from EmployeeTerritories et join Territories t
	on et.TerritoryID = t.TerritoryID
	where t.TerritoryDescription = 'Stevens Point')
	if @num_terr > 100
		begin
			declare @terrid_troy int = (select TerritoryID from Territories where TerritoryID = 'Troy')
			declare @terrid_stevenspoint int = (select TerritoryID from Territories where TerritoryID = 'Stevens Point')
			update EmployeeTerritories set TerritoryID = @terrid_troy where TerritoryID = @terrid_stevenspoint
		end
end



--9.	Create 2 new tables “people_your_last_name” “city_your_last_name”.
--      City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--      People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--      Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
--      Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. 
--      (after test) Drop both tables and view.
create table city_your_hsiao(
	Id int primary key identity(1,1),
	City varchar(20) unique
)
create table people_your_hsiao(
	Id int primary key identity(1,1),
	Name varchar(20) unique,
	City int references city_your_hsiao(Id) on delete set null
)

insert into city_your_hsiao values ('Seattle'),('Green Bay')
select * from city_your_hsiao
insert into people_your_hsiao values ('Aaron Rodgers',2), ('Russell Wilson',1),('Jody Nelson',2)
select * from people_your_hsiao

delete from city_your_hsiao where City = 'Seattle'
select * from city_your_hsiao
select * from people_your_hsiao

insert into city_your_hsiao values ('Madison')
update people_your_hsiao set City = (select c.Id from city_your_hsiao c where c.City  = 'Madison') where City is Null
select * from city_your_hsiao
select * from people_your_hsiao

create view Packers_hsiao
as
select p.Name 
from people_your_hsiao p join city_your_hsiao c
on p.City = c.Id
where c.City = 'Green Bay'

drop table people_your_hsiao
drop table city_your_hsiao
drop view Packers_hsiao

--10.	Create a stored procedure “sp_birthday_employees_[you_last_name]” 
--      that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
--      (Make a screen shot) drop the table. Employee table should not be affected.
select * from Employees

create proc sp_birthday_employees_hsiao
as
begin
	select * into birthday_employees_your_hsiao from Employees
	where Month(BirthDate) = 2
end

drop proc sp_birthday_employees_hsiao
select * from Employees
select * from Employees where Month(BirthDate) = 2

sp_birthday_employees_hsiao
select * from birthday_employees_your_hsiao

select * from Employees
drop table birthday_employees_your_hsiao
select * from Employees


--11.	Create a stored procedure named “sp_your_last_name_1” 
--      that returns all cites that have at least 2 customers who have bought no or only one kind of product. 
--      Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).
select * from Products
select * from [Order Details]
select * from Orders
select * from Customers

create proc sp_your_hsiao_1
as 
begin
	select c.City, count(dt.CustomerID) ttl_c
	from Customers c left join
	(select o.CustomerID,count(d.ProductID)  ttl_p
		from Orders o join [Order Details] d 
		on o.OrderID = d.OrderID 
		group by o.CustomerID
		having count(d.ProductID) <=1) dt
	on c.CustomerID = dt.CustomerID
	group by c.City
	having count(dt.CustomerID) >=2
end

create proc sp_your_hsiao_2
as 
begin
	select * into #temp_dt 
	from (select o.CustomerID,count(d.ProductID)  ttl_p
		from Orders o join [Order Details] d 
		on o.OrderID = d.OrderID 
		group by o.CustomerID
		having count(d.ProductID) <=1) ddt
	select c.City, count(dt.CustomerID)
	from Customers c left join #temp_dt dt
	on c.CustomerID = dt.CustomerID
	group by c.City
	having count(dt.CustomerID) >=2
end





--12.	How do you make sure two tables have the same data?
select * into #Region_1 from Region
select * into #Region_2 from Region
select * into #Region_3 from Region
insert into #Region_3 values(5,'a')

set statistics io on
select count(*) from 
((select * from #Region_1 
union 
select * from #Region_3)
except
(select * from #Region_1 
intersect 
select * from #Region_3)) dt

--14.
--First Name	Last Name	Middle Name
--John			Green	
--Mike			White		M
--Output should be
--Full Name
--John Green
--Mike White M.
--Note: There is a dot after M when you output.
create table A(
	id int primary key identity(1,1),
	[First Name] varchar(20),
	[Last Name] varchar(20),
	[Middle Name] varchar(20)
)
insert into A values('John','Green', Null),('Mike','White', 'M')
select*from A

create function fun_combine_name(@fname varchar(20), @lname varchar(20),@mname varchar(4))
returns varchar(50)
as
begin
	if @mname is not Null
		return (@fname + ' ' + @lname +' '+ @mname +'.')
	return (@fname + ' ' + @lname)
end

drop function fun_combine_name

select dbo.fun_combine_name(a.[First Name],a.[Last Name],a.[Middle Name]) as [Full Name]
from A a
--15.
--Student	Marks	Sex
--Ci		70		F
--Bob		80		M
--Li		90		F
--Mi		95		M
--Find the top marks of Female students.
--If there are to students have the max score, only output one.
create table B(
	id int primary key identity(1,1),
	Student varchar(4),
	Marks int,
	Sex varchar(1)
)
insert into B values('Ci',70,'F'),('Bob',80,'M'),('Li',90,'F'),('Mi',95,'M')
select * from B
select top 1 Student from B
where Sex = 'F'
order by Marks desc

--16.
--Student	Marks	Sex
--Li		90		F
--Ci		70		F
--Mi		95		M
--Bob		80		M
--How do you out put this?

select *
from B
order by Sex asc, Marks desc


