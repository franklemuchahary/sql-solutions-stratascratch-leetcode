/*

https://platform.stratascratch.com/coding/2090-first-day-retention-rate?code_type=1

Calculate the first-day retention rate of a group of video game players. The first-day retention occurs when a 
player logs in 1 day after their first-ever log-in. Return the proportion of players who meet this definition 
divided by the total number of players.

*/

select 
count(distinct case when login_date = (min_date_player + 1) then player_id end)/count(distinct player_id)::float as retention_rate
from 
(
    SELECT 
    *,
    min(login_date) over(partition by player_id) as min_date_player
    FROM 
    players_logins
) as a