--QUESTION 1 AND QUESTION 2


Alter proc USP_IndexByCursor (@LastLine int out)
as
begin
	declare Ins_cur cursor
		for select  [EmpNo],[EmpFname]  from [dbo].[Employee]
		for update
	declare @No int
	declare @Firstname varchar(50) 
	declare @counter int
	set @counter=1;
	open Ins_cur 
	begin
		fetch Ins_cur into @No,@Firstname --for enter while first time
		While @@fetch_status=0
		begin
			update [dbo].[Employee]
			set [No.]=@counter
			where CURRENT of ins_cur --Current row
			--where CustomerID=@idI 
			set @LastLine = @counter
			set @counter=@counter+1;
			fetch Ins_cur into @No,@Firstname
			
		end
	end
	close Ins_cur
	deallocate Ins_cur
END

declare @L int;
exec USP_IndexByCursor @L out;
select @L;
select * from [dbo].[Employee];

delete from [dbo].[Employee] where [EmpNo] =1;

--QUESTION 3


DECLARE @product_catID nvarchar, @product_catName nvarchar(50) ,@product nvarchar(50) , @message nvarchar(50);  

PRINT '-------- Category Products Report --------';  
DECLARE category_cursor CURSOR FOR   
	SELECT [ProductCategoryID], [Name]
	FROM [Production].[ProductCategory]
	ORDER BY[ProductCategoryID] ; 
 
OPEN category_cursor  

FETCH NEXT FROM category_cursor   
INTO @product_catID, @product_catName
WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = '----- Products From this category: ' +   
        @product_catName

    PRINT @message  

    -- Declare an inner cursor based     
    -- on productCat_id from the outer cursor.  

    DECLARE product_cursor CURSOR FOR   
    SELECT P.Name  
    FROM [Production].[ProductCategory] pc, Production.Product P ,[Production].[ProductSubcategory] S
    WHERE S.ProductSubcategoryID = P.ProductSubcategoryID AND  
	S.ProductCategoryID = pc.ProductCategoryID AND
	 pc.ProductCategoryID = @product_catID  -- Variable value from the outer cursor  

    OPEN product_cursor  
    FETCH NEXT FROM product_cursor INTO @product  

    IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

        SELECT @message = '         ' + @product  
        PRINT @message  
        FETCH NEXT FROM product_cursor INTO @product  
   END  

    CLOSE product_cursor  
    DEALLOCATE product_cursor  
        -- Get the next vendor.  
    FETCH NEXT FROM category_cursor   
    INTO @product_catID, @product_catName
END -- End While Parernt Cursor   
CLOSE category_cursor;  
DEALLOCATE category_cursor;


---QUESTION 4

--Create a  clustered index on Employee table (EmpNo column). 

create clustered index cindex
	on [dbo].[Employee]([EmpNo]);

-- can it be created yes or no and why? NO IT CAN'T BE CREATED AS THE PK IS ALREADY USED AS A CLUSTERED INDEX BY DEFAULT


--If not, create new table, and try to create cluster index on the ID column of it. 

GO
USE AdventureWorks
GO
drop table HumanResources.TerminationReason

CREATE TABLE HumanResources.TerminationReason(
TerminationReasonID smallint IDENTITY(1,1) NOT NULL,
TerminationReason varchar(50) NOT NULL,
DepartmentID smallint NOT NULL,
CONSTRAINT FK_TerminationReason_DepartmentID
FOREIGN KEY (DepartmentID) REFERENCES
HumanResources.Department(DepartmentID)
)


create clustered index index2
	on HumanResources.TerminationReason(DepartmentID)

create clustered index cindex
	on HumanResources.TerminationReason(TerminationReasonID)


drop index HumanResources.TerminationReason.cindex
--Can you create a clustered index on a column that isn’t a primary key? 
--Yes a clustered index can be on any column but it's prefered to be on PK

--Does SQL server create a clustered index on the primary kery as default? yes

--Can you change it and make it as a non-clustered index and create a clustered index on other column? yes
create nonclustered index noncindex
	on HumanResources.TerminationReason(TerminationReasonID);


--QUESTION 5
CREATE NONCLUSTERED INDEX NONCLUS
	on [dbo].[Employee]([EmpFname])

--what is an index? An index is an on-disk structure associated with a table or view
--that speeds retrieval of rows from the table or view


--QUESTION 6
SELECT top(10) P.[Name] , pr.ListPrice
FROM [Production].[Product] P ,[Production].[ProductListPriceHistory] pr
where pr.ProductID = P.ProductID
order by pr.ListPrice desc


SELECT top(10) percent P.[Name] , pr.ListPrice
FROM [Production].[Product] P ,[Production].[ProductListPriceHistory] pr
where pr.ProductID = P.ProductID
order by pr.ListPrice desc


SELECT top(10) percent with ties
P.[Name] , pr.ListPrice
FROM [Production].[Product] P ,[Production].[ProductListPriceHistory] pr
where pr.ProductID = P.ProductID
order by pr.ListPrice desc


select  ROW_NUMBER() over (order by [Name] desc) as row_num ,[Name],[ListPrice]
from [Production].[Product];


SELECT P.[Name] , pr.ListPrice
FROM [Production].[Product] P ,[Production].[ProductListPriceHistory] pr
where pr.ProductID = P.ProductID
order by pr.ListPrice desc
OFFSET 10 ROWS  FETCH NEXT 10 ROWS ONLY; 

SELECT P.[Name] , pr.ListPrice
FROM [Production].[Product] P ,[Production].[ProductListPriceHistory] pr
where pr.ProductID = P.ProductID
order by newid() --order by RAND()
--OFFSET 0 ROWS  FETCH NEXT 10 ROWS ONLY;


select top 10 percent * from [Production].[Product]  order by newid();


---QUESTION 7
select * from [dbo].[Employee]
for xml PATH;


--QUESTION 8
 DECLARE @xmlData XML;  
SET @xmlData = '<root>
  <ID>
    <id_number>7</id_number>
  </ID>
  <QuesText>
    <ques_number>1</ques_number>
     <ques>how are you</ques>
  </QuesText>
  <AnswersKeyword>
     <ans_number>1</ans_number>
     <ans>I am good</ans>
  </AnswersKeyword>
</root>'


  DECLARE @textQues INT;
   EXEC sp_xml_preparedocument @textQues OUTPUT, @xmlData

   SELECT * 
   FROM  OPENXML (@textQues, '/root', 2)
   WITH (ID VARCHAR(2),
         QuesText VARCHAR(100),
         AnswersKeyword VARCHAR(100));

CREATE TABLE textQues (ID INT,QuesText VARCHAR(50) ,AnswersKeyword VARCHAR(50),  x XML);  
GO  
INSERT INTO textQues VALUES(1,'HOW ARE YOU?' , 'I AM GOOD THANKS!','<root>
  <ID>
    <id_number>7</id_number>
  </ID>
  <QuesText>
    <ques_number>1</ques_number>
     <ques>how are you</ques>
  </QuesText>
  <AnswersKeyword>
     <ans_number>1</ans_number>
     <ans>I am good</ans>
  </AnswersKeyword>
</root>');  

select * from [dbo].[textQues];


