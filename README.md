# Exploratory Data Analysis w/SQL: Job Market Analysis
![Project 1 Overview](../Images/1_1_Project1_EDA.png)

An SQL project analyzing the data engineer job market using real world job posting data. It demonstrates my ability to **write production quality analytical SQL, design efficient queries, and turn business questions into data-driven insights**.

## Executive Summary 
- ✅ **Project Scope:** Build **3 analytical queries** which answer key questions about the data engineering job market
- ✅ **Data Modelling:** Used **multi-table joins** across fact and dimension tables to extract the required data for business insights
- ✅ **Analytics:** Used **aggregations, filtering, grouping and sorting** to find top value skills by demand, salary, and overall value
- ✅ **Outcomes:** Delivered **actionable insights** on SQL/Python dominance in the job market, as well as cloud trends, salary patterns  



If you only have a minute, please review these:
1. [`01_top_demanded_skills.sql`](./01_top_demanded_skills.sql) – demand analysis with multi-table joins  
2. [`02_top_paying_skills.sql`](./02_top_paying_skills.sql) – salary analysis with aggregations  
3. [`03_optimal_skills.sql`](./03_optimal_skills.sql) – combined demand/salary optimization query  


## Problem & Context 
In a rapidly evolving tech industry, there are a myriad of coding languages, tools and software available in the data engineering market. This creates a problem where both aspiring data engineers and hiring managers struggle to quantify and attribute value to certain skills that should be learnt as well as should be sort after. This project aims to tackle that problem by doing a full market analysis across all data engineering job postings across different geographies, providing an objective grounding for each individual skill.

## Tech Stack
- 🦆 **Query Engine:** DuckDB for fast OLAP-style analytical queries
- 📘 **Coding Language:** SQL (ANSI-style with analytical functions)
- ⭐ **Data Modelling:** STAR schema with fact, dimension and bridge tables
- 🚧 **Development:** VSCode for SQL editing and Terminal for DuckDB CLI 
- 🟫 **Version Control:** Git/GitHub for versioned SQL scripts

---

## 📂 Repository Structure

```text
1_EDA/
├── 01_top_demanded_skills.sql    # Demand analysis query
├── 02_top_paying_skills.sql      # Salary analysis query
├── 03_optimal_skills.sql         # Combined demand/salary optimization
└── README.md                     # You are here
```
---
## Analysis Overview
### Query Structure

1. **[Top Demanded Skills](./01_top_demanded_skills.sql)** – Identifies the 10 most in-demand skills for remote data engineer positions
2. **[Top Paying Skills](./02_top_paying_skills.sql)** – Analyzes the 25 highest-paying skills with salary and demand metrics
3. **[Optimal Skills](./03_optimal_skills.sql)** – Calculates an optimal score using natural log of demand combined with median salary to identify the most valuable skills to learn

### Key Insights

- 🧠 Core languages: SQL and Python each appear in ~29,000 job postings, making them the most demanded skills
- ☁️ Cloud platforms: AWS and Azure are critical for modern data engineering roles- 
- 🧱 Infra & tooling: Kubernetes, Docker, and Terraform are associated with premium salaries
- 🔥 Big data tools: Apache Spark shows strong demand with competitive compensation

---

## 💻 SQL Skills Demonstrated

### Query Design & Optimization

- **Complex Joins**: Multi-table `INNER JOIN` operations across `job_postings_fact`, `skills_job_dim`, and `skills_dim`
- **Aggregations**: `COUNT()`, `MEDIAN()`, `ROUND()` for statistical analysis
- **Filtering**: Boolean logic with `WHERE` clauses and multiple conditions (`job_title_short`, `job_work_from_home`, `salary_year_avg IS NOT NULL`)
- **Sorting & Limiting**: `ORDER BY` with `DESC` and `LIMIT` for top-N analysis

### Data Analysis Techniques

- **Grouping**: `GROUP BY` for categorical analysis by skill
- **Mathematical Functions**: `LN()` for natural logarithm transformation to normalize demand metrics
- **Calculated Metrics**: Derived optimal score combining log-transformed demand with median salary
- **HAVING Clause**: Filtering aggregated results (skills with >= 100 postings)
- **NULL Handling**: Proper filtering of incomplete records (`salary_year_avg IS NOT NULL`)