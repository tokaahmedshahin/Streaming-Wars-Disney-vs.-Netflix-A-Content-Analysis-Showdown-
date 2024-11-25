
                                    ---NOrmalization---

                                         ---Netfilx---



ALTER TABLE netflix_titles
ADD CONSTRAINT show_id PRIMARY KEY (show_id);



CREATE TABLE netflix_cast (
    show_id NVARCHAR(100),
    cast_member NVARCHAR(150),
    PRIMARY KEY (show_id, cast_member),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES netflix_titles (show_id)
);
drop table disney_cast

INSERT INTO netflix_cast (show_id, cast_member)
SELECT DISTINCT show_id, TRIM(value)
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM netflix_cast
    WHERE netflix_cast.show_id = netflix_titles.show_id
    AND netflix_cast.cast_member = TRIM(value)
);
select *
from netflix_cast







CREATE TABLE netflix_director (
    show_id NVARCHAR(100),
    director NVARCHAR(150),
    PRIMARY KEY (show_id, director),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);

INSERT INTO netflix_director (show_id, director)
SELECT DISTINCT show_id, TRIM(value)
FROM netflix_titles
CROSS APPLY STRING_SPLIT(director, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM netflix_director
    WHERE netflix_director.show_id = netflix_titles.show_id
    AND netflix_director.director = TRIM(value)
);

select *
from netflix_director


CREATE TABLE netflix_country(
    show_id NVARCHAR(100),
    country NVARCHAR(150),
    PRIMARY KEY (show_id, country),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);




INSERT INTO netflix_country(show_id, country)
SELECT DISTINCT show_id, TRIM(value)
FROM netflix_titles
CROSS APPLY STRING_SPLIT(country, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM netflix_country
    WHERE netflix_country.show_id = netflix_titles.show_id
    AND netflix_country.country = TRIM(value)
);

CREATE TABLE netflix_listed_in(
    show_id NVARCHAR(100),
    listed_in NVARCHAR(150),
    PRIMARY KEY (show_id, listed_in),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);


INSERT INTO netflix_listed_in(show_id, listed_in)
SELECT DISTINCT show_id, TRIM(value)
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM netflix_listed_in
    WHERE netflix_listed_in.show_id = netflix_titles.show_id
    AND netflix_listed_in.listed_in = TRIM(value)
);
select *
from netflix_listed_in

ALTER TABLE netflix_titles
DROP COLUMN country,cast,director,listed_in;



                                        ---Disney--


CREATE TABLE disney_cast (
    show_id NVARCHAR(150),
    cast_member NVARCHAR(150),
    PRIMARY KEY (show_id, cast_member),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES disney_plus_titles (show_id)
);
drop table disney_cast

INSERT INTO disney_cast (show_id, cast_member)
SELECT DISTINCT show_id, TRIM(value)
FROM disney_plus_titles
CROSS APPLY STRING_SPLIT(cast, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM disney_cast
    WHERE disney_cast.show_id = disney_plus_titles.show_id
    AND disney_cast.cast_member = TRIM(value)
);
select *
from disney_cast


disney_plus_titles




CREATE TABLE disney_director (
    show_id NVARCHAR(150),
    director NVARCHAR(150),
    PRIMARY KEY (show_id, director),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES disney_plus_titles(show_id)
);

INSERT INTO disney_director (show_id, director)
SELECT DISTINCT show_id, TRIM(value)
FROM disney_plus_titles
CROSS APPLY STRING_SPLIT(director, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM disney_director
    WHERE disney_director.show_id = disney_plus_titles.show_id
    AND disney_director.director = TRIM(value)
);

select *
from disney_director


CREATE TABLE disney_country(
    show_id NVARCHAR(150),
    country NVARCHAR(150),
    PRIMARY KEY (show_id, country),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES disney_plus_titles(show_id)
);




INSERT INTO disney_country(show_id, country)
SELECT DISTINCT show_id, TRIM(value)
FROM disney_plus_titles
CROSS APPLY STRING_SPLIT(country, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM disney_country
    WHERE disney_country.show_id = disney_plus_titles.show_id
    AND disney_country.country = TRIM(value)
);

