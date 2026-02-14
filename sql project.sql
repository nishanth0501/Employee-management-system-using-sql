create database sql_project;
use sql_project;

CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
    
       REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- --Analysis Questions

#1.1.How many unique employees are currently in the system?
SELECT COUNT(DISTINCT emp_ID) AS total_employees
FROM Employee;


#1.2 Departments with Highest Number of Employees
SELECT j.jobdept AS department,
       COUNT(e.emp_ID) AS number_of_employees
FROM JobDepartment j
JOIN Employee e ON j.Job_ID = e.Job_ID
GROUP BY j.jobdept;



#1.3 Average Salary per Department
SELECT j.jobdept AS department,
       AVG(s.amount) AS avg_salary
FROM Payroll p
JOIN SalaryBonus s 
  ON p.salary_ID = s.salary_ID
JOIN JobDepartment j 
  ON p.job_ID = j.Job_ID
GROUP BY j.jobdept;


#1.4 Top 5 Highest Paid Employees
SELECT concat(e.firstname,' ',
       e.lastname) as "Employee Name",
       s.amount AS salary
FROM Payroll p
JOIN Employee e ON p.emp_ID = e.emp_ID
JOIN SalaryBonus s ON p.salary_ID = s.salary_ID
ORDER BY s.amount DESC
LIMIT 5;

#1.5 Total Salary Expenditure (Company-Wide)
SELECT SUM(s.amount + s.bonus) AS total_salary_expenditure
FROM Payroll p
JOIN SalaryBonus s 
ON p.salary_ID = s.salary_ID;



#2. JOB ROLE & DEPARTMENT ANALYSIS

# 2.1 Number of Job Roles per Department
SELECT jobdept AS department,
       COUNT(name) AS total_jobs
FROM JobDepartment
GROUP BY jobdept;


#2.2 Average Salary Range per Department
SELECT j.jobdept AS department,
       AVG(p.total_amount) AS avg_salary
FROM Payroll p
JOIN JobDepartment j
ON p.job_ID = j.Job_ID
GROUP BY j.jobdept;


#2.3 Highest Paid Job Designation
SELECT j.name AS job_name,
       MAX(s.amount) AS highest_salary
FROM JobDepartment j
JOIN SalaryBonus s ON j.Job_ID = s.Job_ID
GROUP BY j.name
ORDER BY highest_salary DESC;

#2.4 Department with Highest Salary Budget
SELECT j.jobdept AS department,
       SUM(s.amount) AS total_salary
FROM Payroll p
JOIN SalaryBonus s ON p.salary_ID = s.salary_ID
JOIN JobDepartment j ON p.job_ID = j.Job_ID
GROUP BY j.jobdept
ORDER BY total_salary DESC;

#SECTION 3: QUALIFICATION ANALYSIS
-- 10. Total Qualified Employees
SELECT COUNT(DISTINCT Emp_ID) AS qualified_employees
FROM Qualification;

-- 11. Employees with Most Qualifications

SELECT concat(e.firstname,' ',
       e.lastname) as "Employee Name",
       COUNT(q.QualID) AS total_qualifications
FROM Employee e
JOIN Qualification q ON e.emp_ID = q.Emp_ID
GROUP BY e.emp_ID
ORDER BY total_qualifications DESC;

# 12. Job Designations with Most Requirements
SELECT Position AS job_name,
       COUNT(*) AS requirement_count
FROM Qualification
GROUP BY Position
ORDER BY requirement_count DESC;

-- SECTION 4: LEAVE ANALYSIS

-- 13. Employees with Most Leaves
SELECT concat(e.firstname,' ',
       e.lastname) as 'Employee Name',
       COUNT(l.leave_ID) AS total_leaves
FROM Employee e
JOIN Leaves l ON e.emp_ID = l.emp_ID
GROUP BY e.emp_ID
ORDER BY total_leaves DESC;

#14. Total Number of Leaves
SELECT COUNT(*) AS total_leaves
FROM Leaves;


#15. Average Leaves per Department

SELECT j.jobdept AS department,
       AVG(l.leave_count) AS avg_leaves
FROM (
    SELECT emp_ID,
           COUNT(*) AS leave_count
    FROM Leaves
    GROUP BY emp_ID
) l
JOIN Employee e ON l.emp_ID = e.emp_ID
JOIN JobDepartment j ON e.Job_ID = j.Job_ID
GROUP BY j.jobdept;

#SECTION 5: PAYROLL & SALARY ANALYSIS
-- 16. Monthly Payroll Report
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       SUM(total_amount) AS monthly_payment
FROM Payroll
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;

-- 17. Average Bonus per Department
SELECT j.jobdept AS department,
       AVG(s.bonus) AS avg_bonus
FROM SalaryBonus s
JOIN JobDepartment j ON s.Job_ID = j.Job_ID
GROUP BY j.jobdept;

-- 18. Department with Highest Bonus
SELECT j.jobdept AS department,
       SUM(s.bonus) AS total_bonus
FROM SalaryBonus s
JOIN JobDepartment j ON s.Job_ID = j.Job_ID
GROUP BY j.jobdept
ORDER BY total_bonus DESC;

-- 19. Average Final Salary

SELECT AVG(total_amount) AS avg_salary
FROM Payroll;

-- 20. Leave vs Salary Analysis
SELECT e.emp_ID,
       COUNT(l.leave_ID) AS total_leaves,
       AVG(p.total_amount) AS avg_salary
FROM Employee e
LEFT JOIN Leaves l ON e.emp_ID = l.emp_ID
LEFT JOIN Payroll p ON e.emp_ID = p.emp_ID
GROUP BY e.emp_ID;
































