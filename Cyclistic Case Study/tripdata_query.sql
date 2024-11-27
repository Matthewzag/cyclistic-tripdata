
-- Step 1: Combine all monthly trip data tables into one table for analysis --
DROP TABLE IF EXISTS combined_tripdata;

-- The combined table will include data from January 2023 to August 2024
SELECT *
INTO combined_tripdata
FROM (
    SELECT * FROM [GoogleCapstoneA].[dbo].['202408-divvy-tripdata$'] -- August 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202407-divvy-tripdata$'] -- July 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202406-divvy-tripdata$'] -- June 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202405-divvy-tripdata$'] -- May 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202404-divvy-tripdata$'] -- April 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202403-divvy-tripdata$'] -- March 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202402-divvy-tripdata$'] -- February 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202401-divvy-tripdata$'] -- January 2024 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202312-divvy-tripdata$'] -- December 2023 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202311-divvy-tripdata$'] -- November 2023 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202310-divvy-tripdata$'] -- October 2023 data
    UNION
    SELECT * FROM [GoogleCapstoneA].[dbo].['202309-divvy-tripdata$'] -- September 2023 data
) combined_tripdata;

-- Step 2: Remove incomplete records where 'ride_id' is NULL --
DELETE FROM combined_tripdata WHERE ride_id IS NULL;

-- Step 3: Separate the data by membership type --
-- Members: Users with subscriptions (expected: only rows with 'member_casual' = 'member').
SELECT * FROM combined_tripdata WHERE member_casual = 'member'; -- Query for members

-- Casual: Users without subscriptions (expected: only rows with 'member_casual' = 'casual').
SELECT * FROM combined_tripdata WHERE member_casual = 'casual'; -- Query for casual riders

-- Step 4: Identify the longest rides for members and casual riders --
-- For members, create a table to store the ride ID, max ride length, day of the week, and user type.
DROP TABLE IF EXISTS ride_length_member;
SELECT *
INTO ride_length_member
FROM (
    SELECT
        ride_id,
        MAX(CAST(ride_length AS TIME)) AS ride_length, -- Convert to TIME format for readability
        day_of_week, -- Day when the ride occurred
        member_casual
    FROM combined_tripdata
    WHERE member_casual = 'member'
    GROUP BY ride_length, member_casual, day_of_week, ride_id
) ride_length_member;

-- View the longest rides for members, sorted in descending order of ride length.
SELECT * FROM ride_length_member ORDER BY ride_length DESC;

-- Repeat the same analysis for casual riders.
DROP TABLE IF EXISTS ride_length_casual;
SELECT *
INTO ride_length_casual
FROM (
    SELECT
        ride_id,
        MAX(CAST(ride_length AS TIME)) AS ride_length,
        day_of_week,
        member_casual
    FROM combined_tripdata
    WHERE member_casual = 'casual'
    GROUP BY ride_length, member_casual, day_of_week, ride_id
) ride_length_casual;

-- View the longest rides for casual riders, sorted in descending order of ride length.
SELECT * FROM ride_length_casual ORDER BY ride_length DESC;

-- Step 5: Calculate the average ride length for members and casual riders --
-- Average ride time for members (result: a single value representing the average).
DROP TABLE IF EXISTS average_ride_member;
SELECT
    CAST(AVG(CAST(ride_length AS FLOAT)) AS TIME) AS avg_ride_member
INTO average_ride_member
FROM combined_tripdata WHERE member_casual = 'member';

-- Average ride time for casual riders (result: a single value representing the average).
DROP TABLE IF EXISTS average_ride_casual;
SELECT
    CAST(AVG(CAST(ride_length AS FLOAT)) AS TIME) AS avg_ride_casual
INTO average_ride_casual
FROM combined_tripdata WHERE member_casual = 'casual';

-- Step 6: Determine the most popular days for rides by type --
-- Total ride counts by day of the week for all riders.
DROP TABLE IF EXISTS rides_by_day;
SELECT
    day_of_week,
    COUNT(day_of_week) AS rider_day_of_week -- Count of rides for each day
INTO rides_by_day
FROM combined_tripdata
GROUP BY day_of_week;

-- Similar breakdowns for members and casual riders.
DROP TABLE IF EXISTS rides_by_day_member, rides_by_day_casual;
SELECT
    day_of_week,
    COUNT(day_of_week) AS count_of_days
INTO rides_by_day_member
FROM combined_tripdata
WHERE member_casual = 'member'
GROUP BY day_of_week;

SELECT
    day_of_week,
    COUNT(day_of_week) AS count_of_days
INTO rides_by_day_casual
FROM combined_tripdata
WHERE member_casual = 'casual'
GROUP BY day_of_week;

-- Step 7: Analyze preferences for bike types (classic vs electric) --
DROP TABLE IF EXISTS classic_bike_member, electric_bike_member, classic_bike_casual, electric_bike_casual;

-- Classic bikes for members.
SELECT
    COUNT(ride_id) AS classic_bike_member
INTO classic_bike_member
FROM combined_tripdata
WHERE member_casual = 'member' AND rideable_type = 'classic_bike';

-- Electric bikes for members.
SELECT
    COUNT(ride_id) AS electric_bike_member
INTO electric_bike_member
FROM combined_tripdata
WHERE member_casual = 'member' AND rideable_type = 'electric_bike';

-- Classic bikes for casual riders.
SELECT
    COUNT(ride_id) AS classic_bike_casual
INTO classic_bike_casual
FROM combined_tripdata
WHERE member_casual = 'casual' AND rideable_type = 'classic_bike';

-- Electric bikes for casual riders.
SELECT
    COUNT(ride_id) AS electric_bike_casual
INTO electric_bike_casual
FROM combined_tripdata
WHERE member_casual = 'casual' AND rideable_type = 'electric_bike';

-- Step 8: Examine average ride lengths and starting hours by day of the week --
DROP TABLE IF EXISTS avg_by_day_member, avg_by_day_casual, start_hour_member, start_hour_casual;

-- Average ride lengths for members by day of the week.
SELECT
    CAST(AVG(CAST(ride_length AS FLOAT)) AS TIME) AS avg_ride_length,
    day_of_week
INTO avg_by_day_member
FROM combined_tripdata
WHERE member_casual = 'member'
GROUP BY day_of_week;

-- Average ride lengths for casual riders by day of the week.
SELECT
    CAST(AVG(CAST(ride_length AS FLOAT)) AS TIME) AS avg_ride_length,
    day_of_week
INTO avg_by_day_casual
FROM combined_tripdata
WHERE member_casual = 'casual'
GROUP BY day_of_week;

-- Extract ride start hours for members.
SELECT
    ride_id,
    member_casual,
    DATEPART(HOUR, CAST(started_at AS TIME)) AS start_hour
INTO start_hour_member
FROM combined_tripdata
WHERE member_casual = 'member';

-- Extract ride start hours for casual riders.
SELECT
    ride_id,
    member_casual,
    DATEPART(HOUR, CAST(started_at AS TIME)) AS start_hour
INTO start_hour_casual
FROM combined_tripdata
WHERE member_casual = 'casual';
