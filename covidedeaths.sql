select * from covidDeaths$ 

alter table covidDeaths$  alter column date date

-- Total deaths in Europe countries day by day
select location,continent,date, total_deaths 
from covidDeaths$ 
where continent= 'Europe'
order by 1 

--locations that have null continent values
        select location, sum(cast(total_deaths as float)) 
         from covidDeaths$
		 where continent is null
		 group by location
		 order by location


-- countries that have highest death

       select top 5 location, max(cast (total_deaths as float))  as tot_deaths
	   from covidDeaths$
	  where continent is not null
	  group by location
	   order by tot_deaths desc

--continents with higest death count

	 select top 5 continent, sum(cast (total_deaths as float))  as tot_deaths
	   from covidDeaths$
	  where continent is not null
	  group by continent
	   order by tot_deaths desc  


-- Total cases to Population
select location, sum(total_cases)/population as tot_deaths_to_pop_
from covidDeaths$
group by location,population
order by tot_deaths_to_pop_ desc


-- Total deaths to Population

alter table covidDeaths$ alter column total_deaths float

select location, round(sum(total_deaths)/population,2) as tot_death_vs_pop_
from covidDeaths$
group by location,population
order by tot_death_vs_pop_ desc


-- top 5 countries that have most death count

select top 5 location,sum(cast(total_deaths as float)) as tot_death
from covidDeaths$
where continent is not null
group by location
order by tot_death desc


--- countries which above the average death

 delete from covidDeaths$ 
 where location 
 in ( 'world','europe','north america','south america','european union','asia')
declare @number_of_countries float, 
@total_deaths float
set @number_of_countries= 
(select count(distinct location) from covidDeaths$)
set @total_deaths= 
(select sum(cast(total_deaths as float)) from covidDeaths$)
select location,sum(cast(total_deaths as float)) as _tot_ ,
(@total_deaths/@number_of_countries) as avgtotaldeath 
from covidDeaths$
group by location
order by _tot_ desc


alter table covidDeaths$ alter column total_deaths int
declare @avgdeath int
set @avgdeath= 3497072
select location,sum(total_deaths) as TotDeath,@avgdeath as avgdeath,
case 
when sum(total_deaths)>=@avgdeath then 'Above the Average'
else 'Below the Average'
end as avgdeathpercountry
from covidDeaths$
group by location
having sum(total_deaths) is not null
order by TotDeath desc


-- Death% in Europe

select continent, 
(sum(total_deaths)/sum(total_cases)*100) as 'death%'
from covidDeaths$
where continent='Europe'
group by continent


--Death% for all continents

select continent,
(sum(total_deaths)/sum(total_cases)*100) as 'death%'
from covidDeaths$
where continent is not null
group by continent
order by 'death%' desc


-- Death% for countries
select iso_code,location,
(sum(total_deaths)/sum(total_cases)*100) as 'death%'
from covidDeaths$
where location is not null and
iso_code is not null and 
'death%' is not null
group by iso_code,location
order by 'Death%' desc


-- infectionrate of continents
declare @populationofcontinents int
set @populationofcontinents= (select continent,sum(population) over (partition by continent)
from covidDeaths$)

select continent, sum(total_cases)
from covidDeaths$
where continent is not null
group by continent