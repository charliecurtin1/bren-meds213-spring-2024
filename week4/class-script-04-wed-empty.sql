-- opening DuckDB with no database file , aka "in-memory"
> duckdb

-- opening an existing database with DuckDB
> duckdb database_filename.db

-- But Beware!! if you provide a filename that does not exist, DuckDB will create a new empty database with that name
> duckdb database_filename_with_tyop.db

-- Always good to check you have the right database using `.tables` after opening the database


-- Ask 1: What is the average snow cover at each site?
SELECT Site, AVG(Snow_cover) FROM Snow_cover
    GROUP BY Site;

SELECT Site, Year, AVG(Snow_cover) FROM Snow_cover
    GROUP BY Site, Year;

-- Ask 2: Order the result to get the top 3 snowy sites?
SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    GROUP BY Site
    ORDER BY avg_cover DESC
    LIMIT 3;

-- Ask 3: Save your results into a temporary table named  Site_avg_snowcover
CREATE TEMP TABLE avg_snow_cover AS
    SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    GROUP BY Site
    ORDER BY avg_cover DESC
    LIMIT 3;

-- Ask 4: How do I check the view was created?
SELECT * FROM avg_snow_cover;
.tables

-- Ask 5: Looking at the data, we have now a doubt about the meaning of the zero values... what if most of them where supposed to be NULL?! Does it matters? write a query that would check that?
SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    WHERE Snow_cover > 0
    GROUP BY Site
    ORDER BY avg_cover DESC;

-- Ask 6: Save your results into a **view** named  Site_avg_snowcover_nozeros
CREATE VIEW Site_avg_snowcover_nozeros AS
    SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    WHERE Snow_cover > 0
    GROUP BY Site
    ORDER BY avg_cover DESC;

-- Ask 7: Compute the difference between those two ways of computing average
SELECT a.Site, a.avg_cover, b.avg_cover FROM avg_snow_cover a
    JOIN Site_avg_snowcover_nozeros b
    ON a.Site = b.Site;

SELECT a.Site, b.avg_cover - a.avg_cover AS avg_diff
    FROM avg_snow_cover a
    JOIN Site_avg_snowcover_nozeros b
    ON a.Site = b.Site;

-- Ask 8: Which site would be the most impacted if zeros were not real zeros? Of Course we need a table for that :)
SELECT Site, A.avg_cover - B.avg_cover AS avg_diff
    FROM avg_snow_cover B
    JOIN Site_avg_snowcover_nozeros A USING (Site)
    ORDER BY avg_diff DESC
    LIMIT 1;

-- Ask 9: So? Would it be time well spent to further look into the meaning of zeros?


-- We found out that actually at the location `sno05` of the site eaba, 0 means NULL... let's update our Snow_cover table

CREATE TABLE Snow_cover_backup AS SELECT * FROM Snow_cover;-- Create a copy of the table to be safe (and not cry a lot)

-- For Recall
SELECT * FROM Site_avg_snowcover;
SELECT * FROM Site_avg_snowcover_nozeros;
-- update the 0 for that site
UPDATE Snow_cover SET Snow_cover = NULL WHERE Location = 'sno05' AND Snow_cover = 0; 
-- Check the update was succesful
SELECT * FROM Snow_cover WHERE Location = 'sno05';
-- We should probably recompute the avg, let's check
SELECT * FROM avg_snow_cover;

-- What just happened!?
----We saved it as a temporary table, so nothing happened. If we had saved it as a view, then it would've updated automatically

CREATE VIEW avg_snow_cover_new AS
    SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    GROUP BY Site
    ORDER BY avg_cover DESC
    LIMIT 3;

-- Ask 10: Let's move on to inspecting the nests and answering the following question: Which shorebird species makes the most eggs? Oh and I need a table with the common names, just because :)

--- Week 4 assignment

-- Part 1: Which sites have no egg data? Answer using all three techniques described in class

SELECT * FROM Bird_eggs;
SELECT * FROM Site;

----- Method 1
SELECT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

----- Method 2: outer join
SELECT Code
    FROM Site LEFT JOIN Bird_eggs ON Code = Site
    WHERE Site IS NULL
    ORDER BY Code;

---- Method 3: using the set operation except
SELECT Code FROM Site
    EXCEPT SELECT DISTINCT Site FROM Bird_eggs
    ORDER BY Code;

-- Part 2: Who worked with whom?
SELECT * FROM Camp_assignment;

SELECT * FROM Camp_assignment A
    JOIN Camp_assignment B ON A.Site = B.Site
    WHERE (A.Start <= B.End) AND (A.End >= B.Start)
    AND (A.Site = 'lkri')
    AND (A.Observer < B.Observer);

---- Outputting the table with the column names changed
SELECT A.Site, A.Observer AS Observer_1, B.Observer as Observer_2 FROM Camp_assignment A
    JOIN Camp_assignment B ON A.Site = B.Site
    WHERE (A.Start <= B.End) AND (A.End >= B.Start)
    AND (A.Site = 'lkri')
    AND (A.Observer < B.Observer);

