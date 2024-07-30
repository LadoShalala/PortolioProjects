--- ==================================================================================================

--- Author: Ladi Akinfala							
--- Date Created: 06/01/2024
--- File: Healthcare Data Analysis


-- The dataset I am currently working with contains detailed information about patients admitted into various hospitals, comprising 15 columns of data.
-- The primary aim of this project is to meticulously analyze the hospital admission records from a multitude of hospitals.

-- The key objectives of the project are:
-- 1. Thoroughly explore the dataset to reveal intricate patterns and relationships within the data.

-- Data Cleaning phase - (Preanalysis steps)-------------------------
-- It involves checking and documenting the number of rows and columns in the dataset. 
-- Identifying and resolving any duplicate entries and addressing missing or null values in the dataset.
-- Use the 'admission date' and discharge dates to calculate the days spent on admission.
-- Run query to check number of column and rows. 

-- Analysis to complete;
--- 1) Do a breakdown of patient demographics based on gender and age group (18-24, 25-34, 35-44, 45-64, 65 and above).
--- 2) Check to see if there are any repeat patients.
--- 3) Use COUNT to find out which admission type, Dr., Hospital, Insurer_provider, Medical Condition and Blood type and Medication.
--- 4) Analyse Medical condition by Gender, Admission type and Average Age.
--- 5) Conduct a descriptive analysis of the Billing Amount.
--- 6) Look at cost of treatment based on medical condition per patient
--- 7) Perform a min, avg and max on the Days_on_Admission
--- 8) The Medication the medical condition was treated with. 
--- 9) Blood type by condition,
--- 10) Blood type by gender
--- 11) Group the months by season and count the number of admissions by season
--- 12) Look at the average age, increase in patient gender, medical condition of admission year-on-year. 
--- 13) Hospital by gender, admission type and medical condition
--- 14) Gender by admission type

-- Data Visualization
--- 1) A page that breaks down the demographic of patients (age group, blood type, gender). This section of the 
--- dashboard offers a comprehensive breakdown of patient demographics.
--- 2) Use a stacked Bar Chart, Bubble chart or Grouped Bar chart show relationship between age_group, condition_count,
-- Gender and Medical_Condition
--- 3) Use a scorecard for total number of hospital visits.

---------------------------------------------------------------------------------------------------------------------------

--- Start of analysis
-- 1. Viewing the initial dataset

SELECT *
FROM [dbo].[healthcare_datasetCSV]
----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

-- 2. Adding a new column for Days_on_Admission
-- Next, i will be utilizing the Date_of_Admission and Discharge_Date to calculate and analyze the duration of each patient's admission. 
SELECT 
    Date_of_Admission,
	Discharge_Date, 
    DATEDIFF(day, Date_of_Admission, Discharge_Date) AS Days_on_Admission,
    FORMAT(Date_of_Admission, 'hh:mm tt') AS time
FROM 
    [dbo].[healthcare_datasetCSV];


--- UPDATE AND ADDING NEW COLUMN 
-- Step 1: Adding the new column from the previous syntax done adove. 
ALTER TABLE [dbo].[healthcare_datasetCSV]
ADD Days_on_Admission INT;
GO

-- Step 2: Update the new column based on the results of the two existing columns
UPDATE [dbo].[healthcare_datasetCSV]
SET Days_on_Admission = DATEDIFF(day, Date_of_Admission, Discharge_Date);
GO

------------------------------------------------------------------------------------------------------------------------------------
-- 4. Checking the columns in the dataset

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'healthcare_datasetCSV';

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

-- 5. Checking data types of columns

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'healthcare_datasetCSV'
    AND TABLE_SCHEMA = 'dbo';

--- There are sixteen (16) columns, including the newly added Days_on_Admission column. 

-- Both the 'Gender' and 'Blood_Type' columns are improperly formatted, therefore the data_type for both columns needs to be changed. 
-- We will be using VARCHAR(10) and VarChar(3) respectively for both columns. VARCHAR was selected since the data for the Gender column is 'Male' and 'Female'.

-- 6. Modifying data types for Gender and Blood_Type columns

ALTER TABLE [dbo].[healthcare_datasetCSV]
ALTER COLUMN Gender VARCHAR(10) NOT NULL;

ALTER TABLE [dbo].[healthcare_datasetCSV]
ALTER COLUMN Blood_Type VARCHAR(3) NOT NULL;

UPDATE [dbo].[healthcare_datasetCSV]
----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- All the data has been checked for errors and a new column has been added. Next we are checking the total number of rows and column in our table. 

-- Total number of columns 
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'healthcare_datasetCSV';

