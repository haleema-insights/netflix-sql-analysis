-- Netflix Movies and TV Shows Analysis
-- Dataset: Kaggle - Netflix Movies and TV Shows
-- Author: Haleema
-- Tool: MySQL Workbench 8.0


CREATE DATABASE netflix_project;
USE netflix_project;
CREATE TABLE netflix (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(200),
    director VARCHAR(250),
    cast VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(20),
    listed_in VARCHAR(100),
    description VARCHAR(500)
);

select count(*) from netflix;

-- Query 1. movies vs tv show count
SELECT type, COUNT(*) as total
FROM netflix
GROUP BY type;

-- Qery 2.  Top 5 countries with most content:
-- Note: Some rows contain multiple countries in one cell
-- Example: "United States, India, United Kingdom" is treated as one country
-- Advanced string splitting using SUBSTRING_INDEX needed for accurate results
-- This is a known data quality limitation of this dataset
SELECT country, COUNT(*) as total
FROM netflix
WHERE country IS NOT NULL AND country != ''
GROUP BY country
ORDER BY total DESC
LIMIT 5;

-- Query 3. "Which age group has the most content on Netflix?"
select rating, count(type) as total_content
from netflix
where rating is not null and rating != ''
group by rating
order by total_content desc;

 -- Query 4. Find the top 5 directors who have made the most content on Netflix!
select director, count(type) as total_content
from netflix
where director is not null and director != ''
group by director
order by total_content desc
limit 5; 

-- Query 5. How many Movies and TV Shows were added to Netflix each year?
select release_year, count(type) as total
from netflix
where release_year is not null and release_year != ''
group by release_year
order by release_year desc;

-- Query 6. What are the top 5 most common genres on Netflix?
select listed_in, count(*) as leads
from netflix
where listed_in is not null and listed_in != ''
group by listed_in
order by leads desc
limit 5;
-- no space b/w single quote ''
-- cast converts text "90" to number 90
-- SUBSTRING_INDEX(duration, ' ', 1)
-- This function cuts the text at a specific character!

-- Query 7 — Find all Movies that are longer than 90 minutes!
select  duration, title
from netflix
where type = 'Movie' and cast(substring_index(duration,' ',1) as unsigned) > 90
order by cast(substring_index(duration,' ',1) as unsigned) desc;

-- the space b/w single quote' '
-- LIKE is for pattern matching 
-- WHERE duration LIKE '%min%'
-- CAST is for number comparison 

-- Query 8 — Find the top 10 movies with the longest duration!
select title
from netflix
where type = 'Movie' and cast(substring_index(duration, ' ',1) as unsigned)
order by cast(substring_index(duration, ' ',1) as unsigned) desc
limit 10;

-- Query 9 — Find the top 5 countries that have the most Movies only!
select country, count(type) as top_5
from netflix
where country != '' and type = 'Movie' and country is not null
group by country
order by top_5 desc
limit 5;

-- Query 10 — Find the top 5 TV Shows with the most seasons!
select type, title,duration
from netflix
where type = 'TV Show' -- Not needed x( and type is not null and type != '' )x
and cast(substring_index(duration, ' ', 1) as unsigned)>0
order by cast(substring_index(duration, ' ', 1) as unsigned)  desc
limit 5;
-- Whenever you write WHERE column = 'specific value' — nulls 
-- and blanks are automatically 
-- eliminated because they can never equal that specific value!

