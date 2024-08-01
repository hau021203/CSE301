create database SaleManagement;
create table clients(
    Client_Number varchar(10),
    Client_Name varchar(25) not null,
    Address varchar(30),
    City varchar(30),
    Pincode int not null,
    Province char(25),
    Amount_Paid decimal(15,4),
    Amount_Due decimal(15,4),
    check(Client_Number like 'C%'),
    primary key(Client_Number)
);
create table product(
    Product_Number varchar(15),
    Product_Name varchar(25) not null unique,
    Quantity_On_Hand int not null,
    Quantity_Sell int not null,
    Sell_Price decimal(15,4) not null,
    Cost_Price decimal(15,4) not null,
    check(Product_Number like 'P%'),
    check(Cost_Price > 0),
    primary key(Product_Number)
);
create table Salesman(
    Salesman_Number varchar(15),
    Salesman_Name varchar(25) not null,
    Address varchar(30),
    City varchar(30),
    Pincode int not null,
    Province char(25) default('Viet Nam'),
    Salary decimal(15,4) not null,
    Sales_Target int not null,
    Target_Achieved int,
    Phone char(10) not null unique,
    check(Salesman_Number like 'S%'),
    check(Salary > 0),
    check(Sales_Target > 0),
    primary key(Salesman_Number)
);
CREATE TABLE SalesOrder (
    Order_Number VARCHAR(15),
    Order_Date DATE,
    Client_Number VARCHAR(15),
    Salesman_Number VARCHAR(15),
    Delivery_Status CHAR(15),
    Delivery_Date DATE,
    Order_Status VARCHAR(15),
    PRIMARY KEY (Order_Number),
    FOREIGN KEY (Client_Number) REFERENCES Clients(Client_Number),
    FOREIGN KEY (Salesman_Number) REFERENCES Salesman(Salesman_Number),
    CHECK (Order_Number LIKE 'O%'),
    CHECK (Client_Number LIKE 'C%'),
    CHECK (Salesman_Number LIKE 'S%'),
    CHECK (Delivery_Status IN ('Delivered', 'On Way', 'Ready to Ship')),
    CHECK (Delivery_Date > Order_Date),
    CHECK (Order_Status IN ('In Process', 'Successful', 'Cancelled'))
);
CREATE TABLE SalesOrderDetails (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    CHECK (Order_Number LIKE 'O%'),
    CHECK (Product_Number LIKE 'P%'),
    FOREIGN KEY (Order_Number) REFERENCES SalesOrder(Order_Number),
    FOREIGN KEY (Product_Number) REFERENCES Product(Product_Number)
);