-- Total number of rows
SELECT COUNT(*) AS total_rows
FROM [dbo].[healthcare_datasetCSV];


-- There are 16 columns and 10,000 rows in the dataset. 

-----------------------------------------------------------------------------------------------------------------------------------

-- 7. Checking for duplicate records

-- CHECKING FOR DUPLICATES # Thoroughly checking for duplicates across all columns. This will help ensure that there are no identical records within our dataset. 
SELECT 
    Name, Age, Hospital, Doctor, Date_of_Admission,
    COUNT(*) AS num_of_entries
FROM 
  [dbo].[healthcare_datasetCSV]
GROUP BY 
   Age, Name, Hospital, Doctor, Date_of_Admission
HAVING 
    COUNT(*) > 0;

--- Zero (0) duplicates were found when checking for duplicates in the dataset. From the analysis, there were no duplicates found based on the combination of Name, Date of Admission, Doctor, and Hospital. 
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------

-- 8. Checking for NULL values
SELECT 
    COUNT(CASE WHEN Name IS NULL THEN 1 END) AS Name_Null_Count,
    COUNT(CASE WHEN Age IS NULL THEN 1 END) AS Age_Null_Count,
    COUNT(CASE WHEN Gender IS NULL THEN 1 END) AS Gender_Null_Count,
    COUNT(CASE WHEN Blood_Type IS NULL THEN 1 END) AS Blood_Type_Null_Count,
    COUNT(CASE WHEN Medical_Condition IS NULL THEN 1 END) AS Medical_Condition_Null_Count,
    COUNT(CASE WHEN Date_of_Admission IS NULL THEN 1 END) AS Date_of_Admission_Null_Count,
    COUNT(CASE WHEN Doctor IS NULL THEN 1 END) AS Doctor_Null_Count,
    COUNT(CASE WHEN Hospital IS NULL THEN 1 END) AS Hospital_Null_Count,
    COUNT(CASE WHEN Insurance_Provider IS NULL THEN 1 END) AS Insurance_Provider_Null_Count,
    COUNT(CASE WHEN Billing_Amount IS NULL THEN 1 END) AS Billing_Amount_Null_Count,
    COUNT(CASE WHEN Room_Number IS NULL THEN 1 END) AS Room_Number_Null_Count,
    COUNT(CASE WHEN Admission_Type IS NULL THEN 1 END) AS Admission_Type_Null_Count,
    COUNT(CASE WHEN Discharge_Date IS NULL THEN 1 END) AS Discharge_Date_Null_Count,
    COUNT(CASE WHEN Medication IS NULL THEN 1 END) AS Medication_Null_Count,
    COUNT(CASE WHEN Test_Results IS NULL THEN 1 END) AS Test_Results_Null_Count,
	COUNT(CASE WHEN Days_on_Admission IS NULL THEN 1 END) AS Days_on_Admission_Null_Count

FROM healthcare_datasetCSV;

-- There are zero case of NULL values in the entire table. 
-----------------------------------------------------------------------------------------------------------------------------------

--- PHASE 2: Conducting descriptive analysis on patient demographic

------------------------------------------------------------------------------------------------------------------------------------
-- 9. Patient count by gender

SELECT 
    Gender,
    COUNT(*) AS Patient_Count_by_Gender
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    Gender;
--- As seen from the results, there were 150 more female patients admitted into hospitals than male patients.

------------------------------------------------------------------------------------------
-- 10. Descriptive statistics for patient age

SELECT
	MIN (Age) AS Youngest_Age,
	AVG (Age) AS Average_Age,
	MAX (Age) AS Oldest_Age
FROM [dbo].[healthcare_datasetCSV]
--- The age of the patients are between 18 and 85, with an average age of 51 years old. 


-- 11. Patient count by age group

-- Below we would be analysing the dataset based on patient demographic age and gender. From our earlier query, we noticed that the youngest
-- patient in the dataset is 18, and our oldest patient(s) is 85. Therefore the starting age to group our patients into different groups is 18.*/  

SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
		WHEN Age BETWEEN 45 AND 64 THEN '45-64'
		WHEN Age >= 65 THEN '65 and above'
    END AS Age_Group,
    COUNT(*) AS Count
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
		WHEN Age BETWEEN 45 AND 64 THEN '45-64'
		WHEN Age >= 65 THEN '65 and above'
	END
ORDER BY (Age_Group);

--- The Majority of patients admitted into hospital were above the age of 65+. The group with the lowest rate of admission are the 18-24. 
--- Since there was no data about patients date of birth in the dataset, we cannot find out the age of the youngest patient. 


