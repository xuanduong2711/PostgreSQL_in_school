-- CTE
--a 
CREATE TEMP TABLE t_posts AS 
SELECT * FROM posts;

--b
CREATE TEMPORARY TABLE delete_posts (LIKE posts INCLUDING ALL);

--c
WITH deleted_rows AS (
    DELETE FROM t_posts
    WHERE category = 'Database'
    RETURNING *
)
INSERT INTO delete_posts
SELECT * FROM delete_rows

--d
CREATE TEMP TABLE t_posts2 AS 
SELECT * FROM posts;

--e
CREATE TEMPORARY TABLE inserted_posts (LIKE posts INCLUDING ALL);

--f
WITH move_rows AS (
    DELETE FROM t_posts2
    RETURNING *
)
INSERT INTO inserted_posts
SELECT * FROM move_rows

-- PART 2

--a
SELECT  d.department_name, l.city, COUNT(e.employee_id),
        MIN(e.salary), MAX(e.salary), AVG(e.salary), SUM(e.salary)
FROM    employees e 
        JOIN  departments d 
            ON    e.department_id = d.department_id
        JOIN  locations l
            ON    d.location_id = l.location_id
GROUP BY  d.department_name, l.city
ORDER BY MIN(d.department_id) ASC

--b
SELECT  d.department_name, l.city, COUNT(e.employee_id),
        SUM(e.salary)
FROM    employees e 
        JOIN      departments d 
            ON    e.department_id = d.department_id
        JOIN      locations l
            ON    d.location_id = l.location_id
        JOIN      countries
            ON    l.country_id = countries.country_id
        JOIN      regions
            ON    countries.region_id = regions.region_id
WHERE   region_name = 'Americas'
GROUP BY  d.department_name, l.city
HAVING SUM(e.salary) > 3000
ORDER BY SUM(e.salary) DESC

--c
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
    JOIN departments d 
        ON e.department_id = d.department_id
    JOIN locations l 
        ON d.location_id = l.location_id
WHERE EXTRACT(MONTH FROM e.hire_date) = 6
AND l.city NOT LIKE 'London';

--d
SELECT e.employee_id, e.first_name, e.salary, j.job_title
FROM employees e
    JOIN jobs j 
        ON e.job_id = j.job_id
WHERE e.employee_id IN 
        (SELECT manager_id 
        FROM employees 
        )
ORDER BY e.salary DESC
LIMIT 5;

--e
SELECT e.first_name, e.last_name, e.salary, e.manager_id
FROM employees e
	JOIN employees m 
		ON e.manager_id = m.employee_id 
    JOIN departments d
        ON m.department_id = d.department_id
    JOIN locations l
        ON d.location_id = l.location_id
    JOIN countries c
        ON l.country_id = c.country_id
WHERE  c.country_name = 'United States of America'  AND
    e.salary > (SELECT AVG(salary) 
                FROM employees 
                WHERE manager_id = e.manager_id);

--f
WITH RECURSIVE manager_tree AS (
    SELECT 0 AS level, 
           e.first_name::TEXT AS path,
           m.first_name as manager_name,
           e.first_name as employee_name, 
           e.manager_id as manager_id, 
           e.employee_id as employee_id
    FROM   employees e
         LEFT JOIN employees m 
            ON e.manager_id = m.employee_id
    WHERE e.manager_id IS NULL 

    UNION 

    SELECT mt.level + 1 AS level,
           (mt.path || ' -> ' || e.first_name)::TEXT AS path,
           m.first_name as manager_name,
           e.first_name as employee_name, 
           e.manager_id as manager_id, 
           e.employee_id as employee_id 
    FROM employees e 
        JOIN employees m 
            ON e.manager_id = m.employee_id
        JOIN manager_tree mt 
            ON e.manager_id = mt.employee_id
)
SELECT * 
FROM manager_tree
ORDER BY level, employee_id;
------------

-- Bonus
WITH RECURSIVE region_country AS (
    SELECT 
        0 AS level,
        r.region_name::TEXT AS path,
        r.region_id::TEXT AS id  
    FROM regions r

    UNION 
    
    SELECT 
        rc.level + 1 AS level,
        CASE
            WHEN rc.level = 0
                THEN (rc.path || ' -> ' || c.country_name)::TEXT
            WHEN rc.level = 1
                THEN (rc.path || ' -> ' || l.city)::TEXT 
        END AS path,
        CASE 
            WHEN rc.level = 0 THEN c.country_id::TEXT
            WHEN rc.level = 1 THEN l.location_id::TEXT
        END AS id
    FROM region_country rc
        LEFT JOIN countries c 
            ON rc.id::TEXT = c.region_id::TEXT
        LEFT JOIN locations l
            ON rc.id::TEXT = l.country_id::TEXT
    WHERE   c.country_id IS NOT NULL OR
            l.location_id IS NOT NULL
) 
SELECT * 
FROM region_country 
ORDER BY level;
