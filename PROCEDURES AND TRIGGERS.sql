---QUESTION 1

--A
ALTER TABLE [dbo].[Employee]
ADD IsDeleted BIT NOT NULL DEFAULT 0;
GO

--B
CREATE TRIGGER SoftDelete 
on [dbo].[Employee] INSTEAD OF DELETE 
AS
BEGIN
SET NOCOUNT ON;
UPDATE [dbo].[Employee]
	set IsDeleted =1
	where EmpNo In (SELECT EmpNo FROM deleted);
END

SELECT * FROM [dbo].[Employee];

--C
ALTER VIEW EmpView
AS
SELECT EmpNo , EmpFname , EmpLname , DeptNo , Salary FROM [dbo].[Employee] 
WHERE IsDeleted =0;
Go

select * from EmpView;

--D
DELETE FROM [dbo].[Employee]
WHERE EmpFname = 'meen';

--E
SELECT * FROM EmpView;
SELECT * FROM Employee;
--the difference is the view shows only the undeleted records (IsDeleted=0) while the employee table shows
--them all with IsDeleted = 1 


---QUESTION 2

CREATE TABLE BudgetChangeAudit (ID int identity(1,1) , ProjectNo varchar(20) , UserName varchar(50) , ModifiedDate Date ,Budget_Old money , Budget_New money)
go

ALTER Trigger BudUpdateAudit
on [dbo].[Project] After Update
AS
BEGIN
	IF UPDATE ([Budjet])
	INSERT INTO [dbo].[BudgetChangeAudit] (ProjectNo , UserName , ModifiedDate , Budget_Old , Budget_New)
	VALUES(  NULL , SUSER_NAME() , GETDATE() ,
	(select Budjet from deleted) , (select Budjet from inserted) );
	UPDATE [dbo].[BudgetChangeAudit]
	SET [dbo].[BudgetChangeAudit].[ProjectNo] = [dbo].[Project].ProjectNo
	FROM [dbo].[Project]
END


UPDATE [dbo].[Project]
SET Budjet= 90000
WHERE ProjectNo ='p5';

select * from [dbo].[Project];

select * from [dbo].[BudgetChangeAudit];

---QUESTION 3


CREATE TYPE EmpInfo AS TABLE
(
 ID INT ,	
 [DeptNo] varchar(2),
[Salary] float,
[EmpFname] varchar(50),
[EmpLname] varchar(50),
[IsDeleted] bit
)

GO
CREATE PROC InsertInfo (@EmpDetails EmpInfo READONLY)
AS
BEGIN
	 INSERT INTO [dbo].[Employee]
	 SELECT * FROM @EmpDetails
	 UPDATE [dbo].[Employee]
	 SET EmpFname = UPPER(EmpFname) , EmpLname = UPPER(EmpLname);

END
GO
declare @EMP AS EmpInfo;
insert into @EMP VALUES ( 117 , 'p2' , 1826 , 'Joseph' , 'Gamal' , 0) , (182 , 'p1' , 5265 , 'NANA' , 'MO' , 0);

execute InsertInfo @EMP

select * from [dbo].[Employee];
GO
alter table [dbo].[Employee]
drop column [No.] ;
go
---QUESTION 4
ALTER PROC [dbo].[InsertInfo](@ID int ,  @DepName nvarchar(30) , @Salary float ,@Fname varchar(50) , @Lname varchar(50) , @IsDelete bit)
AS
BEGIN
	INSERT INTO Employee
	VALUES (@ID , (SELECT [DeptNo] FROM [Company].[Department] WHERE @DepName = [Company].[Department].DepatName) ,
	@Salary ,  @Fname , @Lname ,@IsDelete)
END

execute InsertInfo 18 , 'Research' , 1823, 'LOLO' , 'SOSO',0;

select * from Employee;

GO
---QUESTION 5
ALTER PROC [dbo].[InsertInfo](@ID int ,  @DepNo varchar(2) , @Salary float ,@Fname varchar(50) , @Lname varchar(50) , @IsDelete bit)
AS
BEGIN
declare @E int
IF (LEN(@Fname) < 3)
set @E= -1 
ELSE IF(LEN(@Lname) < 3)
set @E= -2
ELSE IF (@DepNo NOT IN(SELECT  [DeptNo] FROM [Company].[Department]))
set @E= -3 


BEGIN TRY
	INSERT INTO [dbo].[Employee] 
	VALUES (@ID , @DepNo , @Salary , @Fname , @Lname , @IsDelete)

END TRY

BEGIN CATCH
	set @E = @@ERROR
END CATCH
	RETURN @E
END

declare @r int;
execute @r =InsertInfo 89 , 'xx' , 1758, 'mariam' , 'K',0;
select @r;

GO
---question 6

alter procedure InsertInfo(@EmpNo int , @Fname varchar(50),@Lname varchar(50), @depNo varchar(2) ,
@salary float , @isDeleted bit, @no int out )
as
begin


begin try 
insert into [dbo].[Employee] values(@EmpNo , @depNo , @salary   , @Fname ,@Lname  , @isDeleted )
set @no = @EmpNo

end try
begin catch
set @no = 0

end catch

end

declare @n int;
exec  InsertInfo 48 ,'d2','mousa','shady',5261,0 ,@n out;
select @n;
select* from [dbo].[Employee];