/*
MySQL
https://leetcode.com/problems/swap-salary/description/

Problem Topic: Update Query with a Case Statement

Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa)
with a single update statement and no intermediate temporary tables.

Input: 
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
+----+------+-----+--------+

Output: 
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
+----+------+-----+--------+

*/

update Salary
set sex = 
case 
when sex = 'm' then 'f'
else 'm'
end
