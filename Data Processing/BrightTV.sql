-----------------------------------------------------------------------------------------------------------------------------------------
---Checking both tables work
-----------------------------------------------------------------------------------------------------------------------------------------
select * from `workspace`.`brighttv`.`USERPROFILES` limit 100;

select * from `workspace`.`brighttv`.`VIEWERSHIP` limit 100;


-------------------------------------------------------------------------------------------------------------------------------------------
---QUERY 1:
---Combining the two tables using the FULLER OUTER JOIN AND LEFT JOIN on VIEWERSHIP because it has more important infrormation statements
--- The unessesary information is not include like: name, surname, email adress, social media handles and the duplicated userIDs.
---Used the whole table name and schemas because i kept getting errors about table names being incorrect even if they were.
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT A.UserID,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.Channel2,
       B.RecordDate2,
       B.`Duration 2`
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID;


---------------------------------------------------------------------------------------------------------------------------
---Query 2:
---start and end date for data collection
-------------------------------------------------------------------------------------------------------------------------
SELECT 
    -- Start date (earliest record in SA time)
    CAST(MIN(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS DATE) AS Start_Date_SA,
    -- End date (latest record in SA time)
    CAST(MAX(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS DATE) AS End_Date_SA

FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID;



--------------------------------------------------------------------------------------
---QUERY 3:
---The number of people who subscribed or to find the number of rows.
---Found that it is 11 295 people
---------------------------------------------------------------------------------------
SELECT COUNT(*) AS total_viewers
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID;


----------------------------------------------------------------------------------------
---QUERY 4:
---Finding the number of distinct user profiles.
--- I found 5375 profiles
----------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT A.UserID) AS distinct_viewers
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID;



-------------------------------------------------------------------------------------
---QUERY 5:
---Viewership per province
---------------------------------------------------------------------------------------
SELECT A.Province,
       COUNT(A.UserID) AS viewership_per_province
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY A.Province
ORDER BY  viewership_per_province DESC;


------------------------------------------------------------------------------------------------------------------------
---Query 6:
---- Viewership by race
-----------------------------------------------------------------------------------------------------------------------
SELECT    
    NULLIF(A.Race, 'Unknown_Race') AS Race,     
    COUNT(A.UserID) AS Viewership_per_race
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY Race
ORDER BY Viewership_per_race DESC;


------------------------------------------------------------------------------------------------------------------------
---Query 7:
---- Viewership by gender
-----------------------------------------------------------------------------------------------------------------------
SELECT    
    COALESCE(NULLIF(A.Gender, 'None'), 'Other_gender') AS Gender,  
    COUNT(A.UserID) AS Viewership_per_gender
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY COALESCE(NULLIF(A.Gender, 'None'), 'Other_gender')
ORDER BY Viewership_per_gender DESC;


------------------------------------------------------------------------------------------------
----Query 8: 
----Categorising ages using case statements and find the number of viewers per age group
-------------------------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN A.Age = 0 THEN 'Non applicable'
        WHEN A.Age BETWEEN 1 AND 12 THEN 'Child (1 to 12)'
        WHEN A.Age BETWEEN 13 AND 17 THEN 'Teenager (13 to 17)'
        WHEN A.Age BETWEEN 18 AND 30 THEN 'Young Adult (18 to 30)'
        WHEN A.Age BETWEEN 31 AND 50 THEN 'Adult (31 to 50)'
        WHEN A.Age BETWEEN 51 AND 65 THEN 'Middle Aged (51 to 65)'
        WHEN A.Age > 65 THEN 'Seniors (greater than 65)'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(B.UserID) AS Viewers_per_age_group
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
    ON A.UserID = B.UserID
GROUP BY 
    CASE 
        WHEN A.Age = 0 THEN 'Non applicable'
        WHEN A.Age BETWEEN 1 AND 12 THEN 'Child (1 to 12)'
        WHEN A.Age BETWEEN 13 AND 17 THEN 'Teenager (13 to 17)'
        WHEN A.Age BETWEEN 18 AND 30 THEN 'Young Adult (18 to 30)'
        WHEN A.Age BETWEEN 31 AND 50 THEN 'Adult (31 to 50)'
        WHEN A.Age BETWEEN 51 AND 65 THEN 'Middle Aged (51 to 65)'
        WHEN A.Age > 65 THEN 'Seniors (greater than 65)'
        ELSE 'Unknown'
    END
ORDER BY 
    Viewers_per_age_group DESC;


    ---------------------------------------------------------------------------------------------------------------------------------------------
    ---Query 9:
    ---Viewership per day
    -------------------------------------------------------------------------------------------------------------------------------------------------
  SELECT 
    CASE 
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 7 THEN 'Saturday'
        WHEN DAYOFWEEK(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) = 1 THEN 'Sunday'
    END AS day_name,
    COUNT(*) AS total_viewership
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY day_name
ORDER BY total_viewership DESC;

        ---------------------------------------------------------------------------------------------------------------------------------------------
    ---Query 10:
    ---Viewership per month
    -------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    MONTHNAME(CAST(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS DATE)) AS Month_Name,
    COUNT(B.userid) AS Number_of_Views_per_month
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
WHERE B.RecordDate2 IS NOT NULL
GROUP BY MONTHNAME(CAST(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS DATE))
ORDER BY Number_of_Views_per_month ;


----------------------------------------------------------------------------------------------------------------------------------
---Query 8:
---Time buckets and finding when people view the most
----------------------------------------------------------------------------------------------------------------------------------
 SELECT 
 --- TIME CLASSIFICATION FROM UTC TO SA
    CASE 
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN 'Late Night'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Midnight'
    END AS Time_bucket,
     COUNT(A.UserID) AS Viewers_per_time_bucket
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY Time_bucket
ORDER BY Viewers_per_time_bucket DESC;

-----------------------------------------------------------------------------------------------------------------------------------------
--Query 12:
--DATA CLEANING NULLS
----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    IFNULL(CAST(ROUND(A.UserID, 0) AS STRING), '0') AS User_ID,
    IFNULL(Gender, 'No_Gender') AS Gender,
    IFNULL(Race, 'No_Race') AS Race,
    IFNULL(CAST(ROUND(Age, 0) AS STRING), '0') AS Age,
    IFNULL(Province, 'No_Province') AS Province,
    IFNULL(Channel2, 'No_Channel1') AS Channel2,
    IFNULL(RecordDate2, 'No_Recorddate') AS RecordDate2,

    --- Fixing time to SA time and making two columns to devide the date and time into two parts
    TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm') AS Timestamp_Value,
    CAST(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm') AS DATE) AS Date_Part,
    DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'HH:mm:ss') AS Time_Part


FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID;

---------------------------------------------------------------------------------------
---QUERY 13:
---Number of users per channel
------------------------------------------------------------------------------------------
SELECT    
      IFNULL(Channel2, 'No_Channel1') AS Channel2,
       COUNT(*) AS viewership_per_channel

FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY B.Channel2
ORDER BY  viewership_per_channel DESC;



------------------------------------------------------------------------------------------
---14 Top 5 most watched
---------------------------------------------------------------------------------------------
SELECT    
       IFNULL(Channel2, 'No_Channel1') AS Channel2,
       COUNT(*) AS viewership_per_channel
FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B
ON A.UserID = B.UserID
GROUP BY B.Channel2
ORDER BY  viewership_per_channel DESC
LIMIT 5;


----------------------------------------------------------------------------------------------------------------
---using some of the above queries to make one big query for the final table.
---using case statements, handling nulls, calculating and using necessary aggregate functions.
-----------------------------------------------------------------------------------------------------------------
SELECT 
    -- Time conversion to SA
    from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg') AS sa_datetime,
    
    -- Start and end date
    CAST(MIN(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) AS DATE) AS Start_Date_SA,
    CAST(MAX(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) AS DATE) AS End_Date_SA,
    
    -- Total counts
    COUNT(*) AS total_viewers,
    COUNT(DISTINCT A.UserID) AS distinct_viewers,
    
    -- Cleaned user info (only cleaned versions)
    IFNULL(CAST(ROUND(A.UserID, 0) AS STRING), '0') AS UserID,
    IFNULL(A.Gender, 'No_Gender') AS Gender,
    IFNULL(A.Race, 'No_Race') AS Race,
    IFNULL(CAST(ROUND(A.Age, 0) AS STRING), '0') AS Age,
    IFNULL(A.Province, 'No_Province') AS Province,
    IFNULL(B.Channel2, 'No_Channel') AS Channel2,
    
    -- Date and time parts
    CAST(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm') AS DATE) AS Date_Part,
    DATE_FORMAT(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'HH:mm:ss') AS Time_Part,
    
    -- Age group
    CASE 
        WHEN A.Age = 0 THEN 'Non applicable'
        WHEN A.Age BETWEEN 1 AND 12 THEN 'Child (1 to 12)'
        WHEN A.Age BETWEEN 13 AND 17 THEN 'Teenager (13 to 17)'
        WHEN A.Age BETWEEN 18 AND 30 THEN 'Young Adult (18 to 30)'
        WHEN A.Age BETWEEN 31 AND 50 THEN 'Adult (31 to 50)'
        WHEN A.Age BETWEEN 51 AND 65 THEN 'Middle Aged (51 to 65)'
        WHEN A.Age > 65 THEN 'Seniors (greater than 65)'
        ELSE 'Unknown'
    END AS Age_Group,
    
    -- Day name
    CASE 
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 7 THEN 'Saturday'
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 1 THEN 'Sunday'
    END AS day_name,
    
    -- Weekend or Weekday
    CASE 
        WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS weekend_weekday,
    
    -- Time bucket
    CASE 
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN 'Late Night'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Midnight'
    END AS Time_bucket,
    
    -- Month name
    MONTHNAME(CAST(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg') AS DATE)) AS Month_Name,
    
    -- Duration
    B.`Duration 2` AS session_duration_minutes,
    
    -- Aggregates per group
    COUNT(*) OVER (PARTITION BY A.Province) AS views_per_province,
    COUNT(*) OVER (PARTITION BY A.Race) AS views_per_race,
    COUNT(*) OVER (PARTITION BY A.Gender) AS views_per_gender,
    COUNT(*) OVER (PARTITION BY 
        CASE 
            WHEN A.Age = 0 THEN 'Non applicable'
            WHEN A.Age BETWEEN 1 AND 12 THEN 'Child (1 to 12)'
            WHEN A.Age BETWEEN 13 AND 17 THEN 'Teenager (13 to 17)'
            WHEN A.Age BETWEEN 18 AND 30 THEN 'Young Adult (18 to 30)'
            WHEN A.Age BETWEEN 31 AND 50 THEN 'Adult (31 to 50)'
            WHEN A.Age BETWEEN 51 AND 65 THEN 'Middle Aged (51 to 65)'
            WHEN A.Age > 65 THEN 'Seniors (greater than 65)'
            ELSE 'Unknown'
        END
    ) AS views_per_age_group,
    COUNT(*) OVER (PARTITION BY 
        CASE 
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 2 THEN 'Monday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 3 THEN 'Tuesday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 4 THEN 'Wednesday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 5 THEN 'Thursday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 6 THEN 'Friday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 7 THEN 'Saturday'
            WHEN DAYOFWEEK(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) = 1 THEN 'Sunday'
        END
    ) AS views_per_day,
    COUNT(*) OVER (PARTITION BY MONTHNAME(CAST(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg') AS DATE))) AS views_per_month,
    COUNT(*) OVER (PARTITION BY 
        CASE 
            WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN 'Late Night'
            WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
            WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
            WHEN DATE_FORMAT(from_utc_timestamp(TO_TIMESTAMP(B.RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
            ELSE 'Midnight'
        END
    ) AS views_per_time_bucket,
    COUNT(*) OVER (PARTITION BY B.Channel2) AS views_per_channel

FROM USERPROFILES AS A
FULL OUTER JOIN VIEWERSHIP AS B ON A.UserID = B.UserID
WHERE B.RecordDate2 IS NOT NULL
GROUP BY 
    sa_datetime,
    A.UserID, Gender, Race, Age, Province, Channel2,
    Date_Part, Time_Part,
    Age_Group, day_name, weekend_weekday, Time_bucket, Month_Name,
    session_duration_minutes,
    A.Province, A.Race, A.Gender, A.Age, B.Channel2
ORDER BY UserID, sa_datetime;
