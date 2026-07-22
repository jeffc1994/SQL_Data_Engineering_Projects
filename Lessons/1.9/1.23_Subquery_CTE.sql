-- Subquery (Query nested in a larger query)
-- Filter down job_posting where values are not null
SELECT * 
FROM (
    SELECT * 
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL 
        OR salary_hour_avg IS NOT NULL 
)
LIMIT 10;

-- CTE
WITH valid_salaries AS (
        SELECT * 
        FROM job_postings_fact
        WHERE salary_year_avg IS NOT NULL 
            OR salary_hour_avg IS NOT NULL 
)
SELECT * 
FROM valid_salaries;


-- Scenario 1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    (SELECT MEDIAN(median_salary)
    FROM job_postings_fact
    ) AS median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


-- Sceanrio 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating to determine the remote median salary per job
SELECT
    job_title_short,
    MEDIAN(median_salary) AS median_salary,
    (SELECT MEDIAN(median_salary)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS median_salary
FROM (SELECT job_title_short, salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;


-- Scenario 3 - Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median:
SELECT
    job_title_short,
    MEDIAN(median_salary) AS median_salary,
    (SELECT MEDIAN(median_salary)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS median_salary
FROM (SELECT job_title_short, salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(median_salary) > (
    SELECT MEDIAN(median_salary)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;

-- CTE Example
-- Compare how much more or less remote roles pay compared to onsite roles for each job title
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians

WITH title_median AS (
    SELECT 
        job_title_short,
        job_work_from_home,
        MEDIAN(median_salary) ::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'Australia'
    GROUP BY job_title_short, job_work_from_home
)
SELECT 
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r 
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;



/* 
1. Compare average salaries

Question:

Management wants to know whether remote jobs pay more than onsite jobs for each job title in Australia.

Create a CTE that calculates the average salary for each combination of:

job_title_short
job_work_from_home

Then compare the average remote salary to the average onsite salary for each job title.

Return:

job title
average remote salary
average onsite salary
salary difference
*/
WITH salary_by_title AS (
    SELECT
        job_title_short,
        job_work_from_home,
        AVG(salary_year_avg)::INT AS avg_salary
    FROM job_postings_fact
    WHERE job_country = 'Australia'
    GROUP BY job_title_short, job_work_from_home
)

SELECT
    r.job_title_short,
    r.avg_salary AS remote_avg_salary,
    o.avg_salary AS onsite_avg_salary,
    r.avg_salary - o.avg_salary AS salary_difference
FROM salary_by_title AS r
INNER JOIN salary_by_title AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
  AND o.job_work_from_home = FALSE
ORDER BY salary_difference DESC;


/*
Question 2: Remote vs onsite job volume

The HR team wants to know which job titles in Australia have more remote job postings than onsite job postings.

Return:

job_title_short
number of remote jobs
number of onsite jobs
difference between remote and onsite job counts

Only include Australian jobs.

Sort so the job titles with the biggest remote advantage appear first.
*/

WITH title_no_remote_and_onsite_jobs AS (
    SELECT 
        job_title_short,
        job_work_from_home,
        COUNT(*) AS number_of_jobs
    FROM job_postings_fact
    WHERE job_country = 'Australia'
    GROUP BY job_title_short, job_work_from_home
)
SELECT 
    r.job_title_short,
    r.number_of_jobs AS number_of_remote_jobs,
    o.number_of_jobs AS number_of_onsite_jobs,
    (r.number_of_jobs - o.number_of_jobs) AS job_diff
FROM title_no_remote_and_onsite_jobs AS o 
INNER JOIN title_no_remote_and_onsite_jobs AS r 
    ON o.job_title_short = r.job_title_short 
WHERE r.job_work_from_home = TRUE AND o.job_work_from_home = FALSE ;


/*
Question 3: Highest-paying companies

The talent acquisition team wants to identify which companies pay the highest salaries for Data Analysts in Australia.

Return:

company name
median salary
number of Data Analyst job postings

Only include companies that have posted at least 5 Data Analyst jobs.

Sort from the highest median salary to the lowest.
*/

SELECT 
    cd.name,
    jpf.job_title_short,
    MEDIAN(jpf.salary_year_avg) AS median_salary,
    COUNT(*) AS no_jobs
FROM job_postings_fact jpf 
INNER JOIN company_dim cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_title_short = 'Data Analyst'
AND jpf.salary_year_avg IS NOT NULL
GROUP BY cd.name, jpf.job_title_short
HAVING COUNT(*) > 5;


/* 
Question 4: Above-average salaries by job title

Management wants to find job postings in Australia where the salary is higher than the typical salary for that job title.

Return:

job_id
job_title_short
company_id
salary_year_avg
average salary for that job title
difference between the job salary and the title average

Only include:

Australian jobs
rows where salary_year_avg is not null
jobs where the salary is above the average for that title

Sort by the biggest salary difference first.
*/

WITH job_salaries AS (
    SELECT
        job_title_short,
        AVG(salary_year_avg) AS market_average_salary
    FROM job_postings_fact
    WHERE job_country = 'Australia'
    GROUP BY job_title_short
)

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.company_id,
    jpf.salary_year_avg,
    js.market_average_salary,
    (jpf.salary_year_avg - js.market_average_salary)::INT AS salary_diff
FROM job_postings_fact AS jpf
INNER JOIN job_salaries AS js
    ON js.job_title_short = jpf.job_title_short
WHERE jpf.job_country = 'Australia' AND (jpf.salary_year_avg - js.market_average_salary) > 0
ORDER BY salary_diff DESC
LIMIT 10;


/* 
Question 5: Companies paying above market average

HR wants to identify which companies pay above the market average for each job title in Australia.

Return:

company_id
job_title_short
company average salary for that job title
market average salary for that job title
difference between company average and market average

Only include:

Australian jobs
rows where salary_year_avg is not null
companies where their average salary is higher than the market average for that title

Sort by the biggest salary difference first.
*/

WITH market_salaries AS (
    SELECT 
        job_title_short,
        AVG(salary_year_avg) AS market_avg_salary
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
      AND job_country = 'Australia'
    GROUP BY job_title_short
) 
SELECT 
    jpf.company_id,
    jpf.job_title_short,
    AVG(jpf.salary_year_avg) AS comp_avg_salary,
    ms.market_avg_salary,
    AVG(jpf.salary_year_avg) - ms.market_avg_salary AS salary_diff
FROM job_postings_fact AS jpf
INNER JOIN market_salaries AS ms
    ON jpf.job_title_short = ms.job_title_short
WHERE jpf.salary_year_avg IS NOT NULL 
  AND jpf.job_country = 'Australia'
GROUP BY 
    jpf.company_id,
    jpf.job_title_short,
    ms.market_avg_salary
HAVING AVG(jpf.salary_year_avg) > ms.market_avg_salary
ORDER BY salary_diff DESC
LIMIT 15;


/* 
Question 6: Highest-paying skill for each job title

The learning team wants to know which skills are associated with the highest average salary for each job title in Australia.

Return:

job_title_short
skills
average salary
number of job postings requiring that skill

Only include:

Australian jobs
rows where salary_year_avg is not null
skills appearing in at least 20 job postings

For each job title, return only the highest-paying skill.
*/
SELECT table_name, column_name 
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';


WITH skill_salary AS (
    SELECT 
        jpf.job_title_short,
        skill

    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id 
    INNER JOIN skills_dim AS sd 
        ON sd.skill_id = sjd.skill_id
)



/* 
Existence filtering
1. Keep rows that have a match in a target table (source table has a match with target table)
2. Keeps rows that do not have a match in a target table (source table does not have a match with target table)
*/
SELECT * 
FROM range(3) AS src(key);



SELECT * 
FROM range(2) AS tgt(key);

SELECT * 
FROM range(3) as src(key)
WHERE EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

SELECT * 
FROM range(3) as src(key)
WHERE NOT EXISTS (
    SELECT 1 --can use any character here, not just 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);


SELECT * 
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT * 
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;

-- Jobs that don't require skills. We look for job_id's in jpf that don't exist in sjd
SELECT * 
FROM job_postings_fact AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;



/* 
Find companies that have posted at least one job
*/

SELECT name
FROM company_dim AS tgt
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact AS src
    WHERE tgt.company_id = src.company_id 
)
LIMIT 10;

/* 
Find companies that have posted at least one remote (job_work_from_home = TRUE) job.
*/

SELECT name
FROM company_dim AS tgt
WHERE EXISTS (
    SELECT 1 
    FROM job_postings_fact AS src
    WHERE tgt.company_id = src.company_id
    AND src.job_work_from_home = TRUE
);

/* 
Find companies that have never posted a remote job.
*/

SELECT name
FROM company_dim as tgt 
WHERE NOT EXISTS (
    SELECT 1
    FROM job_postings_fact AS src
    WHERE tgt.company_id = src.company_id
    AND src.job_work_from_home = TRUE
);

/* 
Find jobs that have at least one skill listed.
*/

SELECT job_id
FROM job_postings_fact AS tgt
WHERE EXISTS (
    SELECT 1 
    FROM skills_job_dim AS src
    WHERE src.job_id = tgt.job_id
)
ORDER BY job_id
LIMIT 10;

/* 
Find skills that are used by at least one job.
*/
SELECT DISTINCT skills
FROM skills_job_dim AS tgt 
INNER JOIN skills_dim AS sd
    ON tgt.skill_id = sd.skill_id
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact src 
    WHERE tgt.job_id = src.job_id
)
LIMIT 10;


