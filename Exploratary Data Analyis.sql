-- Exploratary Data Analyis 

select *
from  layoffs_staging2;

-- maximimum   Laid off
select min(total_laid_off), max(total_laid_off)
from  layoffs_staging2;

-- percentage Laid off 
select *
from  layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Sum of Laid off with respect to company 
select company, sum(total_laid_off)
from  layoffs_staging2
group by company
order by 2 desc;


-- Dates of Laid off

select min(date), max(date)
from  layoffs_staging2;

-- Sum of Laid off with respect to industry 
select industry, sum(total_laid_off)
from  layoffs_staging2
group by industry
order by 2 desc;

-- Sum of Laid off with respect to country 
select country, sum(total_laid_off)
from  layoffs_staging2
group by country
order by 2 desc;

-- Sum of Laid off with respect to Year 
select Year(date), sum(total_laid_off)
from  layoffs_staging2
group by Year(date)
order by 1 desc;


-- Sum of Laid off with respect to stage 
select stage, sum(total_laid_off)
from  layoffs_staging2
group by stage
order by 2 desc;

-- Sum of the Percentage of Laid off with respect to company 
select company, sum(percentage_laid_off)
from  layoffs_staging2
group by company
order by 2 desc;

-- Total Laid off with respect to Month
select substring(date,1,7) as Month,  sum(total_laid_off)
from  layoffs_staging2
where substring(date,1,7) is not null
group by Month
order by 1 asc;



-- Sum of rolling total---

with Rolling_Total AS
(
select substring(date,1,7) as Month,  sum(total_laid_off) as laid_off_total
from  layoffs_staging2
where substring(date,1,7) is not null
group by Month
order by 1 asc
)
select Month, laid_off_total,
 sum(laid_off_total) over(order by 'month') as rolling_total
from Rolling_Total;

-- Sum of Laid off with respect to company and Year 
select company, Year(date), sum(total_laid_off)
from  layoffs_staging2
group by company, Year(date)
order by 3 desc;
-- Ranking of Laid off with respect to company and Year  USING CTE
with company_year (compnay, years, total_laid_off) as 
( 
select company, Year(date), sum(total_laid_off)
from  layoffs_staging2
group by company, Year(date)
), 
company_year_rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * 
from company_year_rank
where ranking <=5;
