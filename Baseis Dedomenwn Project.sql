select *
from flights
where depDate='2018-05-01' and toCity='Toronto'

select *
from flights
where distance Between 900 and 1500 
order by distance

select toCity, count(*) 
from flights 
where depDate>='2018-05-01' and depDate<='2018-05-30'
group by toCity

select toCity, count(*)
from flights
group by toCity
having count(*) >= 3

select lastname,firstname
from employees
where empid in (select certified.empid from certified group by certified.empid having count(certified.empid) >= 3)

select sum(salary)
from employees

select sum(salary)
from employees
where empid in (select distinct empid from certified)

select sum(salary)
from employees
where empid not in (select distinct empid from certified)

select name
from aircrafts
where crange >= (select distance from flights where fromCity='Athens' and toCity = 'Melbourne')

select lastname, firstname
from employees
where empid in (select distinct certified.empid from certified where aid in (select aid from aircrafts where name like 'Boeing%'))

select lastname, firstname
from employees
where empid in (select distinct certified.empid from certified where aid in (select aid from aircrafts where crange >= 3000))
Except
select lastname, firstname
from employees
where empid in (select distinct certified.empid from certified where aid in (select aid from aircrafts where name like 'Boeing%'))

select lastname,firstname, salary
from employees
where salary = (select max(salary) from employees)

select lastname,firstname,salary
from employees
where salary in (select max(salary) from employees where salary <> (select max(salary) from employees))

select name
from aircrafts
where aid not in (select distinct aid from certified where empid  in (select empid from employees where salary < 6000))

select empid, max(crange)
from certified, aircrafts
where certified.aid = aircrafts.aid 
group by empid
having count(empid) >= 3

select lastname, firstname, salary
from employees
where salary < (select min(price) from flights where toCity ='Melbourne')

select lastname, firstname, salary
from employees
where empid not in (select distinct empid from certified) and salary > (select avg(salary) from employees where empid in (select distinct empid from certified))

create view pilots as
select * 
from employees
where empid in (select distinct empid from certified)

select sum(salary)
from pilots

create view others as
select * 
from employees
where empid not in (select distinct empid from certified)

select sum(salary)
from others

create view flight_history as
select fno, fromCity, toCity,name,crange,distance
from flights,aircrafts
where crange >= distance

select * from flight_history

create procedure flight_cost as
Begin
Declare @price int
Declare @fno varchar(4)

select @fno = min(fno) from flights

while(@fno is not null)
	begin
	select @price = price from flights where @fno = fno 
	IF(@price is not null)
		Begin
		Select case
			WHEN @price <= 500 then @fno + ': ' + CAST(@price AS VARCHAR(4)) + ' - Cheap'
			WHEN @price >500 and @price <=1500 then @fno + ': ' + CAST(@price AS VARCHAR(4)) + ' - Normal'
			WHEN @price > 1500 then @fno + ': ' + CAST(@price AS VARCHAR(4)) + ' - Expensive'
			END
		END
	select @fno = min(fno) from flights where @fno < fno
	end
end

execute flight_cost

create procedure pilot_certification @lastname varchar(30), @firstname varchar(30), @empid int, @aid int, @name varchar(30) as
begin
Declare @pilot int
Declare @aircraft int
Declare @certification bit

select @pilot = empid from employees where @empid = empid
select @aircraft = aid from aircrafts where @aid = aid

IF(not exists(select * from certified where @empid = empid and @aid = aid))
	Begin
	IF(@pilot is null)
		Begin
		insert into employees values (@empid,@lastname,@firstname,0)
		end
	IF(@aircraft is null)
		begin
		insert into aircrafts values(@aid,@name,0);
		end
	insert into certified values(@empid,@aid)
	End
ELSE
	Begin
	print 'The pilot is already certified on the requested aircraft!'
	end
end

execute pilot_certification @lastname ='Αλεξάνδρου', @firstname='Αννα', @empid=16, @aid=9, @name='Super Jumbo'

create trigger increase_salary on certified after insert as
Begin
Declare @empid int

select @empid = empid from Inserted
IF((select count(empid) from certified where @empid = empid) = 3)
	Begin
	Update employees set salary = salary * 1.10 where @empid = empid
	end
end

create table flight_price_history (
fno varchar(4),
username nvarchar(128) not null,
timeofchange datetime not null,
priceold int not null,
pricenew int not null,
primary key(fno),
constraint ForeignKey3 Foreign Key (fno) references flights(fno)
);

create trigger flight_price_change on flights after Update as
if Update(price)
Begin
Declare @fno varchar(4)
Declare @priceold int
Declare @pricenew int

select @fno = fno from Inserted
select @priceold = price from Deleted
select @pricenew = price from Inserted

insert into flight_price_history values (@fno,user_name(), getdate(),@priceold,@pricenew)
end
