/*

https://platform.stratascratch.com/coding/2076-trips-in-consecutive-months?code_type=1

Find the IDs of the drivers who completed at least one trip a month for at least two months in a row.

*/

with cte1 as 
(
    select 
    *,
    LAG(trip_count_flag) over(partition by driver_id order by ym asc) as lag_trip_count_flag,
    ym - LAG(ym) over(partition by driver_id order by ym asc) as delta_ym
    from 
    (
        select 
        driver_id,
        (extract(year from trip_date)*100) + extract(month from trip_date) as ym,
        case 
            when count(distinct case when is_completed = True then trip_id end) >= 1 then 1 
            else 0 
        end as trip_count_flag
        from 
        uber_trips
        group by 1,2
        order by 1,2
    ) as base_calculations
)

select 
distinct driver_id
from 
cte1
where
delta_ym in (1, 89)
and trip_count_flag + lag_trip_count_flag >= 2