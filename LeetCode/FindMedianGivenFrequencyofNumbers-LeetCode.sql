
/*

LeetCode | MySQL

https://leetcode.com/problems/find-median-given-frequency-of-numbers/

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num is the primary key for this table.
Each row of this table shows the frequency of a number in the database.

The median is the value separating the higher half from the lower half of a data sample.

Write an SQL query to report the median of all the numbers in the database after decompressing 
the Numbers table. Round the median to one decimal point.

*/



# Write your MySQL query statement below


with cte1 as 
(
    select 
    num,
    sum(frequency) over() as tot_count,
    sum(frequency) over(order by num) as cum_sum
    from 
    numbers
),

cte2 as 
(
    select 
    num,
    cum_sum,
    case 
        when tot_count % 2 = 0 then tot_count/2 
        else floor(tot_count/2)+1 
    end as med_part1,
    floor(tot_count/2)+1 as med_part2,
    coalesce((lag(cum_sum) over(order by num)) + 1, cum_sum) as lag_cum_sum
    from
    cte1
)

select 
round(avg(num),1) as median
from 
cte2
where 
(med_part1 between lag_cum_sum and cum_sum)
or 
(med_part2 between lag_cum_sum and cum_sum)

