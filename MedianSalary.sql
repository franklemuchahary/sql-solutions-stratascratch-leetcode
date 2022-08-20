
/*

https://platform.stratascratch.com/coding/9900-median-salary?code_type=1

Find the median employee salary of each department.
Output the department name along with the corresponding salary rounded to the nearest whole dollar.

*/



-- Solution without using the function percentile_cont
select 
department, 
round(avg(salary),0) as median_salary
from 
(
    select 
    *,
    ntile(100) over(partition by department order by salary) as ptile_num,
    count(id) over(partition by department) as total_employees
    from 
    employee
) as base
where 
    case 
        when total_employees%2 = 0 then (total_employees/2) + 1 = ptile_num or total_employees/2 = ptile_num
        else ceil(total_employees/2) = ptile_num 
    end
group by 1

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

--- Solution using the function percentile_cont (will work only for Postgres)
select 
department, 
percentile_cont(0.5) within group(order by salary) as median_salary
from 
employee
group by 1
