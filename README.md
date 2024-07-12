# LLIN Distribution Analysis

## Overview

This project aims to analyze the distribution of Long-Lasting Insecticidal Nets (LLINs) across various locations in multiple countries. The goal is to understand distribution patterns, identify trends, and gain insights into the effectiveness of different distribution campaigns.

## Dataset Overview

The dataset contains the following columns:

- `ID`: A unique identifier for each distribution record.
- `Number_distributed`: The number of LLINs distributed.
- `Location`: The specific location where the LLINs were distributed.
- `Country`: The country where the distribution took place.
- `Year`: The period during which the distribution occurred.
- `By_whom`: The organization responsible for the distribution.
- `Country_code`: The ISO code of the country.

## Tasks

### 1. Database and Table Setup

Create a database named `llin_analysis`. Create a table named `llin_distribution` with the appropriate columns based on the dataset provided.

```sql
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
```

### 2. Descriptive Statistics

#### a. Calculate the total number of LLINs distributed in each country:

```sql
WITH CountryDistribution AS (
    SELECT Country, SUM(Number_distributed) AS Total_LLINS_Distributed
    FROM llin_distribution
    GROUP BY Country
)
SELECT *
FROM CountryDistribution;
```

#### b. Find the average number of LLINs distributed per distribution event:

```sql
WITH AvgDistribution AS (
    SELECT AVG(Number_distributed) AS Average_LLINS_Per_Event
    FROM llin_distribution
)
SELECT *
FROM AvgDistribution;
```

#### c. Determine the earliest and latest distribution dates in the dataset:

```sql
WITH DistributionYears AS (
    SELECT MIN(Year) AS Earliest_Distribution_Year, MAX(Year) AS Latest_Distribution_Year
    FROM llin_distribution
)
SELECT *
FROM DistributionYears;
```

### 3. Trends and Patterns

#### Identify the total number of LLINs distributed by each organization:

```sql
-- Total number of LLINs distributed by each organization using a CTE
WITH OrganizationDistribution AS (
    SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
    FROM llin_distribution
    GROUP BY By_whom
)
SELECT *
FROM OrganizationDistribution
ORDER BY Total_LLINS_Distributed DESC;
```

#### Calculate the total number of LLINs distributed in each year:

```sql
-- Total number of LLINs distributed in each year
SELECT Year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Year;
```

### 4. Volume Insights

#### a. Find the locations with the highest and lowest number of LLINs distributed:

```sql
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
```

#### b. Determine if there's a significant difference in the number of LLINs distributed by different organizations:

```sql
-- Significant difference in the number of LLINs distributed by different organizations
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom
ORDER BY Total_LLINS_Distributed DESC;
```

### 5. Identifying Extremes

#### Identify any outliers or significant spikes in the number of LLINs distributed in specific locations or periods:

```sql
-- Identify outliers in the number of LLINs distributed using a CTE
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
```

## How to Use

1. Clone the repository to your local machine.
2. Create the database and table by executing the SQL scripts in Task 1.
3. Load the dataset into the `llin_distribution` table.
4. Run the SQL scripts for the remaining tasks to perform the analysis.
