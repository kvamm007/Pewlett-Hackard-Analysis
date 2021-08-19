--Deliverable 1
--Retirement Titles Query
SELECT e.emp_no, 
	e.first_name,
	e.last_name,
	ts.title,
	ts.from_date,
	ts.to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN titles AS ts
	ON (e.emp_no = ts.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, 
	rt.first_name, 
	rt.last_name, 
	rt.title
INTO unique_titles
FROM retirement_titles AS rt
ORDER BY rt.emp_no, rt.to_date DESC;

--Employees by job title
SELECT 
	COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY ut.count DESC;



--Deliverable 2
--Mentorship Eligibility
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date, 
	de.to_date,
	ts.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ts
	ON (e.emp_no = ts.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no, ts.to_date DESC;

--Extras
--Mentorship Eligibility by job title
SELECT 
	COUNT(me.title),
	me.title
INTO mentorship_titles
FROM mentorship_eligibility AS me
GROUP BY me.title
ORDER BY me.count DESC;


--Retirement Eligibility by department
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date, 
	de.to_date,
	de.dept_no,
	d.dept_name,
	ts.title
INTO retirement_eligibility_departments
FROM employees AS e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ts
	ON (e.emp_no = ts.emp_no)
INNER JOIN departments as d
	ON (d.dept_no = de.dept_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no, ts.to_date DESC;

--Retirement Eligibility by Department count
SELECT 
	COUNT(red.dept_name) AS retiree_count,
	red.dept_name
INTO retirement_dept_count
FROM retirement_eligibility_departments AS red
GROUP BY red.dept_name
ORDER BY red.dept_name DESC;

--Total Current Staff w Dept
SELECT DISTINCT ON (de.emp_no) de.emp_no,
	de.dept_no,
	d.dept_name
INTO total_departments
FROM dept_emp AS de
INNER JOIN departments as d
	ON (d.dept_no = de.dept_no)
WHERE (de.to_date = '9999-01-01');

--Current staff by Dept
SELECT 
	COUNT(td.emp_no) AS total_staff,
	td.dept_name
INTO total_dept_count
FROM total_departments AS td
GROUP BY td.dept_name
ORDER BY td.dept_name DESC;

--Percent Staff retiring in dept; add percent after to CSV
SElECT tdc.dept_name,
	tdc.total_staff, 
	rdc.retiree_count
INTO percent_dept_retiring
FROM total_dept_count AS tdc
INNER JOIN retirement_dept_count AS rdc
	ON (tdc.dept_name = rdc.dept_name);
