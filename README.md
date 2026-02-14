Employee Management System (EMS)

Overview  
The Employee Management System (EMS) is a SQL-based relational database project designed to manage and analyze employee, salary, and payroll data efficiently. It integrates departments, job roles, salary structures, qualifications, leave records, and payroll processing into a centralized system.  

Objectives  
- Design a relational database schema for employee management.  
- Define primary and foreign key relationships.  
- Import data from CSV files into SQL tables.  
- Perform HR and payroll analysis using SQL queries.  
- Generate insights for workforce distribution, salary allocation, and payroll trends.  

Database Design  
Tables included:  
- Employee – Stores employee details  
- JobDepartments – Department information  
- Qualification – Employee qualifications  
- SalaryBonus – Salary and bonus details  
- Leaves – Employee leave records  
- Payroll – Payroll processing and integration  

ER Diagram highlights:  
- One department can have many employees  
- One employee can have multiple leaves and qualifications  
- Payroll connects all entities ensuring data integrity and consistency  

Analysis & Insights  
- Employee Distribution: Finance and IT have the highest employee count  
- Salary Analysis: Legal has the highest average salary, followed by Engineering and Sales  
- Top Paid Employees: Senior-level employees dominate the compensation hierarchy  
- Total Salary Expenditure: Around 4.95 million including bonuses  
- Job Role Diversity: Finance and IT have the most diverse job roles  
- Salary Range: Legal and Sales show higher ranges; HR has lower ranges  
- Bonus Allocation: Finance leads in total bonus allocation; Legal and Engineering have higher averages  

Challenges Faced  
- Defining proper relationships between tables  
- Maintaining data consistency  
- Writing complex SQL joins  
- Preventing duplicate records using constraints  

Recommendations  
- Optimize salary and bonus allocation  
- Focus on core departments (Finance and IT)  
- Analyze leave patterns for workforce planning  
- Use data-driven insights for HR and financial decision-making  

Conclusion  
The Employee Management System provides structured insights into workforce distribution, salary allocation, and payroll trends. It supports better HR and financial decisions through data-driven analysis.  

How to Run  
1. Import the SQL schema into your database.  
2. Load CSV data into respective tables.  
3. Run the included SQL queries for analysis.  
4. Explore insights using joins, aggregations, and constraints.  



