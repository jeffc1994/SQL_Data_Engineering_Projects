/* 
Companies hiring for the widest variety of roles
*/
SELECT table_name, column_name
FROM information_schema.columns 
WHERE table_catalog = 'data_jobs';

SELECT cd.name, COUNT(DISTINCT(jpf.job_title)) as num_distinct_rows
FROM job_postings_fact jpf
INNER JOIN company_dim cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
ORDER BY num_distinct_rows DESC
LIMIT 10;