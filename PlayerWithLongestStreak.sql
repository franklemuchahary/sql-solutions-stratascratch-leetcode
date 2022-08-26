/*

https://platform.stratascratch.com/coding/2059-player-with-longest-streak?code_type=1

You are given a table of tennis players and their matches that they could either win (W) or lose (L). 
Find the longest streak of wins. A streak is a set of consecutive won matches of one player. 
The streak ends once a player loses their next match. Output the ID of the player or players and the length of the streak.

*/

with base_cte as 
(
    select 
    *,
    coalesce(
        lead(match_date) over(partition by player_id order by match_date),
        max_date + 1
    ) as end_date
    from 
    (
        select 
        *,
        max(match_date) over(w) as max_date,
        lag(match_result) over(w) as lag_result
        from 
        players_results
        window w as (partition by player_id order by match_date)
    ) as a
    where 
    match_result != lag_result
    or lag_result is null
)

select 
player_id, 
streak_length
from 
(
    select 
    *,
    max(streak_length) over() as max_overall_streak
    from 
    (
        select 
        pr.player_id,
        b.match_date as start_date,
        b.end_date as end_date,
        count(*) as streak_length
        from 
        players_results as pr
        left join 
        base_cte as b
        on pr.player_id = b.player_id
        and pr.match_date >= b.match_date and pr.match_date < b.end_date
        where pr.match_result = 'W'
        group by 1,2,3
    ) as a
) as a
where streak_length = max_overall_streak
