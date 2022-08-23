/*

https://platform.stratascratch.com/coding/2112-product-market-share?code_type=1

Write a query to find the Market Share at the Product Brand level for each Territory, for Time Period Q4-2021. 
Market Share is the number of Products of a certain Product Brand brand sold in a territory, divided by the 
total number of Products sold in this Territory.

Output the ID of the Territory, name of the Product Brand and the corresponding Market Share in percentages. 
Only include these Product Brands that had at least one sale in a given territory.

*/


with modified_base as 
(
    select 
    ct.territory_id,
    dp.prod_brand, 
    count(cs.prod_sku_id) as count_sku_prod_terr_level
    from 
    fct_customer_sales as cs
    left join
    map_customer_territory as ct
    using(cust_id)
    left join
    dim_product as dp
    using(prod_sku_id)
    where 
    extract(year from order_date) = 2021
    and extract(quarter from order_date) = 4
    and order_value >=0
    group by 1,2
    having count(cs.prod_sku_id) > 0
)


select 
a.territory_id,
a.prod_brand, 
(count_sku_prod_terr_level::float/count_sku_territory)*100 as market_share
from 
modified_base as a
inner join 
(
    select 
    territory_id, sum(count_sku_prod_terr_level) as count_sku_territory
    from 
    modified_base as a
    group by 1
) as b
using(territory_id)
