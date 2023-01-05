/*

https://platform.stratascratch.com/coding/2044-most-senior-junior-employee?code_type=1

Write a query to find the number of days between the longest and least tenured employee still working for the company. 
Your output should include the number of employees with the longest-tenure, the number of employees with the least-tenure, 
and the number of days between both the longest-tenured and least-tenured hiring dates.

*/

with cte_days_diff as 
(
    select 
    *, 
    datediff(
        'day',
        hire_date, 
        -- some termination dates are null indicating that they still work there. 
        -- imputing those with the max termination date in the entire table
        coalesce(termination_date, max(hire_date) over())
    ) as num_days,
    max(hire_date) over() - min(hire_date) over() as days_diff
    from 
    uber_employees
) 

select 
count(case when num_days = min_days then id end) as shortest_tenured_count,
count(case when num_days = max_days then id end) as longest_tenured_count,
avg(days_diff) as days_diff
from 
cte_days_diff,
(
    select 
    min(num_days) as min_days, 
    max(num_days) as max_days 
    from cte_days_diff
) as min_max_days
