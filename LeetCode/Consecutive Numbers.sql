/*
MySQL

https://leetcode.com/problems/consecutive-numbers/description/

Write an SQL query to find all numbers that appear at least three times consecutively.

Schema:
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column.

Sample Input:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

*/


with cte as 
(
    select 
    num,
    -- take difference between id and the row number calculated previously
    -- for consecutive ids, this will return the same number
    cast(id as signed) - cast(rn as signed) as rn_diff
    from 
    (
        select
        id,
        num,
        -- for each number calculate the row number for the ids 
        -- if the ids are consecutive, that means the numbers are also consecutively occuring
        row_number() over(partition by num order by id)  as rn
        from 
        Logs
    ) as a 
)

select 
distinct num as ConsecutiveNums
from 
cte 
group by num, rn_diff
having count(*) >= 3