CREATE TABLE diseny_listed_in(
    show_id NVARCHAR(150),
    listed_in NVARCHAR(150),
    PRIMARY KEY (show_id, listed_in),  -- Composite key
    FOREIGN KEY (show_id) REFERENCES disney_plus_titles(show_id)
);


INSERT INTO diseny_listed_in(show_id, listed_in)
SELECT DISTINCT show_id, TRIM(value)
FROM disney_plus_titles
CROSS APPLY STRING_SPLIT(listed_in, ',') AS value
WHERE NOT EXISTS (
    SELECT 1
    FROM diseny_listed_in
    WHERE diseny_listed_in.show_id = disney_plus_titles.show_id
    AND diseny_listed_in.listed_in = TRIM(value)
);
select *
from diseny_listed_in

ALTER TABLE disney_plus_titles
DROP COLUMN country,cast,director,listed_in;












                                             ----Business QS---



--1-What are the top 5 countries by content release?

----NETFLIX
select top 5 country , country_shows_numbers
from 
(select distinct country , count(country) over (partition by country) as country_shows_numbers
from netflix_country
) tab
order by country_shows_numbers desc

----DISNEY
select top 5 country , country_shows_numbers
from 
(select distinct country , count(country) over (partition by country) as country_shows_numbers
from disney_country
) tab
order by country_shows_numbers desc

--description
----This query return the top 5 countries with the highest number of shows available on Netflix & Disney , 
--So we can target these countries more aggressively, knowing they have a higher demand for shows.

----------------------------------------------------------------------------------------------------------------------------------

--2-How many shows/movies were added each year?

----NETFLIX
select distinct year(date_added) as year,type, count (type) over(partition by year(date_added)) as movie_numbers
from netflix_titles
where date_added is not null and type = 'Movie'
union
select distinct year(date_added) as year,type, count (type) over(partition by year(date_added)) as movie_numbers
from netflix_titles
where date_added is not null and type = 'TV Show'
order by year

----DISNEY
select distinct year(date_added) as year,type, count (type) over(partition by year(date_added)) as movie_numbers
from disney_plus_titles
where date_added is not null and type = 'Movie'
union
select distinct year(date_added) as year,type, count (type) over(partition by year(date_added)) as movie_numbers
from disney_plus_titles
where date_added is not null and type = 'TV Show'
order by year

--description
----The query returns the type of content (either ‘Movie’ or ‘TV Show’), and the number of each type added to Netflix & Disney each year
--Content Strategy: Analyze the trends in content addition over the years to understand what types of content (movies or TV shows) are being added more frequently. 
--This can help you decide whether to focus more on acquiring or producing movies or TV shows.
--Competitive Analysis: Compare your content strategy with Disney’s. If Disney is adding more TV shows, you might want to focus on movies to differentiate your platform, or vice versa.

-------------------------------------------------------------------------------------------------------------------------------------------------

--3-What is the distribution of content ratings (e.g., TV-MA, PG-13, PG)?

----NETFLIX
select distinct rating, count (rating) over (partition by rating) as distribution_of_content_ratings 
from netflix_titles
where rating is not null

----DISNEY
select distinct rating, count (rating) over (partition by rating) as distribution_of_content_ratings 
from disney_plus_titles
where rating is not null

--description
----The query returns a list of unique content ratings along with the count of how many times each rating appears
--Trend Analysis: Understand which ratings are popular and adjust content strategy accordingly to stay ahead of market trends.

----------------------------------------------------------------------------------------------------------------------------------

--4.Which ratings are most common in each listed in ?

----NETFLIX
select listed_in, rating ,rating_numbers, rankk
from
( select listed_in, rating ,rating_numbers, rank() over(partition by listed_in order by rating_numbers desc) as rankk
  from 
  (select distinct listed_in, rating , count (rating) over (partition by listed_in, rating)as rating_numbers
   from netflix_titles nt, netflix_listed_in nl
   where nt.show_id = nl.show_id) tab
   ) tt
where rankk = 1

----DISNEY
select listed_in, rating ,rating_numbers, rankk
from
( select listed_in, rating ,rating_numbers, rank() over(partition by listed_in order by rating_numbers desc) as rankk
  from 
  (select distinct listed_in, rating , count (rating) over (partition by listed_in, rating)as rating_numbers
   from disney_plus_titles nt, disney_listed_in nl
   where nt.show_id = nl.show_id) tab
   ) tt
