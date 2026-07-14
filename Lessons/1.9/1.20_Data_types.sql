SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

SELECT 
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR),
    CAST(job_work_from_home AS INT) AS job_work_from_home,
    CAST(job_posted_date AS DATE) AS job_posted_date,
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


SELECT 
    job_id, 
    CAST(job_work_from_home AS INT) AS job_work_from_home
FROM job_postings_fact
LIMIT 10;


SELECT 
    job_id,
    CAST(salary_year_avg AS INT) AS salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT 
    job_id,
    CAST(job_posted_date AS DATE) AS job_posted_date
FROM job_postings_fact
WHERE job_posted_date IS NOT NULL
LIMIT 1;

SELECT 
    CAST(job_id AS VARCHAR) AS job_id,
    CAST(company_id AS VARCHAR) AS company_id
FROM job_postings_fact
LIMIT 10;

SELECT 
    job_id,
    salary_year_avg,
    CAST(salary_year_avg AS DECIMAL(10,2)) AS salary_year_avg
FROM job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 10;

SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR)
FROM job_postings_fact
LIMIT 10;


/*
Question

Create a column called job_summary with the following format:

Data Analyst | Remote | $120000 | 2023-07-15
Requirements
job_title_short
"Remote" if job_work_from_home = TRUE, otherwise "On Site"
salary_year_avg as a whole number with a $ in front
job_posted_date converted to a DATE
Separate each field with " | "

*/

SELECT
    job_title_short ||
    ' | ' ||
    CASE
        WHEN job_work_from_home THEN 'Remote'
        ELSE 'On Site'
    END ||
    ' | $' ||
    CAST(CAST(salary_year_avg AS INTEGER) AS VARCHAR) ||
    ' | ' ||
    CAST(job_posted_date AS DATE) AS job_summary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;