# Cyclistic Case Study

This project explores Cyclistic's historical bike trip data to understand the differences in usage patterns between casual riders and annual members. The goal is to identify insights and develop marketing strategies to convert casual riders into long-term annual members.

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools and Technologies](#tools-and-technologies)
- [Methodology](#methodology)
- [Key Findings](#key-findings)
- [Recommendations](#recommendations)
- [File Structure](#file-structure)
- [License](#license)

## Project Overview
Cyclistic is a bike-share company based in Chicago. This project analyzes 12 months of bike trip data to:
1. Compare usage patterns of casual riders and members.
2. Provide data-backed marketing strategies for converting casual riders to members.

## Data Sources
The data used in this analysis includes Cyclistic’s anonymized historical trip data from September 2023 to August 2024. Each trip includes:
- Start and end times
- Start and end locations
- Rider type (casual or member)
- Bike type (classic or electric)

The data is publicly available through [Divvy's data portal](https://divvy-tripdata.s3.amazonaws.com/index.html) under the [Divvy Data License Agreement](https://divvybikes.com/data-license-agreement).

## Tools and Technologies
- **Data Cleaning & Analysis**: Excel, SQL
- **Visualization & Reporting**: Power BI
- **Languages**: SQL, Python

## Methodology
1. **Data Cleaning**:
   - Removed trips under 60 seconds or over 24 hours.
   - Standardized date/time formats and corrected data inconsistencies.
2. **Data Analysis**:
   - Analyzed ride durations, peak usage times, and bike preferences.
   - Segmented data by rider type for targeted insights.
3. **Visualization**:
   - Created dashboards in Power BI to visualize key trends and patterns.

## Key Findings
- **Rider Behavior**: Casual riders prefer weekends, while members ride consistently throughout the week.
- **Trip Lengths**: Casual riders have longer trips (average: 21 minutes) compared to members (average: 12 minutes).
- **Bike Preferences**: Classic bikes dominate overall, but electric bikes are favored for longer rides.
- **Seasonality**: Ridership peaks during summer months.

## Recommendations
1. **Flexible Membership Plan**:
   - Introduce a low-cost, "pay-as-you-go" option.
2. **Membership Trials**:
   - Offer a free trial period with incentives for full membership conversion.
3. **Weekend Pass with Electric Bike Perks**:
   - Target casual riders with weekend-specific offers and discounted electric bike rates.

## File Structure
- `/data`: Cleaned trip data in CSV format.
- `/sql`: SQL scripts for data processing and analysis.
- `/powerbi`: Power BI dashboards and reports.
- `/docs`: Project documentation, including this README.

## License
This project uses data provided by Motivate International Inc. under the [Divvy Data License Agreement](https://divvybikes.com/data-license-agreement).
