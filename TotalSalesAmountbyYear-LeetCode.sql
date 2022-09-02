/*

LeetCode | MySQL

https://leetcode.com/problems/total-sales-amount-by-year/

Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key for this table.
product_name is the name of the product.


Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.

Write an SQL query to report the total sales amount of each item for each year, with corresponding 
product_name, product_id, and report_year.

Return the result table ordered by product_id and report_year.

*/

# Write your MySQL query statement below

with cte1 as 
(
    select
    extract(year from period_start) as all_years
    from 
    Sales
    group by 1

    union distinct

    select
    extract(year from period_end) as all_years
    from 
    Sales
    group by 1
),

cte2 as (
    select 
    *,
    (datediff(
        case 
            when period_end < updated_period_end then period_end
            else updated_period_end 
        end,
        case 
            when period_start > updated_period_start then period_start
            else updated_period_start 
        end
    ) + 1) * average_daily_sales as period_sales
    from
    (
        select 
        *,
        case 
            when year_period_start <> year_period_end
            then cast(concat(cast(all_years as char), '-01-01') as date)
            else period_start
        end as updated_period_start,
        case 
            when year_period_start <> year_period_end
            then cast(concat(cast(all_years as char), '-12-31') as date)
            else period_end
        end as updated_period_end   
        from 
        cte1 as a
        left join 
        (
            select 
            *,
            extract(year from period_start) as year_period_start,
            extract(year from period_end) as year_period_end
            from
            Sales
        ) as s
        on a.all_years between year_period_start and year_period_end
        order by 2,1
    ) as a
)

select
c.product_id,
product_name,
cast(all_years as char) as report_year,
sum(period_sales) as total_amount
from 
cte2 as c
inner join 
Product as p
on c.product_id = p.product_id
group by 1,2,3
order by 1,3
