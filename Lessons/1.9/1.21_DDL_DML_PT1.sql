/* 
Up until this point we have been doing Data Querying Language or DQL.
DDL is Data Definition Language where the scripts define or modify database objects
DML is Data Manipulation Language such as inserting, updating, deleting data
DCL is Data Control Language which manages permissions and security
TCL is Transaction Control Language, which control transactions of data between two rows of data

We must also write SQL that is idempotent- i.e. running the script multiple times has the same effect
*/

-- .read Lessons/1.9/1.21_DDL_DML_PT1.sql

USE data_jobs;
DROP DATABASE IF EXISTS jobs_mart;
CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

SELECT * 
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;
-- DROP SCHEMA staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);


SELECT * 
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';


INSERT INTO staging.preferred_roles(role_id, role_name)
VALUES
    (1,'Data Engineer'),
    (2,'Senior Data Engineer'),
    (3,'Software Engineer');


SELECT * 
FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles 
ADD COLUMN preferred_role BOOLEAN;

-- ALTER TABLE staging.preferred_roles 
-- DROP COLUMN preferred_role;

UPDATE staging.preferred_roles 
SET preferred_role = 1
WHERE role_name IN ('Data Engineer', 'Senior Data Engineer');

UPDATE staging.preferred_roles
SET preferred_role = 0
WHERE role_name = 'Software Engineer';

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * 
FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_level;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_level TYPE INTEGER;


UPDATE staging.priority_roles
SET priority_level = 3
WHERE role_id = 3;


SELECT * FROM staging.priority_roles;

SELECT table_name, column_name, data_type FROM information_schema.columns
WHERE table_catalog ='jobs_mart';

select * from staging.priority_roles;