where rankk = 1

--description
----The query returns the most common rating for each category on Netflix & Disney
--Competitive Analysis: Compare the most common ratings and categories between Netflix and Disney+ to identify gaps and opportunities for differentiation.

------------------------------------------------------------------------------------------------------------------------------------------------



---5-Which listed in are gaining popularity over time?
SELECT l.listed_in AS Category, COUNT(t.show_id) AS Number_of_Shows, t.release_year AS Release_Year
FROM netflix_titles t JOIN netflix_listed_in l 
ON t.show_id = l.show_id
GROUP BY l.listed_in, t.release_year
ORDER BY t.release_year ASC, COUNT(t.show_id) DESC;

/*This analysis aims to identify which content categories are gaining popularity over time on Netflix. 
By examining the number of shows released in each category year by year, 
the business can spot trending genres and themes that resonate with viewers.
Understanding these patterns will help in making data-driven decisions on what type of content to focus on for future productions*/




---6-Which Movies have the highest average duration (in minutes)?
SELECT  l.listed_in AS Listed_In_Category,
AVG(CAST(REPLACE(t.duration, ' min', '') AS INT)) AS Average_Duration_Minutes
FROM netflix_titles t JOIN netflix_listed_in l
ON t.show_id = l.show_id
WHERE t.type = 'Movie'
GROUP BY l.listed_in
ORDER BY Average_Duration_Minutes DESC;


/*This analysis aims to find which categories of movies on Netflix have the longest average durations. 
Understanding the average length of movies in each category can provide insights into content consumption preferences,
helping the platform strategize around user engagement. By identifying categories with the highest average duration*/


select sum(CAST(REPLACE(t.duration, ' min', '') AS INT)) AS sum_Duration_Minutes
from netflix_listed_in l inner join netflix_titles t
on l.show_id=t.show_id
where listed_in='Classic Movies'


--7-What is the monthly trend for Netflix content additions?

select  rank,year,Total_Content_Added
from (select  year,Total_Content_Added,row_number () over(partition by year order by Total_Content_Added desc) as rank
from (
SELECT YEAR(date_added ) AS Year,MONTH(date_added) AS Month,
COUNT(*) AS Total_Content_Added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added ), MONTH(date_added )
)tab
)tab1
where rank = 1


/*This analysis identifies the monthly trend of content additions on Netflix 
by determining which month in each year saw the highest number of new titles added. 
Understanding these peak content addition periods can help the platform 
optimize its marketing and promotional strategies to maximize viewer engagement.*/

---8-What is the  trend for Netflix content in the last 5 years?

select rank ,  year ,Category, Number_of_Shows
from (
select  year ,Category, Number_of_Shows,row_number()over(partition by year order by Number_of_Shows desc ) rank 
from (
SELECT 
    l.listed_in AS Category, 
    COUNT(t.show_id) AS Number_of_Shows, 
    YEAR(t.date_added) AS Year
FROM 
    netflix_titles t 
JOIN 
    netflix_listed_in l ON t.show_id = l.show_id
WHERE 
    t.date_added IS NOT NULL 
    AND t.date_added >= DATEADD(YEAR, -7, GETDATE())  -- Filter for the last 5 years
GROUP BY 
    l.listed_in, YEAR(t.date_added)
)tab
)tab1
where rank=1

/*This analysis aims to determine the trend of the most popular content categories on Netflix over the last five years.
By identifying which genres had the highest number of shows added each year,
the business can spot evolving viewer preferences and shifts in content consumption.
This information is valuable for strategic planning, helping Netflix prioritize investment in trending categories 
to meet audience demand and stay competitive in the market.*/



--9----How do listed in preferences vary by country?

---Netflix
SELECT 
   c. country,
   l. listed_in,
    COUNT(*) AS genre_count
FROM netflix_titles t inner join netflix_listed_in l
on l.show_id=t.show_id
inner join netflix_country c
on c.show_id=t.show_id
where country !=''
GROUP BY   l.listed_in,c.country
ORDER BY  genre_count desc;

---Diseny

SELECT 
   c. country,
   l. listed_in,
    COUNT(*) AS genre_count
FROM disney_plus_titles t inner join diseny_listed_in l
on l.show_id=t.show_id
inner join disney_country c
on c.show_id=t.show_id
--where country !=''
GROUP BY   l.listed_in,c.country
ORDER BY  genre_count desc;

