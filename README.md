# E-Commerce Data Analysis

## Introduction
This project utilizies a e-commerce database for Maven Fuzzy Factory which can be found in [Kaggle](https://www.kaggle.com/datasets/rubenman/maven-fuzzy-factory-dataset).

The database contains six related tables with e-commerce data about:
- Website Activity
- Products
- Orders

The Entity Relationship Diagram(ERD) of the dataset is as following:
![er_diagram](https://user-images.githubusercontent.com/52621350/236691332-adfb1457-77fc-4145-a4c0-8c89bde970cf.png)

## Purpose
The purpose of this project is to analyze and get insights of user activity, sales and several other metrices from the e-commerce data. I will answer several questions from the data using SQL query.

## Questions & Answers:

### Web Session Analysis

* Calculate hourly, daily and monthly user sessions

```sql
# Hourly session count:
SELECT DATE(created_at) as days, HOUR(created_at) as hours,
	COUNT(DISTINCT website_session_id) as hourly_session_count
FROM website_sessions
GROUP BY DATE(created_at), HOUR(created_at)
ORDER BY days DESC, hours;
```
```sql
# Daily session count:
SELECT DATE(created_at) as days, 
	COUNT(DISTINCT website_session_id) as daily_session_count
FROM website_sessions
GROUP BY DATE(created_at)
ORDER BY days DESC;
```
```sql
# Monthly session count:
SELECT YEAR(created_at) as year, MONTH(created_at) as month, 
	COUNT(DISTINCT website_session_id) as monthly_session_count
FROM website_sessions
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;
```
```
