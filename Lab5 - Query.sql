select * from salesorderdetails;
select * from salesman;
select * from salesorder;
select * from product;
select * from clients;

insert into Salesman values 
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');
insert into salesorder values 
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');
insert into salesorderdetails values
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

-- 1. Display the clients (name) who lives in same city.
SELECT * from clients where city in 
(select city from clients
group by City
having count(*)>1);
-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select Client_Name, Salesman_Name , c.city
from clients c
inner join salesman s on c.city =  s.City
where c.City = 'Thu Dau Mot';
-- 3. Display client name, client number, order number, salesman number, and product number for each order.
select c.Client_Name,c.Client_Number, so.Order_Number , so.Salesman_Number,sod.Product_Number
from clients c
inner join salesorder so on c.Client_Number = so.Client_Number
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number;
-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select c.Client_Number,c.Client_Name, so.Order_Number 
from clients c
inner join salesorder so on c.Client_Number = so.Client_Number;
-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by them.
select c.Client_Number, c.Client_Name, count(s.Client_Number) number_Of_Order
from clients c
inner join salesorder s on c.Client_Number = s.Client_Number
group by s.Client_Number ;
-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select c.Client_Number, c.Client_Name from clients c
inner join salesorder s on c.Client_Number = s.Client_Number
group by s.Client_Number
having count(s.Client_Number)>2;
-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select c.Client_Number, c.Client_Name from clients c
inner join salesorder s on c.Client_Number = s.Client_Number
group by s.Client_Number
having count(s.Client_Number)>1
order by c.Client_Number desc;
-- 8. Find the salesman names who sells more than 20 products.
select Salesman_Name from salesman s 
						inner join salesorder so on s.Salesman_Number = so.Salesman_Number
                        inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
 group by Salesman_Name
 having sum(Order_Quantity) > 20;