-- 12. Patient count by gender and age group

SELECT 
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 64 THEN '45-64'
        WHEN Age >= 65 THEN '65 and above'
    END AS Age_Group,
    COUNT(*) AS Count
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 64 THEN '45-64'
        WHEN Age >= 65 THEN '65 and above'
    END
ORDER BY
 
    Age_Group;

-- The results show that women outnumber men in each of the age groups. 
-- The older both female and male patients got, the higher female patients were admitted into hospital.  

--------------------------------------------------------------------------------------------------------------------------------------------
-- ANALYSIS OF VARIOUS CATEGORIES
---------------------------------------------------------------------------------------------------------------------------------
-- Below we will analyze Eight (8) columns; Admission, Blood_Type, Gender, Hospital, Insurance_Provider, Medical_Condition, Medication and Test_Results

-- 13. Count of patients based on their admission type

SELECT
	Admission_Type, COUNT(*) AS [Number of records]
	
	FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Admission_Type
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.; 

-- There were 3 different methods through patients were admitted into the hospitals. Most patients (3,391) were Urgently admitted and the least amount of admission being Elective admissions.  
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- 14.				What is the most common blood type among patients?

SELECT
	Blood_Type, COUNT(*) AS [Number of records]
FROM
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Blood_Type 
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.;

-- There were a total of 8 different blood types among the patients. Specifically, there were 1,275 individuals who had the blood type AB-, which was the highest 
-- count among the different blood types. On the other hand, there were 1,238 patients with the blood type A-, making it the lowest count among the blood types observed.

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- 15. Counting the number of unique doctors in the dataset?

SELECT
	Doctor, COUNT(*) AS [Number of records]
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Doctor 
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.;

SELECT COUNT(DISTINCT Doctor) AS distinct_doctors
FROM [dbo].[healthcare_datasetCSV];

-- There were 9,416 different doctors recorded in the dataset. Micheal Johnson is the most common 'doctor' in the table with seven occurrences, however
-- on further inspection, there is a high probability that these are different doctors with the same name, as each of the seven doctors who worked 
-- at different hospitals. 
-------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

-- 16.						How many unique hospitals are in the dataset?

SELECT
	Hospital, COUNT(*) AS [Number of records]
	FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Hospital
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.; 

-- There were 8,639 different hospitals in the dataset, Smith PLC was the hospital with the most (19) admissions.


-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- 17. Counting the number of patients under the different insurance providers

SELECT
	Insurance_Provider, COUNT(*) AS [Number of records]
	FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Insurance_Provider
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.;

-- Of the five (5) different Insurance Providers, Cigna insured 2,040 patients, the most in the dataset, and Medicare insured the lowest number of patients, with 1,925 patients insured. 

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 18. Counting number of times medications were used in treating patients conditions
SELECT
	Medication, COUNT(*) AS [Number of records], 
	CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM [dbo].[healthcare_datasetCSV]) * 100 AS Percentage

	FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Medication
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.;

-- Out of the five different medications prescribed or administered to patients, Penicillin was the most frequently used medication,
-- with 2,079 prescriptions, covering 20.79% of the treatments. On the other hand, paracetamol had the lowest usage, with 1,962 prescriptions,
-- accounting for 19.6% of the treatments.

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 19. Count of patients by medical condition

SELECT
	Medical_Condition, COUNT(*) AS [Number of records]
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Medical_Condition
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.;

-- Of the five (5) different Medical_Conditions, Asthma was the most prevalent conditions amongst patients. The Medical_Condition with the lowest age number of admissions is Diabetes with 1,623. 

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- 20. Count of patients by test results

SELECT
	Test_Results, COUNT(*) AS [Number of records]
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
     Test_Results
ORDER BY [Number of records] DESC -- The results are sorted the Number of records column is sorted by highest to lowest.; 

-- There were 3 different types of Test_Results. The majority (3,456) of them were found to be Abnormal and the fewest 3,267 being Normal test results. 

-----------------------------------------------------------------------------------------
-- DATE ANALYSIS
-----------------------------------------------------------------------------------------
-- 21. Earliest and most recent admission and discharge dates

SELECT 
    (SELECT MIN([Date_of_Admission]) FROM [dbo].[healthcare_datasetCSV]) AS Earliest_Admission_Date,
    (SELECT MAX([Date_of_Admission]) FROM [dbo].[healthcare_datasetCSV]) AS Most_Recent_Admission_Date,
    (SELECT MIN([Discharge_Date]) FROM [dbo].[healthcare_datasetCSV]) AS Earliest_Discharge_Date,
    (SELECT MAX([Discharge_Date]) FROM [dbo].[healthcare_datasetCSV]) AS Most_Recent_Discharge_Date
