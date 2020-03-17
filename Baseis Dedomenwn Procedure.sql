create procedure get_employee_info @empid int, @info varchar(100) OUT AS

Begin
Select @info = firstname + ' ' + lastname + ', ' + CAST(salary AS VARCHAR(10)) from employees where empid = @empid
END 

Declare @employeeinfo varchar(100)
execute get_employee_info @empid=11, @info = @employeeinfo OUT
Select @employeeinfo

drop procedure get_employee_info 

create procedure flight_ratings AS

Declare @flight varchar(4)
Declare @cost int

Select @flight = min(fno) from flights

While @flight is NOT NULL
Begin
	Select @cost = price from flights where fno = @flight
	IF(@cost is NOT NULL)
	Begin
		SELECT CASE
		WHEN @cost <=500 THEN @flight + ': ' + CAST(@cost AS VARCHAR(12)) + ' - Φθηνή'
		WHEN @cost <=1500 THEN @flight + ': ' + CAST(@cost AS VARCHAR(12)) + ' - Κανονική'
		ELSE @flight+': '+CAST(@cost AS VARCHAR(12)) + ' - Ακριβή'
		END
	END
Select @flight = min(fno) from flights where @flight < fno
END

execute flight_ratings;

drop procedure flight_ratings;
Create Procedure pilot @empid int, @lastname varchar(30), @firstname varchar(30),  @name varchar(50), @aid int ASDeclare @pilot intDeclare @aircraft intDeclare @certification bitBeginSelect @pilot = empid from employees where empid = @empidSelect @aircraft = aid from aircrafts where aid = @aidIF(NOT Exists(select * from certified where empid=@empid and aid = @aid))	Begin 	IF(@pilot is null) insert into employees values (@empid,@lastname,@firstname,0)	IF(@aircraft is null) insert into aircrafts values (@aid,@name,0);	insert into certified values (@empid,@aid)	ENDElse	Begin	Print 'Ο συγκεκριμένος πιλότος είναι ήδη πιστοποιημένος στην λειτουργία του συγκεκριμένου αεροσκάφους.'	ENDENDexecute pilot @empid = 11, @lastname='Αθανασιάδης', @firstname= '’γγελος',  @name='Boeing 747', @aid = 4drop procedure pilot;