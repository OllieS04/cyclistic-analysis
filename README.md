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
- Each row represents a single bike trip identified using its corresponding ride_id. Each entry consists of the start location and time, and end location and time. There are two bike types, electric and classic, and two customer types, casual or member.
  

## Data observations

- 35 duplicate ride IDs (all arising from identical rows)
- 'NULL' values in locations for reasons such as not needing to dock electric bikes
- 158,904 trips under 1 minute, including 29 negative durations, and 5309 over 24 hours
- All IDs are the same length
- All bikes are of type 'electric' or 'classic'
- All locations lie within Chicago
- 60 'start_station_id's that have 2 start station names, and 58 'end_station_id's that have have two end station names; these represent different wordings of the names of the docking stations

# Data cleaning

## In order to clean the data: 
- Removed all duplicate ride_id's and trips under 1 minute and above 24 hours. I assume that these trips arise from errors in the data or from false starts when using the bike service.
- Null entries are to remain in the cleaned dataset as queries can still include these rows without reference to the stations.
- Queries on this dataset will reference stations through station_id instead of station names to avoid any spelling/naming issues.

Created a new table satisfying the new conditions whilst preserving a record of the original data. The new table contains 16 columns and 5,951,738 rows. The three new columns:
- **ride_length_min** displays the length of the trip in minutes to two decimal places
- **day_of_week** and **month_name** display the day and month of the trips respectively, allowing for easier filtering in the analysis process.
Note that there were 4 cases where a 'test' station was named so these have also been removed.


# Analysis 

## 1. Average ride length and share of ride total per customer type

### **Question:** How does the average ride length vary by customer type? 

**Findings:** Members have an average ride length of 12.21 minutes and account for 65% (3,870,716) of all rides, whereas casuals have an average ride length 18.41 minutes and account for 35% (2,081,022).

<img width="400" alt="image" src="https://github.com/user-attachments/assets/a0a852cf-3f7b-462f-8de5-6a6e33be960b" />

## 2. Distribution of rides by day of the week and month of the year

### **Question:** Which days of the week and months of the year account for the larger and smaller proportions for each customer type?




