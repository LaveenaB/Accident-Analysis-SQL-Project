create database accident_analysis;

use accident_analysis;

select * from accident;
select * from vehicle;

-- Question 1  
-- How many accidents have occurred in Urban areas versus rural areas.

select Area, count(AccidentIndex) as no_of_accidents from accident
group by Area;

select 
(select count(*) from accident where Area = 'Urban') as Urban_accidents,
(select count(*) from accident where Area = 'Rural') as Rural_accidents;

-- Question 2
-- Which day of the week has the highest no. of accidents?


select top 1 Day, count(AccidentIndex) as day_accidents from accident
group by Day
order by day_accidents desc;

select top 1 datename(WEEKDAY, Date) as week_day, count(*) as cou
from accident
group by DATENAME(weekday, Date)
order by cou desc;

-- Question 3 
-- what is the average age of vehicles involved in accidents based on their type?

select VehicleType, avg(isnull(AgeVehicle,0)) as avg_age_vehicle from vehicle
group by VehicleType
order by avg_age_vehicle;

--Question 4 
-- find any trends in accidents based on the age of vehicles involved.

select isnull(AgeVehicle, 0) as Age_Vehicle, count(AccidentIndex) as Accidents
from vehicle
group by AgeVehicle
order by Accidents desc;

--Question 5
-- Are there any specific weather conditions that contribute to severe accidents? like fatal or serious

select Severity, WeatherConditions, count(*) as no_of_accidents
from accident
Group by WeatherConditions, Severity
Having Severity IN ('Fatal', 'Serious')
order by no_of_accidents desc;

select WeatherConditions, count(*) as num_accidents
from accident
where Severity in ('Fatal','Serious')
Group by WeatherConditions
order by num_accidents desc;


--Question 6 
-- Do accidents often involve impacts on the left-hand side of vehicles?

select * from accident;
select * from vehicle;

select LeftHand, count(*) as num_accidents 
from vehicle
Group by LeftHand;

-- Question 7 
-- Are there any relationships bw journey purposes and the severity of the accidents?

select a.Severity, v.JourneyPurpose, count(*) as num_accidents from accident a
JOIN 
vehicle v
on a.AccidentIndex = v.AccidentIndex
where a.Severity in ('Fatal', 'Serious')
group by a.Severity, v.JourneyPurpose
order by num_accidents desc;


--Question 8
--Create a stored procedure to calculate the average age of vehicles involved in accidents, 
-- considering light conditions and point of impact as two variable/inputs

Create procedure avg_age_vehicle(@LightConditions varchar(100),
@PoinImpact varchar(100))
as 
begin
select avg(v.AgeVehicle) as avg_age_vehicle from vehicle v
join 
accident a 
on a.AccidentIndex = v.AccidentIndex
where a.LightConditions = @LightConditions
and 
v.PointImpact = @PoinImpact
end

exec avg_age_vehicle 'Daylight','Front'





