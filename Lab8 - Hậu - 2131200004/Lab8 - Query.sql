
-- 7
delimiter //
create trigger check_pincode_clients
before insert on clients
for each row
begin
	if New.Pincode <> 7 then
	return false;
    end if;
end
//
delimiter ;
insert into salesman(Salesman_Number,Salesman_Name,Pincode,Salary,Sales_Target,Phone) 
value ('S009','Hau',700001,15000,30,0328982605);
delete from salesman where Salesman_Number = 'S009';
drop trigger check_pincode_clients;
select * from clients;
describe clients;



-- a) TRIGGER
-- 1. Create a trigger before_total_quantity_update to update total quantity of product when
-- Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004
-- have Quantity_On_Hand = 30, quantity_sell =35.
delimiter //
create trigger before_total_quantity_update
before update on product
for each row
begin
	if(Old.Quantity_On_hand <> New.Quantity_On_hand) or (Old.Quantity_Sell <> New.Quantity_Sell) then
	set new.total_Quantity = (New.Quantity_On_hand +New.Quantity_Sell);
    end if;
end
//
delimiter ;
update product set Quantity_On_Hand = 30, Quantity_Sell = 35 where Product_Number = 'P1004';
drop trigger before_total_quantity_update;
select * from product;
-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
select * from salesman;
alter table salesman add column PER_MARKS decimal(15,4);
update salesman set Per_marks = (Target_Achieved* 100/Sales_Target);
delimiter //
create trigger before_remark_salesman_update
before update on salesman
for each row
begin
	if(Old.Target_Achieved <> New.Target_Achieved) or (Old.Sales_Target <> New.Sales_Target) then
	set new.Per_marks = (New.Target_Achieved* 100/New.Sales_Target);
    end if;
end
//
delimiter ;
update salesman set Target_Achieved = 50,Sales_Target = 20 where Salesman_Number ='S001';
drop trigger before_remark_salesman_update;
-- 3. Create a trigger before_product_insert to insert a product in product table.
delimiter //
create trigger before_product_insert
before insert on product
for each row
begin
	Insert into product(Product_Number,Product_Name,Quantity_On_Hand,Quantity_Sell,Sell_Price,Cost_Price)
    values (new.Product_Number,new.Product_Name,new.Quantity_On_Hand,new.Quantity_Sell,new.Sell_Price,150.0000);
end
//
delimiter ;
insert into product(Product_Number,Product_Name,Quantity_On_Hand,Quantity_Sell,Sell_Price,Cost_Price) 
values ('P1009','Pin',20,10,200.0000,150.0000);
drop trigger before_product_insert;
select * from product;
-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as "Successful".
delimiter //
create trigger before_update_delivery_status
before update on salesorder
for each row
begin
	if New.Delivery_Status='Delivered' then
	set new.Order_Status = 'Successful';
    end if;
end
//
delimiter ;
drop trigger before_update_delivery_status;
update salesorder set Delivery_Status = 'Delivered' where Order_Number ='O20005';
-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted.
delimiter //
create trigger before_salesman_insert
before insert on salesman
for each row
begin
	set new.remarks = 'Good';
end
//
delimiter ;
insert into salesman(Salesman_Number,Salesman_Name,Pincode,Salary,Sales_Target,Phone) 
value ('S009','Hau',700001,15000,30,0328982605);
delete from salesman where Salesman_Number = 'S009';
drop trigger before_salesman_insert;
select * from salesman;
describe salesman;
-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.
delimiter //
create trigger check_pincode_clients
before insert on clients
for each row
begin
	if new.pincode <> '7_' then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PIN code must start with the digit 7';
    end if;
end
//
delimiter ;
drop trigger check_pincode_clients;
insert into clients(Client_Number,Client_Name,Pincode) 
value ('C111','Hau',700001);
delete from clients where client_Number = 'C111';
select * from clients;
describe clients;
-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product table.
delimiter //
create trigger update_product
after insert on product
for each row
begin
	update product set profit = (new.Sell_Price-new.Cost_Price)/new.Cost_Price*100;
    update product set total_quantity= new.Quantity_On_Hand+new.Quantity_Sell;
