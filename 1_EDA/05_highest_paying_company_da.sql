SELECT 
    cd.name, 
    COUNT(*) as no_jobs,
    MEDIAN(jpf.salary_year_avg) as median_salary
FROM 
    job_postings_fact jpf
INNER JOIN 
    company_dim cd 
    ON jpf.company_id = cd.company_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
GROUP BY 
    cd.name
HAVING 
    no_jobs >1000
ORDER BY 
    median_salary DESC
LIMIT 10;