--Answer following questions
--1.	What is an object in SQL?
--  SQL objects are schemas, journals, catalogs, tables, aliases, views, indexes, constraints, triggers, 
--  sequences, stored procedures, user-defined functions, user-defined types, global variables, and SQL packages. 
--  SQL creates and maintains these objects as system objects.

--2.	What is Index? What are the advantages and disadvantages of using Indexes?
--  

--  advantage:	Speed up SELECT queries and reports
--				Reduce I/O and Lowest I/O
--				Fast Data Access
--				Prevent duplication (primary,unique)
--  disadvantage:	Indexes take additional disk space.
--					indexes slow down INSERT,UPDATE and DELETE, but will speed up UPDATE if the WHERE condition has an indexed field.  
--					INSERT, UPDATE and DELETE becomes slower because on each operation the indexes must also be updated. 


--3.	What are the types of Indexes?
--  There are clustered index and non-clustered Index.

--4.	Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--  Indexes are automatically created when PRIMARY KEY and UNIQUE constraints are defined on table columns.

--5.	Can a table have multiple clustered index? Why?
--  No. clustered index is unique for each table.

--6.	Can an index be created on multiple columns? Is yes, is the order of columns matter?
--  yes, it can be.

--  A composite key, in the context of relational databases, 
--  is a combination of two or more columns in a table that can be used to uniquely identify each row in the table. 
--  Uniqueness is only guaranteed when the columns are combined; when taken individually the columns do not guarantee uniqueness.
--  The order of the columns matters when it comes to improving performance of queries in your SQL Server.


--7.	Can indexes be created on views?
--  Yes, indexes can only be created on views which have the same owner as the referenced table or tables.

--8.	What is normalization? What are the steps (normal forms) to achieve normalization?
--  Database Normalization is a process of organizing data to minimize redundancy (data duplication), 
--  which in turn ensures data consistency. 

--  Three steps:
--		First Normal Form:	Data in each column should be atomic, no multiples values separated by comma.
--							The table does not contain any repeating column group
--							Identify each record using primary key.

--		Second Normal Form:	The table must meet all the conditions of 1NF
--							Move redundant data to separate table
--							Create relationships between these tables using foreign keys

--		Third Normal Form:	Table must meet all the conditions of 1NF and 2nd.
--							Does not contain columns that are not fully dependent on primary key.

--9.	What is denormalization and under which scenarios can it be preferable?
--  

--10.	How do you achieve Data Integrity in SQL Server?
--  Denormalization is a database optimization technique in which we add redundant data to one or more tables. 
--  This can help us avoid costly joins in a relational database.

--11.	What are the different kinds of constraint do SQL Server have?
--  1. NOT NULL 
--	2. Unique
--	3. PRIMARY KEY 
--	4. Foriegn Key
--	5. Check Constraints

--12.	What is the difference between Primary Key and Unique Key?
--  Unique key can be null, but Primary Key can not be Null.
--  Primary Key is a clustered index, unique key is a no-clustered index.
--  Primary key is ordered automatically, but unique is not.
--  Only one primary; can be more than one unique key.

--13.	What is foreign key?
--  A foreign key (FK) is a column or combination of columns that is used to establish and enforce a link between the data in two tables.
--  You can create a foreign key by defining a FOREIGN KEY constraint when you create or modify a table. 

--  A FOREIGN KEY constraint does not have to be linked only to a PRIMARY KEY constraint in another table; 
--  it can also be defined to reference the columns of a UNIQUE constraint in another table, or even any Indexes.  
--  In textbook, it has to be a PK of another table.

--14.	Can a table have multiple foreign keys?
--  Yes, it can.

--15.	Does a foreign key have to be unique? Can it be null?
--  it is not required. it can be Null or not unique.

--16.	Can we create indexes on Table Variables or Temporary Tables?
--  Yes.

--17.	What is Transaction? What types of transaction levels are there in SQL Server?
--  A transaction is a logical unit of work that contains one or more SQL statements. 
--  A transaction is an atomic unit. The effects of all the SQL statements
--  in a transaction can be either all committed (applied to the database) or all rolled back (undone from the database).

--  Transaction isolation levels: 
--				Read Uncommitted (Lowest level); 
--				Read Committed; 
--				Repeatable Read; 
--				Serializable (Highest Level); 
--				Snapshot Isolation;

--Write queries for following scenarios
--1.	Write an sql statement that will display the name of each customer 
--		and the sum of order totals placed by that customer during the year 2002
--		Create table customer(cust_id int,  iname varchar (50)) 
--		create table order(order_id int,cust_id int,amount money,order_date smalldatetime)

create database test
go
use test

create table customer(
	cust_id int primary key identity(1,1),
	iname varchar(50)
)
create table [order](
	order_id int primary key identity(100,1),
	cust_id int foreign key references customer(cust_id) on delete set null,
	[amount money] decimal(6,2),
	order_date date,
	smalldatetime date
)

select c.iname
from customer c join [order] o
on c.cust_id = o.cust_id
where year(o.order_date) = '2002'


--2.	The following table is used to store information about company’s personnel:
--		Create table person (id int, firstname varchar(100), lastname varchar(100)) write a query 
--		that returns all employees whose last names  start with “A”.
create table person (
	id int primary key identity(10,1), 
	firstname varchar(100), 
	lastname varchar(100))

select p.firstname+' '+p.lastname as fullname
from person p
where p.lastname like 'A%'


--3.	The information about company’s personnel is stored in the following table:
--		Create table person(person_id int primary key, manager_id int null, name varchar(100)not null) 
--		The filed managed_id contains the person_id of the employee’s manager.
--		Please write a query that would return the names of all top managers(an employee who does not have  a manger, 
--		and the number of people that report directly to this manager.
Create table person_1(
	person_id int primary key, 
	manager_id int default null, 
	[name] varchar(100) not null
) 

select p1.name,dt.ttl
from person_1 p1 join 
(select p.manager_id,COUNT(p.person_id) ttl
from person_1 p
where p.manager_id is null
group by p.manager_id)dt
on p1.person_id = dt.manager_id


--4.	List all events that can cause a trigger to be executed.
--  INSERT , UPDATE , or DELETE

--5.	Generate a destination schema in 3rd Normal Form.  Include all necessary fact, join, and dictionary tables, 
--		and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a.	Each Company can have one or more Divisions.
--b.	Each record in the Company table represents a unique combination 
--c.	Physical locations are associated with Divisions.
--d.	Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e.	Contacts can be associated with one or more divisions and the address, 
--		but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.

