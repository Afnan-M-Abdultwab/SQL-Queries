USE [AdventureWorks]
GO
/****** Object:  UserDefinedFunction [dbo].[IntValues]    Script Date: 12/12/2021 1:57:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[IntValues](@FirstVal INT , @SecondVal INT)

RETURNS @RES TABLE (ArrOfNums INT)
As
	BEGIN 
	IF (@FirstVal > @SecondVal )
	begin 
		Print @SecondVal;
		set @SecondVal=@SecondVal+1;
		
	end

	else if  (@SecondVal > @FirstVal)
	begin
		Print @FirstVal;
		set @FirstVal=@FirstVal+1;
		
	end
		RETURN
	END
	 