/*								Bài tập thực hành Hệ quản trị cơ sở dữ liệu tuần 3						*/
/*	Họ và tên: Nguyễn Công Tiến Dũng
	MSSV: 22280014					  */

-- Thuc hanh CTE:
-- a)
create temp table t_posts as 
select * from posts;

-- b)
create temp table delete_posts as
select * from posts limit 0;

-- c)
-- Cach 1:
with delete_rows as (
	delete from t_posts
	where category in 
	(select c.id from categories c 
	where title='Database')
	returning*
)
insert into delete_posts
select * from delete_rows;

select * from delete_posts;
-- Cach 2:

-- d)
create temp table t_posts2 as
select * from posts;


-- e)
create temp table insert_posts as
select * from posts limit 0;

-- f) 
-- Cach 1:
with moved_rows as (
	delete from t_posts
	returning*
)
insert into insert_posts
select * from moved_rows;

select * from insert_posts;

-- Cach 2:
insert into insert_posts
select * from t_posts;

delete from t_posts;

select* from insert_posts;


-- Bai tap (tiep theo bai tap tuan 2)
--a)
select d.department_id, d.department_name, l.city, count(e.employee_id) as tong_so_luong_nv,
min(e.salary) as salary_min, max(e.salary) as max_salary, 
avg(e.salary) as avg_salary, sum(e.salary) as sum_salary
from departments d
join locations l on d.location_id = l.location_id
left join employees e on d.department_id = d.department_id
group by d.department_id, d.department_name, l.city
order by d.department_id;

--b)
select d.department_name, l.city, count(e.employee_id) as tong_so_luong_nv,
min(e.salary) as salary_min, max(e.salary) as max_salary, 
avg(e.salary) as avg_salary, sum(e.salary) as sum_salary
from departments d
join locations l on d.location_id = l.location_id
join countries c on l.country_id = c.country_id
join regions r on c.region_id = r.region_id
left join employees e on d.department_id=e.department_id
where r.region_name = 'Americas'
group by d.department_name, l.city
having sum(e.salary) > 30000
order by sum_salary desc;

--c)
select e.employee_id, e.first_name, e.last_name, e.hire_date, l.city
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where extract(month from e.hire_date) = 6
and l.city != 'London';

--d)
select distinct e.employee_id as manager_id, e.first_name, e.salary, j.job_title
from employees e
join jobs j on e.job_id = j.job_id
where e.salary in
	(select distinct salary from employees order by salary desc limit 5)
	and e.employee_id in
	(select distinct manager_id from employees where manager_id is not null);

--e) 
select e.first_name, e.last_name, e.salary, e.manager_id
from employees e
join employees m on e.employee_id = m.manager_id
join departments d on m.department_id = d.department_id
join locations l on d.location_id = l.location_id
join countries c on l.country_id = c.country_id
where c.country_name = 'United States of America'
	and e.salary > (
		select avg(salary) from employees 
		where manager_id = e.manager_id
	);

--f)
with recursive  employee_tree as (
	-- Non-recursive part: Lay nhan vien dung dau cong ty (NULL)
	select e.employee_id, e.first_name as employee_name,
			e.manager_id, m.first_name as manager_name, 
			0 as level, 
			cast(e.first_name as varchar(255)) as path
	from employees e
	left join employees m on e.manager_id  = m.employee_id
	where e.manager_id is null
	
	union

	-- Recursive part: Lay cac nhan vien cap duoi va them vao path
	select e.employee_id, e.first_name as employee_name,
			e.manager_id, m.first_name as manager_name, 
			et.level + 1 as level,
			cast(et.path || '->' || e.first_name as varchar(255)) as path
	from employees e
	join employee_tree et on e.manager_id = et.employee_id
	left join employees m on e.manager_id = m.employee_id
)
select level, path, manager_name, employee_name, manager_id, employee_id
from employee_tree 
order by level, employee_id, path;

-- Dùng CTE đệ quy phân chia cây như sau: Mức 0 là region, mức 1 là country thuộc region đó, 
-- mức 2 là city thuộc region-country đó.
with recursive location_tree as (
	select 
		r.region_id::text as id,
		r.region_name as location_name,
		null::text as parent_id,
		0 as level,
		r.region_name::text as path
	from regions r
	
	union all

	select
		case when c.country_id is not null then c.country_id::text
		else l.location_id::text end as id,
		
		case when c.country_name is not null then c.country_name
		else l.city end as location_name,
		
		case when c.region_id is not null then c.region_id::text
		else l.country_id::text end as parent_id,
		
		lt.level +1 as level,
		(lt.path || '->' || coalesce(c.country_name, l.city))::text as path
	from location_tree lt
	left join countries c on lt.id = c.region_id::text and lt.level = 0
	left join locations l on lt.id = l.country_id::text and lt.level = 1
	where c.country_id is not null or l.location_id is not null
)
select level, path, id
from location_tree
order by level, path, id;
