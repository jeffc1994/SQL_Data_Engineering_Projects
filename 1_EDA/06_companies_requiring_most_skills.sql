/* 
Question:
Among companies with at least 10 job postings, find the company whose jobs
require the highest average number of skills per posting.
*/
SELECT table_name, column_name
FROM information_schema.columns 
WHERE table_catalog = 'data_jobs';

WITH skills_per_job AS (
    SELECT
        jpf.job_id,
        cd.name AS company_name,
        COUNT(DISTINCT sjd.skill_id) AS skill_count
    FROM job_postings_fact jpf
    JOIN company_dim cd
        ON jpf.company_id = cd.company_id
    LEFT JOIN skills_job_dim sjd
        ON jpf.job_id = sjd.job_id
    GROUP BY
        jpf.job_id,
        cd.name
)

SELECT
    company_name,
    COUNT(job_id) AS job_postings,
    ROUND(AVG(skill_count), 2) AS avg_skills_per_posting
FROM skills_per_job
GROUP BY company_name
HAVING COUNT(job_id) >= 10
ORDER BY avg_skills_per_posting DESC
LIMIT 1;
