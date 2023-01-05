/*
MySQL
https://leetcode.com/problems/exchange-seats/description/

Write an SQL query to swap the seat id of every two consecutive students. 
If the number of students is odd, the id of the last student is not swapped.

Sample Input:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+

Expected Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+

*/

select 
id,
case 
when swap = '' then student else swap 
end as student
from 
(
    select 
    *,
    concat(
        coalesce(lead(student,1) over(partition by round(id/2)), ''),
        coalesce(lag(student,1) over(partition by round(id/2)), '')
    ) as swap
    from 
    Seat
) as a
