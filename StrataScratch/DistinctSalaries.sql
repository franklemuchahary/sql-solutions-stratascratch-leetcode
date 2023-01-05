/*

https://platform.stratascratch.com/coding/9898-unique-salaries?code_type=1

Find the top three distinct salaries for each department. Output the department name and the top 3 distinct
salaries by each department. Order your results alphabetically by department and then by highest salary to lowest.

*/

select 
department, salary
from
(
    select 
    *, 
    row_number() over(partition by department order by salary desc) as row_num
    from
    (
        select 
        salary, department
        from 
        twitter_employee
        group by 1,2
    ) as a
) as a
where row_num <= 3
order by department, salary desc