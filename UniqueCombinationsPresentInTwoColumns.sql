/*

This is a "trick" to solve a specific kind of problem that might be useful in some common situations.
User https://dbfiddle.uk/?rdbms=postgres_14 to paste the DDL and DML queries to try out the solution query.

Given a table like the following 

+----+-----------+-----------+
|    | city_a    | city_b    |
|----+-----------+-----------|
|  0 | Delhi     | Bombay    |
|  1 | Bombay    | Delhi     |
|  2 | Bangalore | Pune      |
|  3 | Mumbai    | Bangalore |
|  4 | Calcutta  | Nagpur    |
|  5 | Bangalore | Mumbai    |
|  6 | Pune      | Nashik    |
|  7 | Nashik    | Pune      |
+----+-----------+-----------+

Find all the unique combination of city_a and city_b that exist 
For example, entries like Delhi-Bombay and Bombay-Delhi should appear only once

Expected Output:

+----+--------------+----------------+--------------------+
|    | first_city   | first_city.1   |   count_occurences |
|----+--------------+----------------+--------------------|
|  0 | Delhi        | Bombay         |                  2 |
|  1 | Mumbai       | Bangalore      |                  2 |
|  2 | Pune         | Nashik         |                  2 |
|  3 | Nagpur       | Calcutta       |                  1 |
|  4 | Pune         | Bangalore      |                  1 |
+----+--------------+----------------+--------------------+

*/

#########################################################
###### DML and DDL Part for Generating Sample Data ######
#########################################################

select version();

drop table if exists table2;

create table table2 (
 city_a varchar(255),
 city_b varchar(255)
 );


insert into 
  table2 (city_a, city_b) 
values
('Delhi', 'Bombay'),
('Bombay', 'Delhi'),
('Bangalore', 'Pune'),
('Mumbai', 'Bangalore'),
('Calcutta', 'Nagpur'),
('Bangalore', 'Mumbai'),
('Pune', 'Nashik'),
('Nashik', 'Pune')
;


############################
###### Solution Query ######
############################

select * from table2;


select 
case 
when city_a > city_b then city_a
else city_b 
end as first_city,
case 
when city_a > city_b then city_b
else city_a 
end as second_city,
count(*) as count_occurences
from 
table2
group by 1,2
order by 3 desc,1,2




############ works for numbers too ###############

drop table if exists table2;

create table table2 (
  num_a varchar(255),
  num_b varchar(255)
);


insert into 
  table2 (num_a, num_b) 
values
('1.0', '2.0'),
('2.0', '1.0'),
('10.0', '12.0'),
('11.0', '10.0'),
('11.0', '121.0'),
('121.0', '11.0'),
('100.0', '50.0'),
('50.0', '10.0')
;

select * from table2;


select 
case 
when num_a > num_b then num_a
else num_b 
end as first_num,
case 
when num_a > num_b then num_b
else num_a 
end as second_num,
count(*) as count_occurences
from 
table2
group by 1,2
order by 3 desc,1,2
