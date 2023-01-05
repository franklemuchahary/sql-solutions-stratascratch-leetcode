/*

https://platform.stratascratch.com/coding/9814-counting-instances-in-text?code_type=1

Find the number of times the words 'bull' and 'bear' occur in the contents. 
We're counting the number of times the words occur so words like 'bullish' should not be included in our count.
Output the word 'bull' and 'bear' along with the corresponding number of occurrences.

*/

--- solution using regex
select
unnest(regexp_matches(contents, '(bull|bear)', 'g')) as word, 
count(*) as nentry
from 
google_file_store
group by 1
order by 1 desc


--- solution without using regex
select 
*
from 
(
    select
    unnest(string_to_array(contents, ' ')) as word,
    count(*) as nentry
    from 
    google_file_store
    group by 1
    order by 1 desc
) as a 
where word in ('bull', 'bear')