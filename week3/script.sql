SELECT * FROM Species;
.tables
--limiting rows
SELECT * FROM Species LIMIT 5;
SELECT * FROM Species LIMIT 5 OFFSET 5;
-- How many rows?
SELECT COUNT(*) FROM Species;
-- If you put a column name in COUNT(), how many Non-NULL values?
SELECT COUNT(Scientific_name) FROM Species;
-- Can select which columns to return by naming them
SELECT Code, Common_name FROM Species;
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;
-- get distinct combinations
SELECT DISTINCT Species, Observer FROM Bird_nests;
-- ordering of results
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;
-- exercise: what distinct locations occur in the site table? Order them, limit to 3 results
SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;
--


-- Assignment 2 question 1:
CREATE TEMP TABLE temptable (
    numbers REAL
);

INSERT INTO temptable (numbers) VALUES (1), (2), (3), (NULL);

SELECT AVG(numbers) from temptable;

SELECT SUM(numbers)/COUNT(*) FROM temptable;

DROP TABLE temptable;

-- Assignment 2 question 2:
----- Part 1: this code doesn't work
SELECT Site_name, MAX(Area) FROM Site;

----- Part 2
SELECT Site_name, Area FROM Site ORDER BY Area DESC LIMIT 1;

----- Part 3
SELECT Site_name, Area FROM Site WHERE Area = (SELECT MAX(Area) FROM Site);

-- Assignment 2 question 3:
---- Using the Bird_eggs dataset, calculate average volume of eggs laid in each nest
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14/6) * (Width^2) * Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;

SELECT * FROM Averages;
---- Output a table with the scientific name of each bird species and the max average egg volume 
SELECT s.Scientific_name, MAX(a.Avg_volume) as Max_Avg_Volume
    FROM Bird_nests b 
    JOIN Averages a ON b.Nest_ID = a.Nest_ID -- Join Nest_ID in Averages to Nest_ID in Bird_nests table
    JOIN Species s ON b.Species = s.Code -- Join Species in Bird_nests table to Code in Species table
    GROUP BY Scientific_name
    ORDER BY Max_Avg_Volume DESC;

DROP TABLE Averages;

SELECT s.Scientific_name, MAX(a.Avg_volume) as Max_Avg_Volume
    FROM Bird_nests b 
    JOIN Averages a USING (Nest_ID) -- Join Nest_ID in Averages to Nest_ID in Bird_nests table
    JOIN Species s ON b.Species = s.Code -- Join Species in Bird_nests table to Code in Species table
    GROUP BY Scientific_name
    ORDER BY Max_Avg_Volume DESC;