-- 9. Display the client information (client_number, client_name) and order number of those clients who have order status is cancelled.
select c.Client_Number,c.Client_Name,so.Order_Number from clients c 
inner join salesorder so on c.Client_Number = so.Client_Number
where so.Order_Status ='cancelled'
order by c.Client_Number;
-- 10. Display client name, client number of clients C101 and count the number of orders which were received “successful”.
select c.Client_Name, c.Client_Number, s.Order_Status, count(s.Order_Status) number_Order from salesorder s 
inner join clients c on c.Client_Number = s.Client_Number
group by s.Order_Status, c.Client_Number
having s.Order_Status ='successful' and c.Client_Number='C101';
-- 11. Count the number of clients orders placed for each product.
select p.Product_Number,p.Product_Name, count(sod.Order_Quantity) number_Of_Order from product p
inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
group by p.Product_Number;
-- 12. Find product numbers that were ordered by more than two clients then order in descending by product number.
select Product_Number,count(*) from
(select distinct Client_Number,Product_Number from salesorder o inner join salesorderdetails sod 
on o.Order_Number = sod.Order_Number ) as T
group by Product_Number
having count(*) > 2
order by count(*) desc;
-- b) Using nested query with operator (IN, EXISTS, ANY and ALL)
-- 13. Find the salesman’s names who is getting the second highest salary.
select Salesman_Name from salesman where Salary = (select Salary from salesman group by Salary order by Salary desc limit 1 offset 1);
-- 14. Find the salesman’s names who is getting second lowest salary.
select Salesman_Name from salesman where Salary = (select Salary from salesman group by Salary order by Salary limit 1 offset 1);
-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the salesman whose salesman number is S001.
select Salesman_Name,Salary from salesman where Salary > any(select Salary from salesman where Salesman_Number='S001');
select * from salesorder;

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select * from product;
select s.Salesman_Name from salesman s 
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
where exists 
(Select * from salesorderdetails sod where(so.Order_Number = sod.Order_Number) and sod.Product_Number='P1002')
group by s.Salesman_Name;
-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
select s.Salesman_Name from salesman s where exists(select * from salesorder so where 
(s.Salesman_Number= so.Salesman_Number) and 
so.Client_Number='C108' and so.Delivery_Status='delivered')  ;
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
select * from product p where p.Product_Number = any
(select sod.Product_Number from salesorderdetails sod where sod.Order_Quantity = 5);
-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select s.Salesman_Name,s.Salesman_Number from salesman s
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number=sod.Order_Number
where sod.Product_Number = any(select p.Product_Number from product p where p.Product_Name in ('pen','TV','laptop'))
group by s.Salesman_Number;
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand more than 50.
select s.Salesman_Name,s.Salesman_Number from salesman s
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number=sod.Order_Number
where sod.Product_Number = any(select p.Product_Number from product p where p.Sell_Price<800 and p.Quantity_On_Hand > 50)
group by s.Salesman_Number;
-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
select Salesman_Name,Salary from salesman where Salary > (select avg(Salary) from salesman);
-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.
select * from clients where Amount_Paid > (select avg(Amount_Paid) from clients);
-- II. Additional excersice:
-- 23. Find the product price that was sold to Le Xuan.
select p.Sell_Price from product p
inner join salesorderdetails sod on sod.Product_Number = p.Product_Number
inner join salesorder so on so.Order_Number=sod.Order_Number
where so.Client_Number = any(select c.Client_Number from clients c where c.Client_Name = 'Le Xuan')
group by p.Sell_Price;
-- 24. Determine the product name, client name and amount due that was delivered.
select p.Product_Name, c.Client_Name,c.Amount_Due from product p
inner join salesorderdetails sod on sod.Product_Number = p.Product_Number
inner join salesorder so on so.Order_Number=sod.Order_Number
inner join clients c on so.Client_Number=c.Client_Number
where so.Delivery_Status = 'delivered';
select * from salesorder;
-- 25. Find the salesman’s name and their product name which is cancelled.
select s.Salesman_Name, p.Product_Name from product p
inner join salesorderdetails sod on sod.Product_Number = p.Product_Number
inner join salesorder so on so.Order_Number=sod.Order_Number
inner join salesman s on so.Salesman_Number = s.Salesman_Number
where so.Order_Status = 'cancelled';
select * from salesorder;
-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
select p.Product_Name,p.Sell_Price,p.Cost_Price,so.Delivery_Status from product p
inner join salesorderdetails sod on sod.Product_Number = p.Product_Number
inner join salesorder so on so.Order_Number=sod.Order_Number
where so.Client_Number = any(select c.Client_Number from clients c where c.Client_Name = 'Nguyen Thanh ');
select * from clients;
-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information for each customer.
select c.Client_Name,p.Product_Name,p.Sell_Price,s.Salesman_Name,so.Delivery_Status,sod.Order_Quantity from clients c
inner join salesorder so on c.Client_Number = so.Client_Number
inner join salesman s on so.Salesman_Number = s.Salesman_Number
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
inner join product p on sod.Product_Number= p.Product_Number;
-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been successful but the items have not yet been delivered to the client.
-- 29. Find each clients’ product which in on the way.
select p.Product_Number,p.Product_Name,p.Sell_Price,p.Cost_Price from product p 
inner join salesorderdetails sod on p.Product_Number=sod.Product_Number
inner join salesorder so on sod.Order_Number = so.Order_Number
where so.Delivery_Status = 'On Way';
select * from salesorder;
-- 30. Find salary and the salesman’s names who is getting the highest salary.
select Salary,Salesman_Name from salesman where Salary = (select Salary from salesman group by Salary order by Salary desc limit 1 );
-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select Salary,Salesman_Name from salesman where Salary = (select Salary from salesman group by Salary order by Salary limit 1 offset 1);
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more than 9.
select * from product p where p.Product_Number = any
(select sod.Product_Number from salesorderdetails sod where sod.Order_Quantity > 9);
-- 33. Find the name of the customer who ordered the same item multiple times.
select * from salesorder;
select c.Client_Name,count(*) from clients c
inner join salesorder so on c.Client_Number = so.Client_Number
group by so.Client_Number
having count(*) >1;
-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average salary and works in any of Thu Dau Mot city.
select Salesman_Name,Salesman_Number,Salary from salesman where Salary < (select avg(Salary) from salesman) and
city = any(select city from salesman where city = 'Thu Dau Mot');
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to highest.
-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select Salary from salesman where Salary = (select Salary from salesman group by Salary order by Salary desc limit 1 offset 3);
-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select Salary from salesman where Salary = (select Salary from salesman group by Salary order by Salary desc limit 1 offset 2);

