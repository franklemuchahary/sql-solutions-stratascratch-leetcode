/*

https://platform.stratascratch.com/coding/9735-business-density-per-street?code_type=1


Find the average and highest number of businesses for all the streets in the dataset. 
Only consider streets with at least 5 businesses. Assume the street is extracted by 
choosing the second word from the business_address column. Use business_id as a way 
to count the number of unique businesses.

*/

select 
avg(count_businesses), 
max(count_businesses)
from 
(
    SELECT 
    lower((string_to_array(business_address, ' '))[2]) as street,
    count(distinct business_id) as count_businesses
    FROM 
    sf_restaurant_health_violations
    group by 1
) as a 
where count_businesses >= 5
