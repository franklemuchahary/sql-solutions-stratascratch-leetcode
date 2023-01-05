/*

https://platform.stratascratch.com/coding/2089-cookbook-recipes?code_type=1

You are given the table with titles of recipes from a cookbook and their page numbers. 
You are asked to represent how the recipes will be distributed in the book.
Produce a table consisting of three columns: left_page_number, left_title and right_title. 
The k-th row (counting from 0), should contain the number and the title of the page with the 
number 2 x k in the first and second columns respectively, and the title of the page 
with the number 2 x k + 1 in the third column.

Each page contains at most 1 recipe. If the page does not contain a recipe, the appropriate cell should 
remain empty (NULL value). Page 0 (the internal side of the front cover) is guaranteed to be empty.

*/

with possible_pages as 
(
    select 
    generate_series as left_page_number 
    from 
    generate_series(
        (select min(page_number) from cookbook_titles) - 1,
        (select max(page_number) from cookbook_titles) - 1
    )
    where generate_series%2=0
)

select 
*
from 
possible_pages as pp
left join 
(
    select 
    case when page_number%2!=0 then page_number - 1 else page_number end as left_page_number,
    --- logic used: max b/w a null and a valid value will give the valid value in postgres 
    max(case when page_number%2=0 then title end) as left_title,
    max(case when page_number%2!=0 then title end) as right_title
    from 
    cookbook_titles
    group by 1
) as lr_page
using(left_page_number)
order by 1
