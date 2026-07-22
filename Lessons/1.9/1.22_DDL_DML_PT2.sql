CREATE OR REPLACE TABLE staging.job_postings_flat AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
SELECT
    jpf.*
FROM staging.job_postings_flat AS jpf
INNER JOIN staging.priority_roles AS r 
    ON jpf.job_title_short = r.role_name
WHERE r.priority_level = 1;


-- Temp tables do not require a schema to specify
CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';


SELECT * FROM senior_jobs_flat_temp;

SELECT COUNT(*) 
FROM staging.job_postings_flat;
SELECT COUNT(*) 
FROM senior_jobs_flat_temp;
SELECT COUNT(*) 
FROM staging.priority_jobs_flat_view;


-- Delete to remove roles conditionally
DELETE FROM staging.job_postings_flat 
WHERE job_posted_date < '2024-01-01';

-- Truncate might be faster as it removes all rows
TRUNCATE TABLE staging.job_postings_flat;


INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date >= '2024-01-01';

SELECT COUNT(*) 
FROM staging.job_postings_flat;
SELECT COUNT(*) 
FROM senior_jobs_flat_temp;
SELECT COUNT(*) 
FROM staging.priority_jobs_flat_view;


SELECT 
table_catalog, 
table_schema, 
table_name
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';