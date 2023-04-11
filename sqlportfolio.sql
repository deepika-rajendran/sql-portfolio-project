select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Total case vs population 

select location,date,population,total_cases,(total_cases/population)*100
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Highest Total case per population 

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by percentPopulationInfected desc

--Highest Death count in each country

select location,max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

--Highest Death count in each continent

select continent,max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

select sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,  
dea.date)as CummulativeOfVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

with cumvsvac(continent, location, date, population, new_vaccinations,CummulativeOfVaccinatedPeople)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,  
dea.date)as CummulativeOfVaccinatedPeople 
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select*,(CummulativeOfVaccinatedPeople/population)*100 as percentageCumvsVac
from cumvsvac

--Temp Table
 drop table if exists #percentageOfVaccinatedPeople
create table #percentageOfVaccinatedPeople
(continent nvarchar(255), 
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
CummulativeOfVaccinatedPeople numeric)

insert into #percentageOfVaccinatedPeople
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,  
dea.date)as CummulativeOfVaccinatedPeople 
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select*,(CummulativeOfVaccinatedPeople/population)*100 as percentageCumvsVac
from #percentageOfVaccinatedPeople

create view PercentpopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,  
dea.date)as CummulativeOfVaccinatedPeople 
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select*from PercentpopulationVaccinated






