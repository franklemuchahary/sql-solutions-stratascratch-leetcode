/*

https://platform.stratascratch.com/coding/9776-common-interests-amongst-users?code_type=1

Count the subpopulations across datasets. Assume that a subpopulation is a group of users sharing a 
common interest (ex: Basketball, Food). Output the percentage of overlapping interests for two posters 
along with those poster's IDs. Calculate the percentage from the number of poster's interests. The poster 
column in the dataset refers to the user that posted the comment.

*/


with clean_cols_cte as 
(
    select 
    poster,
    unnest(
        string_to_array(
            replace(replace(post_keywords, '[', ''), ']', ''), ','
        )
    ) as cleaned_keywords
    from 
    facebook_posts
    group by 1,2
)

select 
a.poster as poster1,  
b.poster as poster2,
count(distinct case when a.cleaned_keywords = b.cleaned_keywords then b.cleaned_keywords end)/count(distinct a.cleaned_keywords)::float as overlap
from 
clean_cols_cte as a
left join 
clean_cols_cte as b
on a.poster != b.poster
where 
b.poster is not null
and lower(b.cleaned_keywords) not like '%spam%'
and lower(a.cleaned_keywords) not like '%spam%'
group by 1,2
order by 1
