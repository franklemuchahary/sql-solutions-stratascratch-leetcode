/*

https://platform.stratascratch.com/coding/10314-revenue-over-time?code_type=1

Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase 
amount, and date purchased. Do not include returns which are represented by negative purchase values. 
Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month.


A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the 
current month and previous two months. The first two months will not be a true 3-month rolling average since we
are not given data from last year. Assume each month has at least one purchase.

*/


select 
month,
avg(rev) over(order by month rows between 2 preceding and current row )
from
(
    select 
    concat(
        extract(year from created_at)::text,
        '-',
        lpad(extract(month from created_at)::text, 2, '0')
    ) as month,
    sum(purchase_amt) as rev
    from
    amazon_purchases
    where purchase_amt > 0
    group by 1
) as a