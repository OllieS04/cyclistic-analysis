-- count duplicate ID's
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS distinct_ride_ids,
  COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_rides
FROM `bike-share-509605.cyclistic_data.all_trips`;

-- count duplicate ID's with identical inputs
SELECT
  COUNT(*) AS total_rows,
  (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM `bike-share-509605.cyclistic_data.all_trips`)) AS distinct_rows,
  COUNT(*) - (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM `bike-share-509605.cyclistic_data.all_trips`)) AS rows_removed
FROM `bike-share-509605.cyclistic_data.all_trips`;

-- count nulls per column
SELECT
  rideable_type,
  COUNT(*) AS total_rows,
  COUNTIF(ride_id IS NULL) AS null_ride_id,
  COUNTIF(rideable_type IS NULL) AS null_rideable_type,
  COUNTIF(started_at IS NULL) AS null_started_at,
  COUNTIF(ended_at IS NULL) AS null_ended_at,
  COUNTIF(start_station_name IS NULL) AS null_start_station_name,
  COUNTIF(start_station_id IS NULL) AS null_start_station_id,
  COUNTIF(end_station_name IS NULL) AS null_end_station_name,
  COUNTIF(end_station_id IS NULL) AS null_end_station_id,
  COUNTIF(start_lat IS NULL) AS null_start_lat,
  COUNTIF(start_lng IS NULL) AS null_start_lng,
  COUNTIF(end_lat IS NULL) AS null_end_lat,
  COUNTIF(end_lng IS NULL) AS null_end_lng,
  COUNTIF(member_casual IS NULL) AS null_member_casual
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY rideable_type

-- find rides under 1 minute, over 24 hours, or with a negative duration
SELECT
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 60) AS under_1_min,
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 86400) AS over_24_hrs,
  COUNTIF(ended_at < started_at) AS negative_duration
FROM `bike-share-509605.cyclistic_data.all_trips`;

-- count ID lengths
SELECT LENGTH(ride_id) AS id_length, COUNT(*) AS num_rows
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY id_length
ORDER BY id_length;

-- check bike types
SELECT rideable_type, COUNT(*) AS num_rows
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY rideable_type
ORDER BY num_rows DESC;

-- check max and min lat and long values
SELECT
  MAX(start_lat) AS max_start_lat,
  MIN(start_lat) AS min_start_lat,
  MAX(start_lng) AS max_start_lng,
  MIN(start_lng) AS min_start_lng,
  MAX(end_lat)   AS max_end_lat,
  MIN(end_lat)   AS min_end_lat,
  MAX(end_lng)   AS max_end_lng,
  MIN(end_lng)   AS min_end_lng
FROM `bike-share-509605.cyclistic_data.all_trips`;

-- check for stations with the same ID but a different name
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS names
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY start_station_id
HAVING names > 1;

SELECT end_station_id, COUNT(DISTINCT end_station_name) AS names
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY end_station_id
HAVING names > 1;

-- create/replace new table
CREATE OR REPLACE TABLE `bike-share-509605.cyclistic_data.all_trips_clean` AS
SELECT
  *,
  ROUND(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 60, 2) AS ride_length_min,
  FORMAT_TIMESTAMP('%A', started_at) AS day_of_week,
  FORMAT_TIMESTAMP('%B', started_at) AS month_name
FROM (
  SELECT DISTINCT *
  FROM `bike-share-509605.cyclistic_data.all_trips`
)
WHERE TIMESTAMP_DIFF(ended_at, started_at, SECOND) BETWEEN 60 AND 86400
AND (LOWER(start_station_name) NOT LIKE '%test%' OR start_station_name IS NULL)
AND (LOWER(end_station_name) NOT LIKE '%test%' OR end_station_name IS NULL)

-- ensure 'test' stations have been removed 
SELECT
  COUNT(*)
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
WHERE LOWER(start_station_name) LIKE '%test%'
   OR LOWER(end_station_name) LIKE '%test%';

-- check outliers have been removed
SELECT 
  COUNT(*)
 FROM `bike-share-509605.cyclistic_data.all_trips_clean` 
  WHERE ride_length_min < 1 OR ride_length_min > (60*24)

-- check duplicate ID's have been removed
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS distinct_ride_ids,
  COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_rides
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
