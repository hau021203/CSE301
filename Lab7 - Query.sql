delimiter //
create procedure name_customer(in in_name varchar(30))
begin
end
//
delimiter ;
-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman" table.
select city from clients 
union 
select city from salesman;
-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
select city from clients 
union all
select city from salesman;
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
select city from clients 
where city = 'Ho Chi Minh'
union 
select city from salesman
where city = 'Ho Chi Minh';
-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
select city from clients 
where city = 'Ho Chi Minh'
union all
select city from salesman
where city = 'Ho Chi Minh'; 
-- 5. SQL statement lists all Clients and salesman.
select * from clients;
select * from salesman;
SELECT 'Client' AS `type`, city,province,client_number, client_name
FROM Clients
UNION 
SELECT 'Salesman' AS `type`, city,province,salesman_number, salesman_name
FROM Salesman;
-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
SELECT 'Client' AS `type`, client_number id, client_name `name`,city
FROM Clients
where Clients.city = 'Hanoi'
UNION 
SELECT 'Salesman' AS `type`, salesman_number id, salesman_name `name`,city
FROM Salesman
where Salesman.city = 'Hanoi';
-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.
select id,`name`,count(*) total from
(SELECT 'Client' AS type, c.client_number id, c.client_name `name`
FROM Clients c
UNION 
SELECT 'Salesman' AS type, s.salesman_number id, s.salesman_name `name`
FROM Salesman s) as T 
inner join salesorder as T2 on T.ID = T2.Client_Number  or T.id = T2.Salesman_Number
group by id,`name`
having count(*) > 1
order by id;
select * from salesorder;

-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
select type,`name`,T2.Order_Number order_id  from
(SELECT 'Client' AS type, c.client_number id, c.client_name `name`
FROM Clients c
UNION 
SELECT 'Salesman' AS type, s.salesman_number id, s.salesman_name `name`
FROM Salesman s) as T 
inner join salesorder as T2 on T.ID = T2.Client_Number  or T.id = T2.Salesman_Number
order by order_id;
select * from salesman;
-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
select id,city from salesman;
SELECT  salesman_number id, city `city`, case when target_Achieved >= 60 then 'High Achieved' else 'Low Achieved' end 'Achieved'
FROM Salesman 
order by salesman_number;
-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
select id,city from salesman;
SELECT  Product_Number id, Product_Name `name`, case when Quantity_On_Hand >0 then 'More 5 pieces in Stock' else 'Less 5 pieces in Stock'end Quantity
FROM product 
order by id;
-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores.
Delimiter $$
CREATE PROCEDURE get_clients_by_city (IN inCity varchar(30))
Begin
Select * from clients where city = inCity;
End$$
Delimiter ;
call get_clients_by_city('Hanoi');
-- 12. Drop get_clients _by_city () procedure stores.
Drop procedure get_clients_by_city;
-- 13. Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”.
Delimiter $$
CREATE PROCEDURE update_delivery_status (IN in_order_number varchar(30))
Begin
update salesorder set delivery_status = 'On Way' where order_number = in_order_number;
End$$
Delimiter ;
call update_delivery_status('O20006');
call update_delivery_status('O20008');
select * from salesorder;
-- 14. Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
CREATE PROCEDURE total_quantity (IN in_product_number varchar(30))
Begin
select (Quantity_On_Hand+Quantity_Sell) from product where Product_Number = in_product_number;
End$$
Delimiter ;
call total_quantity('P1002');
select * from product;
Drop procedure total_quantity;
-- 15. Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
CREATE PROCEDURE update_remarks (IN in_salesman_number varchar(10), In in_new_remarks varchar(10))
Begin
update salesman set remarks = in_new_remarks where salesman_number = in_salesman_number;
End$$
Delimiter ;
call update_remarks('S001','bad');
select * from salesman;
-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
CREATE PROCEDURE find_clients (IN in_client_number varchar(10))
Begin
select * from clients where Client_Number = in_client_number;
End$$
Delimiter ;
call find_clients('C106');
select * from clients;
-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name,
-- salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman
-- table.
Delimiter $$
CREATE PROCEDURE salary_salesman (IN in_limit int)
Begin
select Salesman_Number,Salesman_Name,Salary from  salesman where Salary>15000 limit in_limit;
End$$
Delimiter ;
call salary_salesman(2);
call salary_salesman(4);
-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
CREATE PROCEDURE MAX ()
Begin
select Max(Salary) MAX_SALARY from salesman ;
End$$
Delimiter ;
call MAX;
-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder table.
Delimiter $$
CREATE PROCEDURE amount_of_order_status ()
Begin
select order_status,count(*) amount_of_order_status from salesorder 
group by Order_Status;
End$$
Delimiter ;
call amount_of_order_status;
select * from salesorder;
-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;
-- SALARY = 20000.
select * from salesman;
Delimiter $$
CREATE PROCEDURE amount_of_salary_with_condition_20000 ()
Begin
select 'salary > 20000' as type, sum(case when salary > 20000 then 1 else 0 end) amount_of_salesman from salesman
union
select 'salary = 20000' as type, sum(case when salary = 20000 then 1 else 0 end) amount_of_salesman from salesman
 union
select 'salary < 20000' as type, sum(case when salary < 20000 then 1 else 0 end) amount_of_salesman from salesman ;
End$$
Delimiter ;
call amount_of_salary_with_condition_20000;
-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
Delimiter $$
CREATE PROCEDURE total_sale_for_a_specific_salesman (IN id varchar(15) ,  out totalsales int)
Begin
select sum(Order_Quantity) into totalsales 
from  salesorder as t1,salesorderdetails t2
where t1.Order_Number= t2.Order_Number and t1.Salesman_Number = id;
End$$
Delimiter ;
set @totalsales = 0;
call total_sale_for_a_specific_salesman('S003' ,@totalsales);
drop PROCEDURE total_sale_for_a_specific_salesman;
select @totalsales;

select * from salesorder s
inner join salesorderdetails sod on s.Order_Number = sod.Order_Number
order by Salesman_Number;
-- 23. Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
describe product;

Delimiter $$
CREATE PROCEDURE add_new_product 
(IN 	in_product_number varchar(15), 
		in_product_name varchar(25),
        in_Quantity_On_Hand int,
        in_Quantity_Sell int,
        in_Sell_Price decimal(15,4),
        in_Cost_Price decimal(15,4))
Begin
insert into product (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price)
value(in_product_number,in_product_name,in_Quantity_On_Hand,in_Quantity_Sell,in_Sell_Price,in_Cost_Price);
End$$
Delimiter ;
select * from product;
call add_new_product('P1009','Mic',10,30,1000,800);
DELETE FROM product WHERE Product_Number = 'P1009';
-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
Delimiter $$
CREATE PROCEDURE total_order_value ()
Begin
select 'salary > 20000' as type, sum(case when salary > 20000 then 1 else 0 end) amount_of_salesman from salesman
union
select 'salary = 20000' as type, sum(case when salary = 20000 then 1 else 0 end) amount_of_salesman from salesman
 union
select 'salary < 20000' as type, sum(case when salary < 20000 then 1 else 0 end) amount_of_salesman from salesman ;
End$$
Delimiter ;
call amount_of_salary_with_condition_20000;