/*A detailed analysis of the listed_in categories by country allows us 
to identify genre preferences for Netflix audiences across different regions. 
By understanding which genres are popular in specific countries*/
-------------------
--10-How has the number of added changed over the years?
---Netflix
select  tab.titles_added - lead(tab.titles_added) over(order by titles_added desc) as diff_by_years 
,tab. year_added, 
    tab.titles_added
from(
SELECT 
    YEAR ( date_added) AS year_added, 
    COUNT(*) AS titles_added
FROM 
    netflix_titles
WHERE 
    date_added IS NOT NULL
GROUP BY 
    YEAR ( date_added)
)tab

--Disney
select  tab.titles_added - lead(tab.titles_added) over(order by titles_added desc) as diff_by_years 
,tab. year_added, 
    tab.titles_added
from(
SELECT 
    YEAR ( date_added) AS year_added, 
    COUNT(*) AS titles_added
FROM 
    disney_plus_titles
WHERE 
    date_added IS NOT NULL
GROUP BY 
    YEAR ( date_added)
)tab

-------
/*Tracking the trend of yearly added reveals Netflix’s content growth strategy over time.
Analyzing these changes helps identify peaks and shifts in the volume of new titles,
providing insights into Netflix's investment focus in particular years. This data is useful for strategic planning,
predicting future growth, and understanding the evolution of the platform's content catalog.*/


-- 11--Which directors have the most titles on Netflix?

--Netflix
SELECT top 5
    director,
    COUNT(*) AS total_titles
FROM 
    netflix_director
WHERE 
    director IS NOT NULL
GROUP BY 
    director
ORDER BY 
    total_titles DESC;

--Disney

SELECT top 5
    director,
    COUNT(*) AS total_titles
FROM 
   disney_director
WHERE 
    director IS NOT NULL
GROUP BY 
    director
ORDER BY 
    total_titles DESC;


/*Understanding which directors have the most titles on Netflix allows the business 
to identify key contributors to its content catalog. This insight is crucial for maintaining 
strong relationships with top directors */
---------------

--12---Which actors appear most frequently in Netflix titles?

--Netflix
SELECT top 5
    cast_member as actor, 
    COUNT(*) AS appearance_count
FROM 
    netflix_cast
GROUP BY 
   cast_member
ORDER BY 
    appearance_count DESC;


--Diseny
SELECT top 5
    cast_member as actor, 
    COUNT(*) AS appearance_count
FROM 
    disney_cast
GROUP BY 
   cast_member
ORDER BY 
    appearance_count DESC;

/*Identifying the most frequently appearing actors in Netflix titles provides
insights into which talents have the strongest presence on the platform. 
This analysis can help Netflix recognize top-performing actors who drive viewership,
guide casting decisions, and prioritize collaborations with these high-impact performers.*/



                                  --- SQL QUERIES ON BOTH DATASETS---

---Q1: Common movies in both datasets
SELECT netflix_titles.title AS common_movie,netflix_titles.show_id
FROM netflix_titles INNER JOIN disney_plus_titles 
ON netflix_titles.title = disney_plus_titles.title
WHERE netflix_titles.type = 'Movie' AND disney_plus_titles.type = 'Movie';

---
SELECT netflix_titles.title AS common_movie,netflix_titles.show_id
FROM netflix_titles INNER JOIN disney_plus_titles 
ON netflix_titles.title = disney_plus_titles.title
WHERE netflix_titles.type = 'TV show' AND disney_plus_titles.type = 'TV show';

/*This analysis aims to identify movies available on both Netflix and Disney Plus.
Understanding the overlap in content can help each platform evaluate its competitive positioning,
assess licensing agreements, and potentially identify opportunities 
for exclusive content offerings to differentiate from one another.*/

---Q2: Release date of the common movies and the first one added to the platform

