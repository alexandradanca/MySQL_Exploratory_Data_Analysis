-- What date range was this database created for?  2020-03-11, 2023-03-06
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_db2;

-- Which company made the most layoffs? Amazon layoffs 18150 employee, next is Google with 12000 layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY company
ORDER BY 2 DESC;

-- Which industries were most affected by employee layoffs? Consumer, Retail, Other, Transportation
-- But which suffered the least? Manufacturing, Fin-Tech, Aerospace
SELECT industry, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY industry
ORDER BY 2 DESC;

-- Which conutry made the most layoffs? United Sates followed by India and Netherlands
SELECT country, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY country
ORDER BY 2 DESC;

-- Which company made layoffs in Romania? Foodpanda
SELECT *
FROM layoffs_db2
WHERE country = 'Romania';

-- How have the layoffs been over the years? More(2022 with 160661, 2023 with 125677, 2020 with 80998 and 2021 with 15823)Less
SELECT YEAR(`date`) AS year, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY year
HAVING year != ''
ORDER BY 1 ASC;

-- Calculate the ranking of top 5 companies based on the total number of layoffs in each years
WITH Company_Year AS (
SELECT company, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_db2
GROUP BY company, `year`
),
Company_Year_Rank AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE `year` IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;

