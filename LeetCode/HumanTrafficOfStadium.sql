/*
MySQL
https://leetcode.com/problems/human-traffic-of-stadium/description/

Write an SQL query to display the records with three or more rows with consecutive id's, and 
the number of people is greater than or equal to 100 for each.

Input: 
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

Output: 
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

*/

with cte as 
(
    select 
    *,
    -- Same logic used for the `Consecutive Numbers` problem. Calculate row number and take difference
    id - (row_number() over(order by id)) as diff
    from 
    (
        select 
        *
        from 
        Stadium
        where people >= 100
    ) as a
) 

select 
id, visit_date, people
from 
(
    select 
    *,
    count(id) over(partition by diff) as count_ids
    from 
    cte
) as a
where count_ids >= 3
