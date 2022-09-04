/*

LeetCode | MySQL

https://leetcode.com/problems/find-the-start-and-end-number-of-continuous-ranges/

Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
log_id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Write an SQL query to find the start and end number of continuous ranges in the table Logs.

Return the result table ordered by start_id.

*/

### Trick Used to Solve: 
### Calculate row_number to generate a continuous range of numbers
###	calculate log_id - row_number, continuous ranges should generate the same number for this calculation
### Eg: 1001 - 1 = 1000, 1002 - 2 = 1000 but if we skip 1003 and 1004 then we calculate 1005 - 3 = 1002

with cte as 
(
    select 
    log_id,
    log_id - row_number() over() as row_group_value
    from 
    Logs
)

select 
min(log_id) as start_id, max(log_id) as end_id
from 
cte
group by row_group_value