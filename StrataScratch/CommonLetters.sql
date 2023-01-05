/*

https://platform.stratascratch.com/coding/9823-common-letters?code_type=1

Find the top 3 most common letters across all the words from both the tables. 
Output the letter along with the number of occurrences and order records in 
descending order based on the number of occurrences.

*/

with all_letters as 
(
    select 
    lower(
        unnest(regexp_split_to_array(contents, ''))
    ) as letters
    from 
    google_file_store
    
    union all
    
    select 
    lower(
        unnest(regexp_split_to_array(concat(words1, ' ', words2), ''))
    ) as letters
    from 
    google_word_lists
)

select 
letters,
count(*) as n_occurences
from 
all_letters
where letters <> ' '
group by 1
order by 2 desc
limit 3
