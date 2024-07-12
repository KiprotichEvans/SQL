-- Create the database
CREATE DATABASE llin_analysis;
GO

-- Use the newly created database
USE llin_analysis;
GO

-- Create the table
CREATE TABLE llin_distribution (
    ID INT PRIMARY KEY,
    Number_distributed INT,
    Location NVARCHAR(255),
    Country NVARCHAR(255),
    Year INT,
    By_whom NVARCHAR(255),
    Country_code NVARCHAR(3)
);

-- Select all Data
SELECT *
FROM llin_distribution



-- Total number of LLINs distributed in each country
SELECT Country, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Country;



-- Average number of LLINs distributed per distribution event
SELECT AVG(Number_distributed) AS Average_LLINS_Per_Event
FROM llin_distribution;



-- Earliest and latest distribution years
SELECT MIN(Year) AS Earliest_Distribution_Year, MAX(Year) AS Latest_Distribution_Year
FROM llin_distribution;



-- Total number of LLINs distributed by each organization
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom;



-- Total number of LLINs distributed in each year
SELECT Year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Year;



-- Location with the highest number of LLINs distributed
SELECT TOP 1 Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed DESC;



-- Location with the lowest number of LLINs distributed
SELECT TOP 1 Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed ASC;



-- Significant difference in the number of LLINs distributed by different organizations
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom
ORDER BY Total_LLINS_Distributed DESC;



-- Identify significant spikes in the number of LLINs distributed in specific locations
SELECT TOP 10 Location, Year, Number_distributed
FROM llin_distribution
ORDER BY Number_distributed DESC;


-- Identify outliers in the number of LLINs distributed
WITH DistributionStats AS (
    SELECT 
        AVG(Number_distributed) AS Avg_Distributed,
        STDEV(Number_distributed) AS StdDev_Distributed
    FROM llin_distribution
)
SELECT *
FROM llin_distribution
WHERE Number_distributed > (
        SELECT Avg_Distributed + 3 * StdDev_Distributed 
        FROM DistributionStats
    )
   OR Number_distributed < (
        SELECT Avg_Distributed - 3 * StdDev_Distributed 
        FROM DistributionStats
    );

