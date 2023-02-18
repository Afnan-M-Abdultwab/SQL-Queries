---QUESTION 1

SELECT distinct pc.ProductCategoryID , pc.Name 
    FROM [Production].[ProductCategory] pc join [Production].[ProductSubcategory] S
	on S.ProductCategoryID = pc.ProductCategoryID 
	where exists (select [ListPrice] from [Production].[Product] p 
	where p.ProductSubcategoryID = S.ProductSubcategoryID and 
	ListPrice > 1000)

	--select [ProductID],[Name], [ListPrice] from [Production].[Product] where [ListPrice] >1000;


--QUESTION 2
--A
--The previous query uses CTE, what’s CTE in SQL Server? Common Table Expressions. 
--This SQL CTE is used to generate a temporary named set (like a temporary table)
--that exists for the duration of a query. used for complicated queries 

-- Explain the output of the previous query? the avr orders taken by each emp in staff in 2018

--What are temp tables in SQL server? And What’re the differences between global and local temp tables?  
--they are temporary tables used to do complicated queries or prechanges updates before implementing them
--##global temp gets disconnected when the last connected user closes it and it gets shown for all users
--on the server while #local temp is for 1 user and gets disconnected once he closes it

--Implement the same query using temo table. [Bonus] 
create table #mytemp
(staff_id int , order_date date , sales_order varchar(50) );

insert into #mytemp
values (1 , '2018-5-12' , 'burger' ) , ( 2, '2018-2-12' , 'shawerma') , (1, '2017-3-12' , 'cheese') , (2, '2018-2-12', 'milk')

select staff_id , count(sales_order) as order_counts
from #mytemp
where year(order_date) =2018
group by staff_id
--Compare CTE to temp tables? CTE on the batch level while temp tables on the session level


--QUESTION 3
WITH cte_products AS 
( SELECT COUNT(P.[Name]) num_of_products , pc.Name
    FROM [Production].[ProductCategory] pc , [Production].[ProductSubcategory] S , [Production].[Product] P
	WHERE S.ProductCategoryID = pc.ProductCategoryID AND P.ProductSubcategoryID = S.ProductSubcategoryID and P.ListPrice >0

GROUP BY pc.Name) 
select *
from cte_products;


--QUESTION 4
---QUESTION 5
