/*
LeetCode | MySQL

https://leetcode.com/problems/countries-you-can-safely-invest-in/

Table Person:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| name           | varchar |
| phone_number   | varchar |
+----------------+---------+
id is the primary key for this table.
Each row of this table contains the name of a person and their phone number.
Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) and yyyyyyy is the phone number 
(7 characters) where x and y are digits. Both can contain leading zeros.
 

Table Country:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| name           | varchar |
| country_code   | varchar |
+----------------+---------+
country_code is the primary key for this table.
Each row of this table contains the country name and its code. country_code will be in the form 'xxx' where x is digits.
 

Table Calls:

+-------------+------+
| Column Name | Type |
+-------------+------+
| caller_id   | int  |
| callee_id   | int  |
| duration    | int  |
+-------------+------+
There is no primary key for this table, it may contain duplicates.
Each row of this table contains the caller id, callee id and the duration of the call in minutes. caller_id != callee_id


A telecommunications company wants to invest in new countries. The company intends to invest in the 
countries where the average call duration of the calls in this country is strictly greater than the 
global average call duration.
Write an SQL query to find the countries where this company can invest.
Return the result table in any order.


*/

# Write your MySQL query statement below
with per_cte as 
(
    select 
    *,
    substring(phone_number, 1, 3) as country_code
    from 
    Person
),

call_cte as 
(
    select 
    caller_id, duration
    from 
    Calls
    where caller_id <> callee_id
    
    union all
    
    select 
    callee_id, duration
    from 
    Calls
    where caller_id <> callee_id
),

final_cte as 
(
    select 
    country,
    avg(dur1) over() as global_avg_duration,
    avg(dur1) over(partition by country_code) as country_avg_duration
    from 
    (
        select 
        p.*,
        c1.caller_id, 
        c1.duration as dur1,
        cnt.name as country
        from 
        call_cte as c1
        left join 
        per_cte as p
        on p.id = c1.caller_id
        left join 
        Country as cnt
        on p.country_code = cnt.country_code
    ) as a
)

select 
country
from final_cte
where country_avg_duration > global_avg_duration 
group by 1


