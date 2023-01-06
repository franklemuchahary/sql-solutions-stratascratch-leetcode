/*
Problem Topic: PIVOT TABLES

Write an SQL query to reformat the table such that there is a 
department id column and a revenue column for each month.


Input:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+

Output: 
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+

*/


---------------- Solution 1 ----------------
select 
id,
sum(case when month = 'Jan' then Revenue end) as Jan_Revenue,
sum(case when month = 'Feb' then Revenue end) as Feb_Revenue,
sum(case when month = 'Mar' then Revenue end) as Mar_Revenue,
sum(case when month = 'Apr' then Revenue end) as Apr_Revenue,
sum(case when month = 'May' then Revenue end) as May_Revenue,
sum(case when month = 'Jun' then Revenue end) as Jun_Revenue,
sum(case when month = 'Jul' then Revenue end) as Jul_Revenue,
sum(case when month = 'Aug' then Revenue end) as Aug_Revenue,
sum(case when month = 'Sep' then Revenue end) as Sep_Revenue,
sum(case when month = 'Oct' then Revenue end) as Oct_Revenue,
sum(case when month = 'Nov' then Revenue end) as Nov_Revenue,
sum(case when month = 'Dec' then Revenue end) as Dec_Revenue
from 
Department
group by 1


---------------- Solution 2 ----------------
-- Note: This will not work in MySQL. MySQL does not have the Pivot Operator. 
-- Will work in Postgres and SQL Server
SELECT 
id,
Jan AS Jan_Revenue, Feb AS Feb_Revenue, Mar AS Mar_Revenue,
Apr as Apr_Revenue, May as May_Revenue, Jun as Jun_Revenue,
Jul as Jul_Revenue, Aug as Aug_Revenue, Sep as Sep_Revenue,
Oct as Oct_Revenue, Nov as Nov_Revenue, Dec as Dec_Revenue
FROM   
(
    SELECT 
    id, revenue, month
    from Department
) p  
PIVOT  
(  
    SUM(revenue)  
    FOR month IN 
    ( 
        Jan, Feb, Mar,
        Apr, May, Jun,
        Jul, Aug, Sep,
        Oct, Nov, Dec 
    )  
) AS pvt  
