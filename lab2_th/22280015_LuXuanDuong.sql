
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
        e.salary != 4500 OR
        e.salary != 10000 OR
        e.salary != 15000; 

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
SELECT 
    m.first_name AS manager_first_name, 
    m.last_name AS manager_last_name, 
    d.department_name, 
    l.city
FROM employees e
        JOIN departments d 
        ON e.department_id = d.department_id
        JOIN locations l 
        ON d.location_id = l.location_id
        JOIN employees m 
        ON e.manager_id = m.employee_id
WHERE m.manager_id is not null
GROUP BY m.first_name, m.last_name, d.department_name, l.city;

--x
SELECT  j.job_title, e.first_name, e.last_name, 
        e.salary - (SELECT MIN(salary) FROM employees) AS chenh_lech_luong_voi_luong_thap_nhat
FROM    employees e
        JOIN jobs j
        ON e.job_id = j.job_id
ORDER BY chenh_lech_luong_voi_luong_thap_nhat DESC
LIMIT 3;


