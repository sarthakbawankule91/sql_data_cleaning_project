📊 Layoffs Data Cleaning Project (SQL)

📌 Project Overview

This project focuses on data cleaning and preprocessing of a layoffs dataset using SQL. 
Raw datasets often contain inconsistencies such as duplicate records, missing values, and formatting issues.


The objective of this project is to transform raw layoffs data into a clean, consistent, and analysis-ready dataset.


🎯 Objectives
*Remove duplicate records

*Standardize inconsistent data

*Handle missing (NULL) values

*Prepare the dataset for analysis and visualization



🛠️ Tools & Concepts Used
*SQL (MySQL)

*Data Cleaning Techniques

*Window Functions

*Self Joins

*Data Standardization

*Handling NULL Values



📂 Dataset Description:
The dataset contains information related to layoffs across different companies. Key attributes include:

Company – Name of the organization

Location – City or region

Industry – Sector of the company

Total Laid Off – Number of employees laid off

Percentage Laid Off – Proportion of workforce affected

Date – Layoff date

Stage – Business stage (e.g., Startup, Growth)

Country – Country of operation

Funds Raised – Investment raised by the company



Data Cleaning Process📊

1️⃣ Data Understanding
Before cleaning, the dataset was explored to understand:
Structure of data
Data types of columns
Presence of duplicates
Missing or inconsistent values


2️⃣ Removing Duplicates
Duplicate records can distort analysis and lead to incorrect insights.
A window function was used to assign row numbers to identical records
Records with row number greater than 1 were identified as duplicates
These duplicate entries were removed, keeping only unique rows
👉 Concept Used:
Window Function (ROW_NUMBER()) helps in identifying duplicate rows efficiently.


3️⃣ Data Standardization
Raw data often contains inconsistencies such as:
Different naming formats
Extra spaces
Blank values
Steps performed:
Trimmed unnecessary spaces
Converted blank values into NULL
Ensured consistent formatting across columns
👉 Goal: Maintain uniformity for accurate querying and analysis.


4️⃣ Handling Missing Values
Missing data is a common issue in real-world datasets.
Steps performed:
Identified NULL or missing values
Used self join technique to fill missing values based on similar records
Ensured no important column remained incomplete
👉 Concept Used:
Self Join allows filling missing values by referencing existing data within the same table.


5️⃣ Data Consistency Checks
After cleaning:
Verified no duplicate records remain
Checked NULL values are handled properly
Ensured data integrity across all columns


📊 Key Learnings
Importance of data cleaning before analysis
Practical use of SQL window functions
Handling real-world messy datasets
Techniques for dealing with missing and inconsistent data
Writing efficient and structured SQL queries


📈 Outcome
*Clean and structured dataset

*Improved data quality

*Ready for analysis and visualization

📌 Conclusion
Data cleaning is a crucial step in any data analysis project. This project demonstrates how SQL
can be effectively used to clean and prepare raw data, ensuring accurate and meaningful insights in later stages.