WITH common_movies AS (
    SELECT 
        netflix.title AS title, 
        netflix.release_year AS netflix_release_year,
        disney.release_year AS disney_release_year,
        netflix.date_added AS netflix_date_added,
        disney.date_added AS disney_date_added,

        CASE 
            WHEN netflix.date_added < disney.date_added THEN 'Netflix'
            WHEN disney.date_added < netflix.date_added THEN 'Disney'
            ELSE 'Both' 
        END AS first_added_platform
    FROM 
        netflix_titles netflix 
    INNER JOIN 
        disney_plus_titles disney
    ON 
        netflix.title = disney.title
    WHERE 
        netflix.type = 'Movie' AND disney.type = 'Movie'
)
SELECT 
    title, 
    netflix_release_year, 
    disney_release_year, 
	netflix_date_added,
	disney_date_added,
    LEAST(netflix_date_added, disney_date_added) AS first_added_to_platform_date,
    first_added_platform
FROM 
    common_movies
ORDER BY 
    first_added_to_platform_date;




	--
	WITH common_movies AS (
    SELECT 
        netflix.title AS title, 
        netflix.release_year AS netflix_release_year,
        disney.release_year AS disney_release_year,
        netflix.date_added AS netflix_date_added,
        disney.date_added AS disney_date_added,

        CASE 
            WHEN netflix.date_added < disney.date_added THEN 'Netflix'
            WHEN disney.date_added < netflix.date_added THEN 'Disney'
            ELSE 'Both' 
        END AS first_added_platform
    FROM 
        netflix_titles netflix 
    INNER JOIN 
        disney_plus_titles disney
    ON 
        netflix.title = disney.title
    WHERE 
        netflix.type = 'TV show' AND disney.type = 'TV show'
)
SELECT 
    title, 
    netflix_release_year, 
    disney_release_year, 
	netflix_date_added,
	disney_date_added,
    LEAST(netflix_date_added, disney_date_added) AS first_added_to_platform_date,
    first_added_platform
FROM 
    common_movies
ORDER BY 
    first_added_to_platform_date;
/*This query focuses on determining the release date of shared movies and identifying which platform added them first.
Knowing the initial release dates and acquisition timelines can guide strategies for securing popular titles early*/


---Q3: First movie added on each platform based on date_added column

SELECT title, date_added, 'Netflix' AS platform
FROM netflix_titles
WHERE type = 'Movie'
AND date_added = (SELECT MIN(date_added) FROM netflix_titles WHERE type = 'Movie')

UNION ALL

SELECT title, date_added, 'Disney' AS platform
FROM disney_plus_titles
WHERE type = 'Movie'
AND date_added = (SELECT MIN(date_added) FROM disney_plus_titles WHERE type = 'Movie');


---
SELECT title, date_added, 'Netflix' AS platform
FROM netflix_titles
WHERE type = 'TV show'
AND date_added = (SELECT MIN(date_added) FROM netflix_titles WHERE type = 'TV show')

UNION ALL

SELECT title, date_added, 'Disney' AS platform
FROM disney_plus_titles
WHERE type = 'TV show'
AND date_added = (SELECT MIN(date_added) FROM disney_plus_titles WHERE type = 'TV show');

/*This analysis reveals the very first movie added to Netflix and Disney Plus.
By examining the initial content strategy, business teams can analyze the impact of early content 
choices on subscriber growth, user engagement, and platform brand identity.*/



---Q4:what is the Average duration for each category in listed_in column based on date_added and its release date
WITH platform_data AS (
    SELECT title,date_added,listed_in, 
        CAST(SUBSTRING(duration, 1, LEN(duration)-4) AS INT) AS duration_minutes, release_year, 'Netflix' AS platform
    FROM  netflix_titles inner join netflix_listed_in
		on netflix_titles.show_id=netflix_listed_in.show_id
    WHERE type = 'Movie'
	


    UNION ALL


    SELECT title, date_added, listed_in, 
        CAST(SUBSTRING(duration, 1, LEN(duration)-4) AS INT) AS duration_minutes,  release_year,  'Disney' AS platform
    FROM disney_plus_titles inner join diseny_listed_in
		on disney_plus_titles.show_id=diseny_listed_in.show_id
    WHERE  type = 'Movie'
)

SELECT platform,listed_in, AVG(duration_minutes) AS avg_duration
FROM platform_data
GROUP BY platform, listed_in
ORDER BY platform, avg_duration ;

---


/*This analysis calculates the average movie duration for each content category (e.g., Action, Comedy)
on both platforms. Understanding the typical length of movies by listed_in helps align future content acquisitions
with user viewing preferences, improve audience retention, and refine content recommendations.*/

