/*

https://platform.stratascratch.com/coding/10172-best-selling-item?code_type=1

Find the best selling item for each month (no need to separate months by year) where the biggest 
total invoice was paid. The best selling item is calculated using the formula (unitprice * quantity). 
Output the description of the item along with the amount paid.

*/

select 
month, 
description,
total_paid
from
(
    select 
    *,
    row_number() over(partition by month order by total_paid desc) as prod_rank
    from 
    (
        select 
        extract(month from invoicedate) as month,
        description,
        sum(unitprice * quantity) as total_paid
        from 
        online_retail
        group by 1,2
    ) as a
) as final
where prod_rank = 1