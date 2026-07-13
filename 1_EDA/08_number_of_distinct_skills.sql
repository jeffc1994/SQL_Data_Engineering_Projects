/* 
Which company requires the greatest total number of distinct skills across all of its job postings?
*/

SELECT cd.name, COUNT(DISTINCT(sjd.skill_id)) as number_skills
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN company_dim cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
ORDER BY number_skills DESC
LIMIT 10;