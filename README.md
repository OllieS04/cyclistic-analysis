# Cyclistic Analysis
Cyclistic is a fictional bike-share company in Chicago with casual riders and annual members. Casual riders consist of customers who purchase single-ride and full-day passes, whilst Cyclistic members are those who purchase an annual membership. Financial analysts have determined that annual memberships are the most profitable.

## Business Task
Analyse how annual members and casual riders use Cyclistic's bikes, informing marketing strategies aimed at converting casual riders into annual members.

### Stakeholders
Lily Moreno, Director of Marketing

Cyclistic executive team

Cyclistic marketing analytics team

# Data sources

- This analysis uses the monthly data from 09/2025 to 08/2026.
- This data was made available by Motivate International Inc. under [this license](https://divvybikes.com/data-license-agreement)

## Data issues

### Duplicate ride IDs: 35 rows sharing a 'ride_id'

```sql
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS distinct_ride_ids,
  COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_rides
FROM `bike-share-509605.cyclistic_data.all_trips`;
```
```sql
SELECT
  COUNT(*) AS total_rows,
  (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM `bike-share-509605.cyclistic_data.all_trips`)) AS distinct_rows,
  COUNT(*) - (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM `bike-share-509605.cyclistic_data.all_trips`)) AS rows_removed
FROM `bike-share-509605.cyclistic_data.all_trips`;
```
This shows that all duplicate ride IDs arrive from genuine data duplicates

## 

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
