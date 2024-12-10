-- What date range was this database created for?
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_db2;

-- Which company made the most layoffs?
SELECT company, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY company
ORDER BY 2 DESC;

-- Which industries were most affected by employee layoffs?
-- But which suffered the least?
SELECT industry, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY industry
ORDER BY 2 DESC;

-- Which conutry made the most layoffs?
SELECT country, SUM(total_laid_off)
FROM layoffs_db2
GROUP BY country
ORDER BY 2 DESC;

-- Which company made layoffs in Romania?
SELECT *
FROM layoffs_db2
WHERE country = 'Romania';

-- How have the layoffs been over the years?
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