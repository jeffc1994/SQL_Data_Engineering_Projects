SELECT table_name,column_name 
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';

SELECT 
    cd.name as company_name,
    COUNT(jpf.*) as posting_count
FROM job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING posting_count>3000
ORDER BY posting_count DESC
LIMIT 10;

