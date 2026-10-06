# Cyclistic Analysis
Cyclistic is a fictional bike-share company in Chicago with casual riders and annual members. Casual riders consist of customers who purchase single-ride and full-day passes, whilst Cyclistic members are those who purchase an annual membership. Financial analysts have determined that annual memberships are the most profitable.

## Business Task
How do annual members and casual riders use Cyclistic bike differently?

### Stakeholders
Lily Moreno, Director of Marketing

Cyclistic executive team

Cyclistic marketing analytics team

# Data sources

- This analysis uses the monthly data from 09/2025 to 08/2026.
- This data was made available by Motivate International Inc. under [this license](https://divvybikes.com/data-license-agreement). The records contain no personal information and the data is current.
- The collated dataframe has 13 columns and 6115982 rows
- Each row represents a single bike trip identified using it's corresponding ride_id. Each entry consists of the start location and time, and end location and time. There are two bike types, electric and classic, and two customer types, casual or member.
  

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
This shows that all duplicate ride IDs arise from fully identical rows

```sql
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
```

The only columns with 'NULL' values are those concerning the docking location of the bikes. This mostly happens with the electric bikes as they do not have to be picked up from or returned to a docking station.

```sql
SELECT
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 60) AS under_1_min,
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 86400) AS over_24_hrs,
  COUNTIF(ended_at < started_at) AS negative_duration
FROM `bike-share-509605.cyclistic_data.all_trips`;
```

This query returns 158,904 trips under 1 minute, including 29 negative times, and 5309 over 24 hours.

```sql
SELECT LENGTH(ride_id) AS id_length, COUNT(*) AS num_rows
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY id_length
ORDER BY id_length;
```

All of the IDs are of the same length (16)

```sql
SELECT rideable_type, COUNT(*) AS num_rows
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY rideable_type
ORDER BY num_rows DESC;
```

All of the bikes are of type 'electric' or 'classic'

```sql
SELECT member_casual, COUNT(*) AS num_rows
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY member_casual
ORDER BY num_rows DESC;
```

All customers are of type 'casual' or 'member'

```sql
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
```

All locations longitude and latitude coordinates lie within Chicago

```sql
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS names
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY start_station_id
HAVING names > 1;

SELECT end_station_id, COUNT(DISTINCT end_station_name) AS names
FROM `bike-share-509605.cyclistic_data.all_trips`
GROUP BY end_station_id
HAVING names > 1;
```

There are 60 'start_station_id's that have 2 start station names. There are 58 'end_station_id's that have have two end station names; these represent different wordings of the names of the docking stations.


# Data cleaning

## In order to clean the data: 
- I removed all duplicate ride_id's and trips under 1 minute and above 24 hours. I assume that these trips arise from errors in the data or from false starts when using the bike service.
- Null entries are to remain in the cleaned dataset as queries can still include these rows without reference to the stations.
- Queries on this dataset will references stations through station_id instead of station names to avoid any spelling/naming issues.

```sql
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
```

This creates a new table satisfying the conditions, whilst preserving the record of the original data. The new table contains 16 columns and 5951738 rows. The three new columns:
- **ride_length_min** displays the length of the trip in minutes to two decimal places
- **day_of_week** and **month_name** display the day and month of the trips respectively, allowing for easier filtering in the analysis process.

Note that there were 4 cases where a 'test' station was named so these have been removed through the final 'where' conditions.

I ran the following queries to ensure the changes were successful:

```sql
SELECT
  COUNT(*)
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
WHERE LOWER(start_station_name) LIKE '%test%'
   OR LOWER(end_station_name) LIKE '%test%';
```

```sql
SELECT 
  COUNT(*)
 FROM `bike-share-509605.cyclistic_data.all_trips_clean` 
  WHERE ride_length_min < 1 OR ride_length_min > (60*24)
```

```sql
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS distinct_ride_ids,
  COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_rides
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
```
The first two returned 0, and third confirmed 0 duplicate rows.

# Analysis 
To analyse the difference in bike usage between members and casual riders, I used a set of queries and visualisations

## 1. Average ride length and share of ride total per customer type
### **Question:** How does the average ride length vary by customer type? 

```sql
SELECT
  member_casual,
  ROUND(AVG(ride_length_min), 2) AS avg_ride_length,
  COUNT(*) AS total_rides,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 2) AS percentage_of_total
FROM `bike-share-509605.cyclistic_data.all_trips_clean`
GROUP BY member_casual;
```
This query groups customers by member and casual riding types, returning the average ride length, total number of rides for each type, and the percentage of the total number of customers.
**Findings:** Members have an average ride length of 12.21 minutes and account for 65/% (3870716) of all customers, whereas casuals have an average ride length 18.41 minutes and account for 35% (2081022)

<img width="400" alt="image" src="https://github.com/user-attachments/assets/a0a852cf-3f7b-462f-8de5-6a6e33be960b" />


