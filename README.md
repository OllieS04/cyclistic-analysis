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

**Findings:** Members have an average ride length of 12.21 minutes and account for 65% (3,870,716) of all rides, whereas casuals have an average ride length 18.41 minutes and account for 35% (2,081,022). For this analysis, I will focus on comparing the proportions of relative totals per customer type as working with percentages provides an easier medium for comparison when the totals for two the two types significantly different.

<img width="400" alt="image" src="https://github.com/user-attachments/assets/a0a852cf-3f7b-462f-8de5-6a6e33be960b" />

## 2. Distribution of rides by day of the week and month of the year

### **Question:** Which days of the week and months of the year are most and least popular respective of customer type.

**Findings:** 
- Casual rides increase significantly in the summer months
- Casual rides increase significantly at weekends; Saturday accounts for over 20% of the weekly casual rides on average
- Members rides are fairly uniformly distributed across the week

<img width="400" alt="image" src="https://github.com/user-attachments/assets/ce95bb3e-66fb-4160-9151-8671166a7dc6" />

**Inference:** 
- Casual rides are likely more frequently for leisure purposes, being notably popular at weekends and in the summer, and lasting for an average of 6 minutes longer per journey
- Existing members are likely commuters as bike usage varies less by day of the week and month of the year. The peaking in the summer would likely naturally arise as warmer weather encourages more people to cycle to work. 

## 3. Distribution of rides by time of day

### **Questions:** How do the most popular riding times vary between customer types on weekdays and at the weekend?

**Findings:**
- There is a significantly higher proportion of member riders then casual riders between 5am to 10am on weekdays
- Outside of peak commute hours, casual rides become more popular, respectively, on weekdays
- There is no significant difference between the two customer types usage by time of day at weekends. There is a marginally higher peak for casual riders from 1pm to 5pm

<img width="400" alt="image" src="https://github.com/user-attachments/assets/451fbdc0-baa8-4504-be29-412c82ac07f3" />

**Inference:** 
- This data supports the previous inference, namely, members are likely using bikes for work commutes. It can also be infered that many casual riders also do, but more so for return trips from work back home.

## 4. Most popular bike stations and bike type for each customer type

### **Questions:** What information can be inferred from the most popular stations and bike type for each customer type?

**Findings:**
- Navy Pier appears as a start or end station significantly more times than any other station for casual riders (over 50,000 rides, the second most is 30,000)
- The most popular locations for casual rides are large public spaces and venues
- The most popular stations with member riders have less variation in quantity and are all 'street stations'
- Electric bikes are significantly more popular than classic bikes within both groups, and most popular for casual riders respectively

<img width="600" alt="image" src="https://github.com/user-attachments/assets/0f8aa8d1-c392-4b39-aa4d-ef5c610f27b2" />

**Inference:** 
- Further evidence to suggest many casual riders use bikes leisurely
- A marketing campaign aimed at converting casual riders to members would be best advertised in and around public landmarks as these are the most visited stations for casual riders
  
# Summary and actionable recommednations
## Summary

From the analysis completed, I conclude the following as the most significant differences between casual riders and those with a membership:

- Existing member primarily use the bikes for commutes to and from work. Casual riders use the bikes for more leisurely purposes
- Summer time and weekends see a spike in ride quantity with casual riders
- Casual riders frequently use bikes in and around large public landmarks

## Actionable recommendations

### 1) Advertise the campaign at the Navy Pier and other popular public landmarks
Public landmark locations see the highest number of casual rides. The campaign could be initiated at Navy Pier, measured for effectiveness, then scaled to other locations appropriately.

### 2) Run campaigns and memberships in summer and at weekends
The data shows that casual rides increase significantly on Saturdays and in summer. Consider offering a summer and/or weekend use membership. Current casual riders may not need to use bikes as much on weekdays all year round, so a cheaper personalised membership would be appealing. 

### 3) Include ride duration perks within the membership
Offer credit bonuses or discounts for member rides over  a certain duration e.g. 15 minutes. The average ride time for casual riders is 18.4 minutes, above this threshold, so they will see a clear benefit by switching to memberships, whilst still protecting the profitability of the existing member base, subject to financial modelling.


