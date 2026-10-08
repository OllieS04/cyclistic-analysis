-- quantity of rides and average ride length per customer type
SELECT
  member_casual,
  ROUND(AVG(ride_length_min), 2) AS avg_ride_length,
  COUNT(*) AS total_rides
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual;

-- distribution of rides per day, per customer type
SELECT
  member_casual,
  day_of_week,
  ROUND(AVG(ride_length_min), 2) AS avg_ride_length
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual, day_of_week
ORDER BY member_casual, avg_ride_length DESC;

-- distribution of rides per month, per customer type
SELECT
  member_casual,
  month_name,
  COUNT(*) AS quantity,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_casual), 2) AS pct_of_type
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual, month_name
ORDER BY member_casual, month_name;

-- distribution of usage by time of day
SELECT
  member_casual,
  CASE WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend' ELSE 'Weekday' END AS day_type,
  FLOOR(EXTRACT(HOUR FROM started_at) / 3) * 3 AS start_interval,
  COUNT(*) AS total_rides,
  COUNT(DISTINCT DATE(started_at)) AS num_days
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual, day_type, start_interval
ORDER BY member_casual, day_type, start_interval;

-- rideable type usage per customer time
SELECT 
  rideable_type,
  member_casual,
  COUNT(*) as total,
  ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY member_casual), 2) AS pct
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual, rideable_type

-- most used stations
SELECT *
FROM (
  SELECT
    member_casual,
    start_station_id,
    MAX(start_station_name) AS station_name,
    COUNT(*) AS total_rides,
    ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(*) DESC) AS station_rank
  FROM `bike-share-509605.cyclistic_data.all_trips_clean`
  WHERE start_station_id IS NOT NULL
  GROUP BY member_casual, start_station_id
)
WHERE station_rank <= 10
ORDER BY member_casual, station_rank;
