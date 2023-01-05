/*

https://platform.stratascratch.com/coding/514-marketing-campaign-success-advanced?code_type=1

You have a table of in-app purchases by user. Users that make their first in-app purchase are placed in a marketing 
campaign where they see call-to-actions for more in-app purchases. Find the number of users that made additional 
in-app purchases due to the success of the marketing campaign.

The marketing campaign doesn't start until one day after the initial in-app purchase so users that only made 
one or multiple purchases on the first day do not count, nor do we count users that over time purchase only 
the products they purchased on the first day.

*/

select 
count(distinct user_id) as "count"
from 
(
    select 
    user_id,
    count(distinct case when created_at::date = min_date then product_id end) as first_day_prod_count,
    count(distinct product_id) as prod_count,
    count(distinct created_at::date) as date_count
    from 
    (
        select 
        *,
        min(created_at) over(partition by user_id) as min_date
        from 
        marketing_campaign
        where quantity > 0
    ) as a
    group by 1
) as a
where prod_count > 1
and date_count > 1
and prod_count > first_day_prod_count
