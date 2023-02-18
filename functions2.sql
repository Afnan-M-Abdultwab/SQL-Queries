--QUESTION 1	
SELECT * FROM [dbo].[IntValues](12,4);

--QUESTION2
create function EmpInfo()
returns table --([EmployeeID] int ,[Title] nvarchar(50) ,[MaritalStatus] nchar(1),[Gender] nchar(1) )
AS

	RETURN 
	SELECT P.[FirstName]+P.[LastName] as FullName ,E.[Title],CASE E.[MaritalStatus]
	WHEN 'M' THEN 'Married'
	WHEN 'S' THEN 'Single'
	END AS 'Martial Status',CASE E.[Gender]
	WHEN 'F' THEN 'Female'
	WHEN 'M' THEN 'Male'
	END AS 'Gender'

	FROM [HumanResources].[Employee] AS E JOIN [Person].[Contact] AS P 
	ON P.[ContactID] = E.[EmployeeID];

	select * from EmpInfo();

--QUESTION3

ALTER FUNCTION ExpInfo()
returns table
AS
	RETURN
	SELECT  P.[FirstName]+P.[LastName] as FullName ,E.[Title] , CONVERT(int , GETDATE()-E.[HireDate] , 106) AS YearsOfExp , convert(date, DATEADD(YEAR , 21 ,E.[BirthDate]) ,106) as GradYear

	FROM [HumanResources].[Employee] AS E JOIN [Person].[Contact] AS P 
	ON P.[ContactID] = E.[EmployeeID];

select * from ExpInfo();

--QUESTION 4

CREATE FUNCTION TotSal(@Salary float , @YearOfExp int)
returns float 
BEGIN
	DECLARE @RES FLOAT 
	IF @YearOfExp < 8
	SET @RES= @YearOfExp *0.1 *@Salary + @Salary;
	ELSE
	SET @RES=0.7*@Salary + @Salary;
	RETURN @RES 
END

SELECT [dbo].[TotSal](2837 , 3) as total_salary;


--QUESTION 5

CREATE FUNCTION TopSal(@DepID int)
returns table 
AS
	return
	select top(5) EmpFname + EmpLname as FullName ,[Salary]
	from [SD3x-Company].dbo.Employee
	where [DeptNo]=@DepID
	order by Salary DESC;

SELECT * FROM TopSal(2);


--QUESTION 6
CREATE TABLE STUDENTS
(
	StuID INT , StuName nvarchar(50) , StuBD Date , StuAge as DATEDIFF(year , StuBD , GETDATE())

);

INSERT INTO STUDENTS
VALUES (1 , 'Afnan' , '1997-10-10');

select * from STUDENTS;