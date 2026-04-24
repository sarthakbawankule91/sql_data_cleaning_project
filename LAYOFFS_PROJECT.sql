create database project11;
use project11;

select * from layoffs;

-- FIRST THING WE WANT TO DO IS CREATE A STAGGING TABLE.
-- THIS IS THE ONE WE WILL WORK IN AND CLEAN THE DATA.
-- WE WANT A TABLE WITH THE RAW DATA IN CASE SOMETHING HAPPENS.

CREATE TABLE layoffs_data_staging
like layoffs;

INSERT layoffs_data_staging
SELECT * FROM layoffs;


SELECT * FROM layoffs_data_staging;

-- NOW WHEN WE ARE DATA CLEANING WE USUALLY FOLLOW A FEW STEPS
-- 1. CHECK FOR DUPLICATES AND REMOVE ANY.
-- 2. STANDARDIZE DATA AND FIX ERRORS.
-- 3. LOOK AT NULL VALUES AND SEE WHAT
-- 4. REMOVE ANY COLUMNS AND ROWS THAT ARE NOT NECCESARY

-- 1. REMOVE DULPICATES
SELECT COMPANY, INDUSTRY, TOTAL_LAID_OFF, DATE,
	ROW_NUMBER() OVER(
		PARTITION BY COMPANY, INDUSTRY, TOTAL_LAID_OFF, DATE)
        AS ROW_NUM
	FROM layoffs_data_staging;
    
    
    SELECT *
FROM (
    SELECT company, industry, total_laid_off, `date`,
        ROW_NUMBER() OVER (
            PARTITION BY company, industry, total_laid_off, `date`
        ) AS row_num
    FROM 
		layoffs_data_staging
) duplicates
WHERE
    row_num > 1;
    
    
-- let's just look at oda to confim
SELECT * FROM layoffs_data_staging
where company = 'oda'

    
SELECT *
FROM (
    SELECT company, location, industry, total_laid_off,
           percentage_laid_off, `date`, stage, country, funds_raised_millions,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
               total_laid_off, percentage_laid_off, `date`, stage,
               country, funds_raised_millions
           ) AS row_num
    FROM layoffs_data_staging
) duplicates
WHERE row_num > 1;
    
select version()
    
    
    
    WITH DELETE_CTE AS (
    SELECT *
    FROM (
        SELECT company, location, industry, total_laid_off,
               percentage_laid_off, `date`, stage, country, funds_raised_millions,
               ROW_NUMBER() OVER (
                   PARTITION BY company, location, industry,
                   total_laid_off, percentage_laid_off, `date`,
                   stage, country, funds_raised_millions
               ) AS row_num
        FROM 
            layoffs_data_staging
    ) duplicates
    WHERE 
         row_num > 1
)
DELETE
FROM DELETE_CTE
;

-- one solution, which I think is a good one, is to create a new column
-- and add those row numbers in. Then delete where row numbers are over 1,
-- then delete that column
-- so let's do it!!
    
ALTER TABLE layoffs_data_staging ADD ROW_NUM INT;
    
    
    
CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);
 
INSERT INTO `layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,
            percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_data_staging;

    select * from layoffs_staging2
    -- now that we have this we can delete rows where row_num is greater than 2

DELETE FROM layoffs_staging2
WHERE row_num >= 2;

SET SQL_SAFE_UPDATES = 0;
    
-- 2. standardize data
    
    -- if we look at industry it looks like we have some null
-- and empty rows, let's take a look at these

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;
    

-- day 1 -- project--29-07
-- let's take a look at these

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- nothing wrong here
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb%';

-- it looks like airbnb is a travel, but this one just isn't populated.
-- I'm sure it's the same for the others. What we can do is
-- write a query that if there is another row with the same company name,
--- it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

-- we should set the blanks to nulls since those
-- are typically easier to work with

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- now if we check those are all null

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;


-- now we need to populate those nulls if possible

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- and if we check it looks like Bally's was
-- the only one without a populated row to populate this null values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;



-- I also noticed the Crypto has multiple different variations.
-- We need to standardize that - let's say all to Crypto


SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- now that's taken care of:
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

select * from layoffs_staging2
-- we also need to look at 

-- everything looks good except apparently
-- we have some "united states" and some "united states."
-- with a period at the end. let's standardize this.

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country); 
-- This query will successfully remove any trailing periods from the country column.

-- now if we run this again it is fixed
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

-- Let's also fix the date columns:
SELECT * FROM layoffs_staging2;

-- we can use str_to_date to update this field
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- now we can convert the date type properly
UPDATE layoffs_staging2
SET `date` =
CASE
    -- Handle M/D/YYYY or MM/DD/YYYY
    WHEN `date` REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
    THEN STR_TO_DATE(`date`, '%m/%d/%Y')
  
	-- handle YYYY-MM-DD
    WHEN `date` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
       THEN `date`

	-- NULL or invalid stays NULL
	ELSE NULL
END;

SET SQL_SAFE_UPDATES = 0;






