end
//
delimiter ;
drop trigger check_pincode_clients;
insert into product(Product_Number,Product_Name,Quantity_On_Hand,Quantity_Sell,Sell_Price,Cost_Price) 
value ('P1009','tem',10,20,200,100);
select * from product;
-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be ‘Good’.
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered 'Poor'.
delimiter //
CREATE TRIGGER before_remark_salesman_update
BEFORE UPDATE ON salesman
FOR EACH ROW
BEGIN
    update salesman set remarks = case when NEW.PER_MARKS >= 75 THEN
          'Good'
    Else case when NEW.PER_MARKS >= 50 AND NEW.PER_MARKS < 75 THEN
        'Average'
    ELSE
         'Poor'
    end end ;
END
//
delimiter ;
select * from salesman;
-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
delimiter //
CREATE TRIGGER check_delivery_date
BEFORE INSERT ON salesorder
FOR EACH ROW
BEGIN
    IF NEW.delivery_date <= NEW.order_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delivery date must be greater than order date';
    END IF;
END
//
delimiter ;
select * from salesorder;
-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity).
-- b) Writing Function:
-- 1. Find the average salesman’s salary.
delimiter //
create function find_average ()
returns int
DETERMINISTIC
begin
	declare AVERAGE int;
	SELECT AVG(SALARY) into AVERAGE FROM SALESMAN;
    RETURN AVERAGE;
END
//
delimiter ;
select find_average();
drop function find_average;
-- 2. Find the name of the highest paid salesman.
delimiter //
create function find_highest_paid ()
returns varchar(25)
DETERMINISTIC
begin
	declare highest_Paid_Name varchar(25);
	SELECT salesman_name into highest_Paid_Name FROM SALESMAN order by salary desc limit 1;
    RETURN highest_Paid_Name;
END
//
delimiter ;
select find_highest_paid();
drop function find_highest_paid;
select * from salesman;
describe salesman;
-- 3. Find the name of the salesman who is paid the lowest salary.
delimiter //
create function find_lowest_paid ()
returns varchar(25)
DETERMINISTIC
begin
	declare highest_Paid_Name varchar(25);
	SELECT salesman_name into highest_Paid_Name FROM SALESMAN order by salary limit 1;
    RETURN highest_Paid_Name;
END
//
delimiter ;
select find_lowest_paid();
drop function find_lowest_paid;
select * from salesman;
describe salesman;
-- 4. Determine the total number of salespeople employed by the company.
delimiter //
create function total_number_salespeople ()
returns int
DETERMINISTIC
begin
	declare total_number_salespeople int;
	SELECT count(*) into total_number_salespeople FROM SALESMAN ;
    RETURN total_number_salespeople;
END
//
delimiter ;
select total_number_salespeople();
drop function total_number_salespeople;
select * from salesman;
describe salesman;
-- 5. Compute the total salary paid to the company's salesman.
delimiter //
create function total_salary_salespeople ()
returns int
DETERMINISTIC
begin
	declare total_salary_salespeople int;
	SELECT sum(salary) into total_salary_salespeople FROM SALESMAN ;
    RETURN total_salary_salespeople;
END
//
delimiter ;
select total_salary_salespeople();
drop function total_salary_salespeople;
select * from salesman;
describe salesman;
-- 6. Find Clients in a Province

-- 7. Calculate Total Sales
delimiter //
create function total_sales_salespeople ()
returns int
DETERMINISTIC
begin
	declare total_sales_salespeople int;
	SELECT sum(Target_Achieved) totalsales into total_sales_salespeople FROM SALESMAN ;
    RETURN total_sales_salespeople;
END
//
delimiter ;
select total_sales_salespeople();
drop function total_salary_salespeople;
select * from salesman;
describe salesman;
-- 8. Calculate Total Order Amount
delimiter //
create function total_order_amount ()
returns int
DETERMINISTIC
begin
	declare total_order_amount int;
	SELECT sum(Order_Quantity) into total_order_amount FROM salesorderdetails ;
    RETURN total_order_amount;
END
//
delimiter ;
select total_order_amount();
drop function total_order_amount;
select * from salesorderdetails;
