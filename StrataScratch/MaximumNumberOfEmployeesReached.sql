/*

https://platform.stratascratch.com/coding/2046-maximum-number-of-employees-reached?code_type=1

Write a query that returns every employee that has ever worked for the company. 
For each employee, calculate the greatest number of employees that worked for the 
company during their tenure and the first date that number was reached. 
The termination date of an employee should not be counted as a working day.


Your output should have the employee ID, greatest number of employees that worked 
for the company during the employee's tenure, and first date that number was reached.

*/

with modified_uber_employees as 
(
    select 
    *,
    case 
        when termination_date is null then transaction_timestamp()::date
        else termination_date - 1 
    end as td
    from 
    uber_employees
),

distinct_dates as 
(
    select 
    distinct hire_date as unique_dates
    from 
    modified_uber_employees
    
    union distinct 
    
    select 
    distinct td as unique_dates
    from 
    modified_uber_employees
),

dates_joined as 
(
    select 
    *
    from 
    modified_uber_employees as mue
    left join 
    distinct_dates as dd
    on dd.unique_dates between mue.hire_date and mue.td
),

final_counts as 
(
    select 
    dj.id, 
    unique_dates, 
    count(distinct mue.id) as count_emp2
    from 
    dates_joined as dj
    left join 
    modified_uber_employees as mue
    on dj.unique_dates between mue.hire_date and mue.td
    group by 1,2
)

select 
id, 
count_emp2 as maxemp,
unique_dates as dateaq
from 
(
    select 
    *,
    row_number() over(partition by id order by count_emp2 desc, unique_dates asc) as max_count_min_date_row_num
    from 
    final_counts
) as fc
where 
max_count_min_date_row_num = 1

