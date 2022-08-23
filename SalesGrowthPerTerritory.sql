/*

https://platform.stratascratch.com/coding/2111-sales-growth-per-territory?code_type=1

Write a query to return Territory and corresponding Sales Growth. Compare growth between periods Q4-2021 vs Q3-2021.
If Territory (say T123) has Sales worth $100 in Q3-2021 and Sales worth $110 in Q4-2021, then the Sales Growth will 
be 10% [ i.e. = ((110 - 100)/100) * 100 ]

Output the ID of the Territory and the Sales Growth. Only output these territories that had any sales in both quarters.

*/


with base_calculations as 
(
    select 
    territory_id,
    sum(case when extract(quarter from order_date) = 3 then order_value end) as q3_sales,
    sum(case when extract(quarter from order_date) = 4 then order_value end) as q4_sales
    from 
    fct_customer_sales as cs
    left join 
    map_customer_territory as ct
    using(cust_id)
    where 
    extract(year from order_date) = 2021
    and extract(quarter from order_date) in (3,4)
    group by 1
)

select 
territory_id,
((q4_sales - q3_sales)/q3_sales)*100 as sales_growth
from
base_calculations
where 
q4_sales is not null
and q3_sales is not null
order by 1
