**Headings** 
# Heading 1
## Heading 2
### Heading 3

**Text Types**
Normal Text  
**Bold Text**  
*Italics Text*  
`code`

**Lists**
- Bullet 1
- Bullet 2
1. Number 1  
2. Number 2   


**Images**
![Alt Text](/Images/1_1_Project1_EDA.png)

**Code blocks**
```sql
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
```
**Markdown Cheatsheet**  
[Link here](https://markdownguide.offshoot.io/cheat-sheet/)