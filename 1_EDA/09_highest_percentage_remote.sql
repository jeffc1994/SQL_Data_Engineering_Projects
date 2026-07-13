/* 
Which company has the highest percentage of remote job postings (minimum 20 postings)?
*/

SELECT
    cd.name,
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (WHERE jpf.job_work_from_home = TRUE) AS remote_jobs,
    ROUND(
        COUNT(*) FILTER (WHERE jpf.job_work_from_home = TRUE)
        * 100.0 / COUNT(*),
        2
    ) AS remote_pct
FROM job_postings_fact jpf
JOIN company_dim cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
HAVING COUNT(*) >= 20
ORDER BY remote_pct DESC
LIMIT 1;
