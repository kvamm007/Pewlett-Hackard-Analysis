SELECT * FROM retirement_info;

--Retirement Eligibility
SELECT first_name, last_name
INTO retirement_info
from employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' and '1988-12-31');

DROP TABLE retirement_info;

--Retirement Eligibility
SELECT emp_no, first_name, last_name
INTO retirement_info
from employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' and '1988-12-31');

--Check table
SELECT * from retirement_info;

--Joining dept and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no, 
	dept_manager.from_date, 
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept.no;

--Joining Retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name, 
	ri.last_name, 
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--Currently Employed
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name, 
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date=('9999-01-01');

SELECT * FROM current_emp;

--Emp count by dept no
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retiree_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no=de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Emp info table
SELECT e.emp_no,
	e.first_name,
	e.last_name, 
	e.gender, 
	s.salary, 
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' and '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' and '1988-12-31')
	AND (de.to_date = '9999-01-01');
	
--Managers per dept
SELECT dm.dept_no,
	d.dept_name, 
	dm.emp_no, 
	ce.last_name, 
	ce.first_name, 
	dm.from_date, 
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);

--Retiree by dept
SELECT ce.emp_no, 
	ce.first_name, 
	ce.last_name, 
	d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no=de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);