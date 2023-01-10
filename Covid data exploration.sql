select *
from dbo.coviddeaths
where continent is not null
order by 3,4

--select *
--from dbo.covidvaccinations
--order by 3,4

select Location,date,total_cases,new_cases,total_deaths,population
from dbo.coviddeaths
order by 1,2

--Total cases/total deaths to calculate chance of dying if infected

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from dbo.coviddeaths
where location like '%united kingdom%'
order by 1,2

--total cases/population
select location,date,population,total_cases,total_deaths,(total_cases/population)*100 as casespercentage
from dbo.coviddeaths
where location like '%united kingdom%'
order by 1,2

create view rateofcases as
 select location,population,MAX(total_cases) as highestinfectionrate,MAX((total_cases/population))*100 as INFECTIONpercentage
from dbo.coviddeaths
--where location like '%united kingdom%'
GROUP BY POPULATION,LOCATION
--order by INFECTIONpercentage DESC

--infection rate
 select location,population,MAX(total_cases) as highestinfectionrate,MAX((total_cases/population))*100 as INFECTIONpercentage
from dbo.coviddeaths
--where location like '%united kingdom%'
GROUP BY POPULATION,LOCATION
order by INFECTIONpercentage DESC

--Create view for infection rate visualization

create view infectionrate as
 select location,population,MAX(total_cases) as highestinfectionrate,MAX((total_cases/population))*100 as INFECTIONpercentage
from dbo.coviddeaths
--where location like '%united kingdom%'
GROUP BY POPULATION,LOCATION
--order by INFECTIONpercentage DESC

--highest death rate in countries
 select location,Max(cast(total_deaths as int)) as totaldeathcount
from dbo.coviddeaths
--where location like '%united kingdom%'
where continent is not null
GROUP BY POPULATION,LOCATION
order by totaldeathcount DESC

 select location,Max(cast(total_deaths as int)) as totaldeathcount
from dbo.coviddeaths
--where location like '%united kingdom%'
where continent is not null
GROUP BY POPULATION,LOCATION
order by totaldeathcount DESC

 select continent,Max(cast(total_deaths as int)) as totaldeathcount
from dbo.coviddeaths
--where location like '%united kingdom%'
where continent is not null
GROUP BY continent
order by totaldeathcount DESC

--total in world
 select   sum(new_cases)as total_Cases,sum(cast(new_deaths as int))as total,sum(cast(new_deaths as int))/
 sum(New_Cases)* 100 as deathpercentage
from dbo.coviddeaths
--where location like '%united kingdom%'
where continent is not null
--group by date
order by 1,2
--total population vs vaccinations


--partition

select dea.continent,dea.location,dea.population, vac.new_vaccinations,dea.date
,sum(cast(vac.new_vaccinations as bigint ))over ( partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from dbo.coviddeaths dea
join dbo.covidvaccinations  vac
on dea.location= vac.location
and dea.date = vac.date
where  dea.continent is not null
order by 2,3

with POvsVac (Continent, location, date, population, rollingpeoplevaccinated, New_vaccinations)
as
(
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations))over ( partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from dbo.coviddeaths dea
join dbo.covidvaccinations  vac
on dea.location= vac.location
and dea.date = vac.date
where  dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated /population)*100
from povsvac


Temp table 

--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--insert into #PercentPopulationVaccinated
--select dea.continent,dea.location,dea.population, vac.new_vaccinations,dea.date
--,sum(cast(vac.new_vaccinations as bigint ))over ( partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--from dbo.coviddeaths dea
--join dbo.covidvaccinations  vac
--on dea.location= vac.location
--and dea.date = vac.date
--where  dea.continent is not null
--order by 2,3

--select*,(rollingpeoplevaccinated /population)*100
--from #PercentPopulationVaccinated




