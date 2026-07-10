/* What are the most in demand skills for data engineers?
Identify the top 10 in-demand skills for data engineers
Focus on remote job postings
Why? 
- Retrieves the top 10 skills with the highest demand in the remote job market, providing insights into the most valuable skills for data engineers seeking remote work */



SELECT table_catalog, table_name
FROM information_schema.tables;

SELECT table_name, column_name
FROM information_schema.columns 
WHERE table_catalog = 'data_jobs';

-- Use the job_postings_fact table as primary table
-- Join skills_job_dim to skills to job_postings_fact

SELECT * 
FROM skills_job_dim
LIMIT 10;

SELECT * 
FROM skills_dim 
LIMIT 10;

SELECT *
FROM job_postings_fact jpf 
LIMIT 10;


SELECT job_location, COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY job_location
HAVING COUNT(*) > 1000
ORDER BY job_count DESC
LIMIT 40;

SELECT sd.skills, COUNT(*) AS no_jobs
FROM job_postings_fact jpe
INNER JOIN skills_job_dim sjd 
    ON jpe.job_id = sjd.job_id
    INNER JOIN skills_dim sd 
        ON sjd.skill_id = sd.skill_id
WHERE jpe.job_title_short = 'Data Engineer'
AND jpe.job_location = 'Australia'
GROUP BY sd.skills
ORDER BY no_jobs DESC
LIMIT 10;

/*

┌────────────┬─────────┐
│   skills   │ no_jobs │
│  varchar   │  int64  │
├────────────┼─────────┤
│ sql        │     443 │
│ python     │     381 │
│ azure      │     259 │
│ aws        │     253 │
│ spark      │     191 │
│ databricks │     120 │
│ java       │     116 │
│ scala      │     104 │
│ power bi   │      92 │
│ kafka      │      92 │
└────────────┴─────────┘

*/