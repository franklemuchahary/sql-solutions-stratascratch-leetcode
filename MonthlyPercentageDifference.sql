/*

https://platform.stratascratch.com/coding/10319-monthly-percentage-difference?code_type=1


Given a table of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd 
decimal point, and sorted from the beginning of the year to the end of the year.
The percentage change column will be populated from the 2nd month forward and can be calculated 
as ((this month's revenue - last month's revenue) / last month's revenue)*100.

*/

with base_calc as 
(
    select 
    *,
    lag(rev) over(order by year, month) as prev_month_rev
    from 
    (
        select 
        extract(year from created_at) as year,
        extract(month from created_at) as month,
        sum(value) as rev
        from 
        sf_transactions
        group by 1,2
    ) as a
)

select 
concat(year::text, '-', lpad(month::text,2,'0')) as year_month,
round(((rev - prev_month_rev)/prev_month_rev)*100,2) as revenue_diff_pct
from 
base_calc


--- more concise solution
select 
to_char(created_at, 'YYYY-MM') as year_month,
round(
    ((sum(value)-lag(sum(value)) over(win))/lag(sum(value)) over(win))*100,
    2
) as prev_month_rev
from 
sf_transactions
group by 1
window win as (order by to_char(created_at, 'YYYY-MM'))