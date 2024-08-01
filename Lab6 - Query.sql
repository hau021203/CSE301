
-- 1. How to check constraint in a table?
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'product';
describe product;
SET SQL_SAFE_UPDATES = 0;
-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information
-- about product name and its buying price.
create table ProductCost(
Product_Name varchar(25),
Sell_Price decimal(15,4) not null,
primary key(Product_Name)
);
insert into productcost (Product_Name,Sell_Price)
select Product_Name,Sell_Price from product;
select * from productcost;
-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter table product add column profit float;
update product set profit = (sell_price - cost_price)/cost_price*100;
select * from product;
-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
select * from salesman;
select *, case when Target_Achieved >= Sales_Target*0.75 then 'Good' end 'Sale_status' from salesman;
-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
select *, case when Target_Achieved < Sales_Target*0.75 and Target_Achieved >= Sales_Target*0.5 then 'Average'  end 'Sale_status' from salesman;
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
select *, case when Target_Achieved < Sales_Target*0.5 then 'Poor' end 'Sale_status' from salesman;
-- 7. Find the total quantity for each product. (Query)
select *,(Quantity_On_Hand + Quantity_Sell) from product ;
-- 8. Add a new column and find the total quantity for each product.
alter table product add column total_quantity int;
update product set total_quantity = (Quantity_On_Hand + Quantity_Sell);
select * from product;
-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
select * from product;
alter table product add column discount float;
select *, case when Quantity_On_Hand>10 then 0.1 else 0.05 end 'discount-rate' from product;
update product set discount = case when Quantity_On_Hand>10 then '0.1' else '0.05' end ;
-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is
-- between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
select *, case when Quantity_On_Hand>=20 then 0.1 else 
case when Quantity_On_Hand<20 and Quantity_On_Hand>=10 then 0.05 else 
case when Quantity_On_Hand>5 then 0.03 else 0 end end end 
'discount-rate' from product;
update product set discount = case when Quantity_On_Hand>=20 then 0.1 else 
case when Quantity_On_Hand<20 and Quantity_On_Hand>=10 then 0.05 else 
case when Quantity_On_Hand>5 then 0.03 else 0 end end end;
-- 11. The first number of pin code in the client table should be start with 7.
select * from clients;
insert into clients  values('C101','Mai Xuan',	'Phu Hoa','Dai An',	800001	,'Binh Duong',	10000.0000	,5000.0000);
alter table clients add check (Pincode like '7%');
-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
create view clients_view as select * from clients where city='Thu Dau Mot';
select * from clients_view;
-- 13. Drop the “client_view”.
drop view clients_view;
-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
select * from salesorder;
create view clients_order as select c.*,so.Order_Number,so.Order_Date,so.Salesman_Number,so.Delivery_Status,so.Delivery_Date,so.Order_Status from clients c
inner join salesorder so on c.Client_Number=so.Client_Number
 where city='Thu Dau Mot';
 select * from clients_order;
-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average sell price.
select * from product where Sell_Price > (select avg(Sell_Price) from product);
create view product_view as select * from product where Sell_Price > (select avg(Sell_Price) from product);
 select * from product_view;
-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,
-- product price, quantity order) were sold by them.
select * from salesorder;
select * from salesman;
select * from salesorderdetails;
create view salesman_view as select s.*,p.Product_Name,p.Sell_Price,p.Cost_Price,sod.Order_Quantity 
from salesman s
inner join salesorder so on s.Salesman_Number=so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number=sod.Order_Number
inner join product p on p.Product_Number=sod.Product_Number;
select * from salesman_view;
-- 17. Creates a view name as sale_view that show all salesman information and product (product names,
-- product price, quantity order) were sold by them with order_status = 'Successful'.
create view sale_view as select s.*,p.Product_Name,p.Sell_Price,p.Cost_Price,sod.Order_Quantity 
from salesman s
inner join salesorder so on s.Salesman_Number=so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number=sod.Order_Number
inner join product p on p.Product_Number=sod.Product_Number
where so.Order_Status='Successful';
select * from sale_view;
-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
create view sale_amount_view as select s.*,sum(sod.Order_Quantity) total
from salesman s
inner join salesorder so on s.Salesman_Number=so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number=sod.Order_Number
where so.Order_Status='Successful'
group by sod.Order_Number
having total >= 20 ;
drop view sale_amount_view;
select * from sale_amount_view;
-- II. Additional assignments about Constraint
-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
select * from Clients;
insert into clients  values('C101','Mai Xuan',	'Phu Hoa','Dai An',	800001	,'Binh Duong',	0	,-100);
alter table clients add check (Amount_paid >= 0 and amount_due >= 0);
-- 20. Remove the constraint from pincode;
alter table clients drop constraint clients_chk_2;
insert into clients  values('C111','Trung Hau',	'Phu Cuong','Thu Dau Mot',	800001	,'Binh Duong',	10000.0000	,5000.0000);
delete from clients where Client_Number ='C111';
-- 21. The sell price and cost price should be unique.
describe product;
alter table product add unique(sell_price);
alter table product add unique(cost_price);
-- 22. The sell price and cost price should not be unique.
alter table product drop index sell_price;
alter table product drop index cost_price;
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'product';
select * from product;
-- 23. Remove unique constraint from product name.
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'product';
alter table product drop index product_name;
-- 24. Update the delivery status to “Delivered” for the product number P1007.
select *,case when sod.Product_Number = 'P1007' then 'Delivered' end 'Status' from salesorder so 
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
where sod.Product_Number = 'P1007';
update salesorder inner join salesorderdetails on salesorder.Order_Number = salesorderdetails.Order_Number set 
salesorder.Delivery_Status =  'Delivered' where salesorderdetails.Product_Number = 'P1007';
-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
update clients set Address = 'Phu Hoa',City= 'Thu Dau Mot' where Client_Number='C104';
select * from clients ;
-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
select * from product;
alter table product add column Exp_Date Date;
describe product;
-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table clients add column Phone varchar(15);
describe clients;
-- 28. Update remarks as “Good” for all salesman.
select * from salesman;
alter table salesman add column remarks varchar(10);
update salesman set remarks = 'Good';
-- 29. Change remarks to "bad" whose salesman number is "S004".
update salesman set remarks= 'bad' where salesman.Salesman_Number = 'S004';
-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table clients modify column Phone varchar(10);
describe clients;
-- 31. Delete the “Phone” column from “Clients” table.
alter table clients drop column Phone ;
-- 32. alter table Clients drop column Phone;
alter table clients drop column Phone ;
select * from clients;
-- 33. Change the sell price of Mouse to 120.
select * from product;
update product set product.Sell_Price = 120 where product.Product_Name = 'Mouse'; 
-- 34. Change the city of client number C104 to “Ben Cat”.
update clients set City = 'Ben Cat' where Client_Number='C104';
-- 35. If On_Hand_Quantity greater than 5, then 10% discount. 
-- If On_Hand_Quantity greater than 10, then 15% discount. Othrwise, no discount.
select * from product;
update product set discount = case when Quantity_On_Hand > 10 then 0.15 else case when Quantity_On_Hand > 5 then 0.1 else 0 end end;
select *,case when Quantity_On_Hand > 10 then 0.15 else case when Quantity_On_Hand > 5 then 0.1 else 0 end end 'status' from product;