FROM [dbo].[healthcare_datasetCSV];

-- The dates from the dataset last 5 years and 10 months, the first date of admission was on 2018-10-30 and the last discharge date was 2013-11-27. 

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 22. Date with the highest number of admissions
SELECT TOP 100
    [Date_of_Admission], 
    COUNT(*) AS Admission_Count
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    [Date_of_Admission]
ORDER BY 
    Admission_Count DESC;

-- Across the 5 year and 10 months period, there were 1,815 different admission days with '2019-04-12' and '2022-04-27' both having the highest number of patients admitted (15). 


--              Condition Analysis by Gender and Age:
-- 23. Medical condition by gender and age group

SELECT 
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 64 THEN '45-64'
        WHEN Age >= 65 THEN '65 and above'
    END AS Age_Group,
    [Medical_Condition],
    COUNT(*) AS Condition_Count
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 64 THEN '45-64'
        WHEN Age >= 65 THEN '65 and above'
    END,
[Medical_Condition]
ORDER BY
    Medical_Condition,
	Condition_Count,
    Age_Group;

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

--										BILLING AMOUNT

-- --- Conducting descriptive analysis on Billing_Amount

SELECT 
    FORMAT(MIN(Billing_Amount), 'C', 'en-US') AS Min_Billing_Amount,
    FORMAT(AVG(Billing_Amount), 'C', 'en-US') AS Avg_Billing_Amount,
    FORMAT(MAX(Billing_Amount), 'C', 'en-US') AS Max_Billing_Amount,
    FORMAT(SUM(Billing_Amount), 'C', 'en-US') AS Total_Billing_Amount
FROM 
    [dbo].[healthcare_datasetCSV];

--- The billing amount of the patient treatments was between $1,000.18 and $49,995.90, with an average billing_Amount was $25,517.82. A total $255,152,650.64. 


--
SELECT
    medical_condition,
    SUM(billing_amount) AS total_billing_amount
FROM
    [dbo].[healthcare_datasetCSV]
GROUP BY
    medical_condition
ORDER BY
	total_billing_amount;

-- The Medical_Condition with the most expensive medical form of treatment for all 10,000 patients was Cancer, whilst the 
-- cheapest Condition to treat was Arthritis. 
-----------------------------------------------------------------------------------------------------------------------

-- Based on previous analysis, the lowest billing amount for patient treatment was $1,000.18, therefore the 
-- the breakdown of the billing_amount into seperate groups would range from 1000 and the max billing amount of $49,999. 

SELECT
    CASE
        WHEN billing_amount BETWEEN 1000 AND 4999.99 THEN '$1,000 - $4,999.99'
        WHEN billing_amount BETWEEN 5000 AND 9999.99 THEN '$5,000 - $9,999.99'
		WHEN billing_amount BETWEEN 10000 AND 19999.99 THEN '$10,000 - $19,999.99'
        WHEN billing_amount BETWEEN 20000 AND 49999.99 THEN '$20,000 - $49,999.99'
        ELSE 'Greater than $50,000'
    END AS billing_category,
    COUNT(*) AS number_of_records
FROM
    [dbo].[healthcare_datasetCSV]
GROUP BY
    CASE
        WHEN billing_amount BETWEEN 1000 AND 4999.99 THEN '$1,000 - $4,999.99'
        WHEN billing_amount BETWEEN 5000 AND 9999.99 THEN '$5,000 - $9,999.99'
		WHEN billing_amount BETWEEN 10000 AND 19999.99 THEN '$10,000 - $19,999.99'
        WHEN billing_amount BETWEEN 20000 AND 49999.99 THEN '$20,000 - $49,999.99'
        ELSE 'Greater than $50,000'
    END
ORDER BY
    number_of_records;

-- The majority of patient were billed between $20,000 and $49,999. There seems to be some disclarity in the 
-- analysis, as it shows that there is patient with a Billing_Amount greater than 50000. 

SELECT *
FROM [dbo].[healthcare_datasetCSV]
WHERE Billing_Amount <= 1000.18084716797
ORDER BY Billing_Amount;

-- The patient with the highest Billing_Amount is '49995.90234375' for Daniel Hall, a 77 male who was admitted through Emergency and spent
-- 7 days on admission to be treated for Hypertension at Arellano-Mahoney by Doctor Timothy Serrano. On the other hand,
-- the Anna Adams 70 year female patient on admission for 12 days and treated for obesity had the lowest Billing_Amount '1000.18084716797'. 


