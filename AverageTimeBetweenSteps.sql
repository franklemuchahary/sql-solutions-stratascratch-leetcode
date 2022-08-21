/*

https://platform.stratascratch.com/coding/9793-average-time-between-steps?code_type=1

Find the average time (in seconds), per product, that needed to progress between steps. 
You can ignore products that were never used. Output the feature id and the average time.

*/


with time_calc_cte as 
(
    select 
    *,
    datediff('seconds', prev_timestamp, timestamp) as secs_diff
    from 
    (
        select 
        *,
        LAG(timestamp) over(partition by feature_id, user_id order by step_reached) as prev_timestamp
        from 
        facebook_product_features_realizations
    ) as a
    where prev_timestamp is not null
)

select 
feature_id, 
avg(avg_time_per_step_per_user) as "avg"
from 
(
    select 
    feature_id, user_id, avg(secs_diff) as avg_time_per_step_per_user
    from 
    time_calc_cte
    group by 1,2
) as final
group by 1
