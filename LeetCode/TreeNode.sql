/*
MySQL
https://leetcode.com/problems/tree-node/description/

Each node in the tree can be one of three types:
"Leaf": if the node is a leaf node.
"Root": if the node is the root of the tree.
"Inner": If the node is neither a leaf node nor a root node.
Write an SQL query to report the type of each node in the tree.

Input: 
+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+

Output: 
+----+-------+
| id | type  |
+----+-------+
| 1  | Root  |
| 2  | Inner |
| 3  | Leaf  |
| 4  | Leaf  |
| 5  | Leaf  |
+----+-------+

*/


select 
id, 
case 
when p_id is null then 'Root'
when p_id is not null and has_child is not null then 'Inner'
when p_id is not null and has_child is null then 'Leaf'
end as type
from 
(
    select 
    t1.id, t1.p_id,
    case when t2.p_id is not null then 1 else null end as has_child
    from 
    Tree as t1
    left join 
    (
        select distinct p_id from Tree 
    ) as t2
    on t1.id = t2.p_id
) as a
group by 1,2