-------------------------------------------------------------------------------------------------------------

--
SELECT 
    Gender,
	Medical_Condition,
    COUNT(*) AS Medical_Condition_by_Gender
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    Gender,
	Medical_Condition

ORDER BY 
	Gender,
	Medical_Condition;

-- Female patients outnumbered male patients in four of the six medical conditions. The majority of Female patients (874)
-- were admitted for Asthma, whilst the majority of male patients (852) were admitted for Hypertension. 


SELECT 
    AVG(Age),
	Gender,
	Medical_Condition,
    COUNT(*) AS Medical_Condition_by_Average_Age
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
	Medical_Condition,
	Gender
ORDER BY 
	Medical_Condition;

-- Of the six (6) medical conditions in the dataset, the average age of patients was 51, except for patients
-- with Hypertension, whose average age was 50. When analyzing correlations between average age, gender, and
-- medical conditions, it was found that the average age for females with Asthma and Diabetes increased to 52.

-------------------------------------------------------------------------------------------------------------

-- Next, I will be looking at the correlation between Medical Condition and Medication. 

SELECT 
    Medication,
	Medical_Condition,
    COUNT(*) AS Medical_Condition_by_Medication,
	CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM [dbo].[healthcare_datasetCSV]) * 100 AS Percentage
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
	Medical_Condition,
	Medication
ORDER BY 
	Medication;


-- The use of aspirin in treating asthma was reported in 370 cases, accounting for 3.7% of the total cases.
-- This made it the most frequently used medication for addressing various medical conditions. 
-- Conversely, aspirin was only employed in the treatment of 291 cases of cancer, representing 2.19% of the total cases
-- and indicating the lowest usage among all medications.

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

--- Patient count by Bloodtype and Patient's Medical Condition 


SELECT 
    Blood_Type,
	Medical_Condition,
    COUNT(*) AS Bloodtype_by_Condition
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
	Medical_Condition,
	Blood_Type
ORDER BY 
	Blood_Type;

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

--- Patient count by Bloodtype and Gender

SELECT 
    Blood_Type,
	Gender,
    COUNT(*) AS Bloodtype_by_Gender
FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
	Gender,
	Blood_Type
ORDER BY 
	Blood_Type;

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

--- Next we are looking at the mode of admission based on a patient's medical condition.
SELECT 
	Medical_Condition,
    Admission_Type,
    COUNT(*) AS Admission_based_on_condition

FROM 
    [dbo].[healthcare_datasetCSV]

GROUP BY 
	Medical_Condition,
	Admission_Type
	
	
ORDER BY
	Medical_Condition



-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

--- Next we are looking at the mode of admission based on the gender of the patient.

SELECT 
    Admission_Type,
	Gender,
    COUNT(*) AS Admission_by_Gender,
	CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM [dbo].[healthcare_datasetCSV]) * 100 AS Percentage

FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
	Gender,
	Admission_Type
ORDER BY 
	Admission_Type;

-- Female patients were more likely to admitted into hospital by all meth
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------

--       Understanding which the four seasons of the year had the most admissions.

SELECT 
	    YEAR (Date_of_Admission) AS year,
  CASE
        WHEN MONTH (Date_of_Admission) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH (Date_of_Admission) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH (Date_of_Admission) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH (Date_of_Admission) IN (9, 10, 11) THEN 'Autumn'
    END AS season,
    COUNT(*) AS Admission_based_on_season
FROM
    [dbo].[healthcare_datasetCSV]
GROUP BY
		YEAR(Date_of_Admission),
    CASE
        WHEN MONTH(Date_of_Admission) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(Date_of_Admission) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(Date_of_Admission) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(Date_of_Admission) IN (9, 10, 11) THEN 'Autumn'
    END
ORDER BY 
	YEAR(Date_of_Admission);

--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

SELECT 
    MIN(Days_on_Admission) AS Min_Days_on_Admission, 
    AVG(Days_on_Admission) AS Avg_Days_on_Admission, 
    MAX(Days_on_Admission) AS Max_Days_on_Admission
FROM 
    [dbo].[healthcare_datasetCSV];

-- The average length of the patients admission was 15 days, and the most consecutive days a patient was
-- admitted for was 30 days.

-- 24. Average length of stay (days on admission) by medical condition

SELECT
	Days_on_Admission, COUNT(*) AS [Number of records]
	FROM 
    [dbo].[healthcare_datasetCSV]
GROUP BY 
    Days_on_Admission  
ORDER BY [Number of records];

-- The Majority of patients (367) spent 26 days on admission. while 303 patients spent just 2 days on admission. 




