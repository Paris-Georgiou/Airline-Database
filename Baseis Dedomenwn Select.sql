select *
from flights
where depDate='2018-05-01' and toCity='Toronto'

select *
from flights
where distance >= 900 and distance <=1500
order by distance

select toCity,count(*)
from flights
where depDate>='2018-05-01' and depDate<='2018-05-30'
group by toCity

select toCity,count(*)
from flights
group by toCity
having count(*)>=3

select lastname,firstname
from employees,certified
where employees.empid=certified.empid
group by lastname, firstname
having count(certified.empid)>=3

select sum(salary)
from employees

select sum(salary)
from employees
where exists(
select *
from certified
where employees.empid = certified.empid
)

select sum(salary)
from employees
where not exists(
select *
from certified
where employees.empid = certified.empid
)

select sum(salary)
from employees
where empid not in (select empid from certified)

select name
from aircrafts
where crange >= (select distance from flights where fromCity='Athens' and toCity='Melbourne')

select distinct lastname, firstname
from employees, aircrafts, certified
where employees.empid = certified.empid and certified.aid = aircrafts.aid and aircrafts.name like 'Boeing%'

select lastname, firstname
from employees,certified,aircrafts
where employees.empid = certified.empid and certified.aid = aircrafts.aid and aircrafts.crange > 3000 
Except
select lastname, firstname
from employees,certified,aircrafts
where employees.empid = certified.empid and certified.aid = aircrafts.aid and aircrafts.name like 'Boeing%'
 
select lastname,firstname, salary
from employees
where salary = (select max(salary) from employees)

select lastname, firstname, salary
from employees
where salary = ( select max(salary) from employees where salary not in (select max(salary) from employees))

select distinct aircrafts.name
from aircrafts,employees,certified
where employees.empid= certified.empid and certified.aid=aircrafts.aid and employees.salary>=6000
EXCEPT
select distinct aircrafts.name
from aircrafts,employees,certified
where employees.empid= certified.empid and certified.aid=aircrafts.aid and employees.salary<6000

select distinct certified.empid, max(aircrafts.crange)
from certified,aircrafts
where certified.aid=aircrafts.aid
group by certified.empid
having count(certified.empid) >=3

select distinct lastname, firstname
from employees
where employees.salary < (select min(price) from flights where toCity='Melbourne')

select distinct lastname, firstname, salary
from employees
where employees.empid not in (select distinct certified.empid from certified) and
salary > (select avg(salary) from employees where employees.empid = (select distinct empid from certified where employees.empid = certified.empid)) 