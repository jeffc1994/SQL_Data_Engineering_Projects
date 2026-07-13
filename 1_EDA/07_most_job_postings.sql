/* Which company has the most job postings? 
*/

SELECT cd.name, COUNT(*) AS number_jobs
FROM job_postings_fact jpf
INNER JOIN company_dim cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
HAVING COUNT(*) > 10
ORDER BY COUNT(*)
LIMIT 10;