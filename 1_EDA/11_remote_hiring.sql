/*
Which companies have posted at least 500 remote jobs?
*/

SELECT cd.name, COUNT(*) AS num_postings
FROM job_postings_fact jpf
INNER JOIN company_dim cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_work_from_home = TRUE
GROUP BY cd.name
HAVING COUNT(*) > 500
ORDER BY num_postings DESC;