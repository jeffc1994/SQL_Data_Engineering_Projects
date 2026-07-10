/* 
What are the most optimal skills for data engineers - balancing both demand and saary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills
- Focus only on remove Data Engineer positions with specified annual salaries
Why?
- This approach highlights skills that balance market demand and financial rewoard. 
It weights core skills appropriately, rather than letting rare, outlier skills distort the results
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    --COUNT(jpf.salary_year_avg) AS demand_count,
    ROUND(LN(COUNT(jpf.salary_year_avg)),1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.salary_year_avg))/1000000),2) AS optimal_score
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
  AND jpf.job_work_from_home = TRUE
  AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(*) > 100
ORDER BY optimal_score DESC
LIMIT 25;
