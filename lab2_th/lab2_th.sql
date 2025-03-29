--cau 1
CREATE ROLE hradmin WITH LOGIN PASSWORD '123';

-- cau 2
CREATE DATABASE hr 
WITH OWNER hradmin;

--Cau 3
CREATE SCHEMA hrschema AUTHORIZATION hradmin;


--Cau 4
CREATE TABLE    regions (
    region_id       INT PRIMARY KEY,
    region_name     VARCHAR(50)
);

CREATE TABLE    countries (
    country_id      VARCHAR(5) PRIMARY KEY,
    country_name    VARCHAR(50),
    region_id       INT REFERENCES regions(region_id)
);

CREATE TABLE    locations (
    location_id     INT PRIMARY KEY,
    street_address  VARCHAR(50),
    postal_code     VARCHAR(50),
    city            VARCHAR(50),
    state_province  VARCHAR(50),
    country_id      VARCHAR(5) REFERENCES countries(country_id)
);

CREATE TABLE    departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(50),
    location_id     INT REFERENCES locations(location_id)
);

CREATE TABLE jobs (
    job_id      INT PRIMARY KEY,
    job_title   VARCHAR(50) NOT NULL,
    min_salary  DECIMAL(8, 2),
    max_salary  DECIMAL(8, 2)
);

CREATE TABLE employees (
    employee_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    email           VARCHAR(50),
    phone_number    VARCHAR(50),
    hire_date       DATE,
    job_id          INT REFERENCES jobs(job_id),
    salary          DECIMAL(8,2),
    commission_pct  DECIMAL(8,2),
    manager_id      INT REFERENCES employees(employee_id),
    department_id   INT REFERENCES departments(department_id)
);

CREATE TABLE job_history (
    employee_id     INT,
    start_date      DATE,
    end_date        DATE,
    job_id          INT REFERENCES jobs(job_id),
    department_id   INT REFERENCES departments(department_id),
    PRIMARY KEY (employee_id, start_date) 
);

--Cau 5
\i 'C:/Users/Admin/OneDrive - VNU-HCMUS/2022-2026/Nam 3/HQTCSDL/lab2_th/hr_data.sql'

--Cau 6
--a
SELECT  UPPER(SUBSTRING(first_name,1, 3))
FROM    employees;

--b
SELECT  TRIM(first_name)
FROM    employees;

--c
SELECT  first_name, last_name, LENGTH(first_name) + LENGTH(last_name) AS do_dai
FROM    employees;

--d
SELECT  first_name, last_name, ROUND(salary/12, 2) AS luong_theo_thang
FROM    employees;

--e
SELECT  first_name, last_name, salary
FROM    employees
WHERE   salary >= 10000 AND salary <= 15000;

--f
SELECT  first_name, last_name, department_id  
FROM    employees
WHERE   department_id = 3 OR
        department_id = 10
ORDER BY department_id ASC;

--g
SELECT  first_name, last_name, department_id, salary
FROM    employees
WHERE   department_id IN (3, 10)  AND NOT 
        (salary >= 10000 AND salary <= 15000);

--h
SELECT  first_name
FROM    employees
WHERE   first_name LIKE '%c%' AND
        first_name LIKE '%e%';

--i
SELECT  last_name
FROM    employees
WHERE   LENGTH(last_name) = 6;

--j
SELECT  last_name
FROM    employees
WHERE   last_name LIKE '__e%';

--k
SELECT  first_name ,last_name , salary , (salary * 0.15) AS "15_phan_tram_luong"
FROM    employees;

--l
SELECT  SUM(salary) AS tong_luong
FROM    employees;

--m
SELECT  MAX(salary) AS luong_cao_nhat,
        MIN(salary) AS luong_thap_nhat,
        ROUND(AVG(salary), 2) AS luong_trung_binh,
        COUNT(employee_id) AS so_luong_nhan_vien
FROM    employees;

--n
SELECT  DISTINCT j.job_id, j.job_title
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
ORDER BY job_id ASC;

--o
SELECT MAX(e.salary) AS luong_cao_nhat
FROM jobs as j
    JOIN employees as e
    ON e.job_id = j.job_id
WHERE j.job_title = 'Programmer';

--p
SELECT  MAX(salary) -MIN(salary) as chenh_lech_luong
FROM employees;

--q
SELECT  e.department_id, e.first_name, e.last_name 
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
WHERE   j.job_title LIKE '%Manager%';   

--r
SELECT  manager_id, MIN(salary) AS min_salary_cua_nhan_vien
FROM    employees
GROUP BY manager_id;

--s
SELECT  e.department_id, d.department_name, SUM(e.salary) AS tong_luong
FROM    employees e
        JOIN departments d
        ON e.department_id = d.department_id
GROUP BY d.department_name, e.department_id
HAVING SUM(e.salary) > 30000 
ORDER BY e.department_id DESC;

--t
SELECT  e.first_name, e.last_name, j.job_title, e.salary
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
WHERE   j.job_title NOT LIKE 'Programmer' OR
        j.job_title NOT LIKE 'Shipping Clerk' OR
        e.salary = 4500 OR
        e.salary = 10000 OR
        e.salary = 15000; 

--u
SELECT  d.department_name, AVG(e.salary) AS luong_trung_binh
FROM    employees e
        JOIN departments d
        ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.salary) > 5;

--v
SELECT  j.job_title, e.salary, AVG(e.salary)
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
GROUP BY j.job_title,  e.salary ;

--w
SELECT e.first_name, e.last_name, d.department_name, c.country_name
FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
    JOIN locations l
    ON d.location_id = l.location_id
    JOIN countries c
    ON l.country_id = c.country_id;

--x
SELECT  j.job_title, e.first_name, e.last_name, MAX(e.salary) - MIN(e.salary) AS chenh_lech_luong
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
GROUP BY j.job_title, e.first_name, e.last_name
ORDER BY chenh_lech_luong DESC
LIMIT 3;



