/* 
What are the most popular data jobs and what are their respective salaries
This will give hiring managers and aspiring employees a high level understanding of most sort 
after jobs, and the value placed upon these specific roles
*/


SELECT job_title_short, COUNT(*) as job_demand, MEDIAN(salary_year_avg) as median_salary
FROM job_postings_fact jpf 
GROUP BY jpf.job_title_short
HAVING job_demand > 1000
ORDER BY median_salary DESC;

