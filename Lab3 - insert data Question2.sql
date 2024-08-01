insert into employee values
	('123','Dinh','Ba','Tien','1995-1-9','Nam','30000','731 Tran Hung Dao Q1 TPHCM','333','5'),
	('333','Nguyen','Thanh','Tung','1945-12-8','Nam','40000','638 Nguyen Van Cu Q5 TPHCM','888','5'),
    ('453','Tran','Thanh','Tam','1962-7-31','Nam','25000','543 Mai Thi Luu Ba Dinh Ha Noi','333','5'),
    ('666','Nguyen','Manh','Hung','1952-9-15','Nam','38000','975 Le Lai P3 Vung Tau','333','5'),
    ('777','Tran','Hong','Quang','1959-3-29','Nam','25000','980 Le Hong Phong Vung Tau','987','4'),
    ('888','Vuong','Ngoc','Quyen','1927-10-10','Nu','55000','450 Trung Vuong My Tho TG',null,'1'),
    ('987','Le','Thi','Tam','1931-6-20','Nu','43000','291 Ho Van Hue Q.PN TPHCM','888','4'),
    ('999','Bui','Thuy','Vu','1958-7-19','Nam','25000','332 Nguyen Thai Hoc Quy Nhon','987','4');
select * from employee;
insert into department values
	(1,'Quan ly','888','1971-6-19'),
    (4,'Dieu hanh','777','1985-01-01'),
    (5,'Nghien cuu','333','1978-05-22')
    ;
select * from department;
insert into departmentaddress values
	(1,'TP HCM'),
    (4,'HA NOI'),
    (5,'NHA TRANG'),
    (5,'TP HCM'),
    (5,'VUNG TAU')
    ;
select * from departmentaddress;
insert into projects values
	 (1, 'San pham X', 'VUNG TAU', 5),
     (2, 'San pham Y', 'NHA TRANG', 5),
     (3, 'San pham Z', 'TP HCM', 5),
     (10, 'Tin hoc hoa', 'HA NOI', 4),
     (20, 'Cap Quang', 'TP HCM', 1),
     (30, 'Dao tao', 'HA NOI ', 4)
    ;
select * from projects;
insert into assignment values
	 ('123',1,22.5),
     ('123',2,7.5),
     ('123',3,10),
     ('333',10,10),
     ('333',20,10),
     ('453',1,20),
     ('453',2,20),
     ('666',3,40),
     ('888',20,0),
     ('987',20,15)
    ;
select * from assignment;
insert into relative values
	 ( '123', 'Chau', 'Nu', '1978-12-31', 'Con gai'),
     ( '123', 'Duy', 'Nam', '1978-1-1', 'Con trai'),
     ( '123', 'Phuong', 'Nu', '1957-5-5', 'Vo chong'),
     ( '333', 'Duong', 'Nu', '1948-5-3', 'Vo chong'),
     ( '333', 'Quang', 'Nu', '1976-4-5', 'Con gai'),
     ( '333', 'Tung', 'Nam', '1973-10-25', 'Con trai'),
     ( '987', 'Dang', 'Nam', '1932-2-29', 'Vo chong')
    ;
select * from relative;


ALTER TABLE employee
ADD FOREIGN KEY employee(manager_ID) references employee(employee_id);
ALTER TABLE employee
ADD FOREIGN KEY (department_ID) references department(departmentID);
describe employee;
-- 
ALTER TABLE department
ADD FOREIGN KEY (manager_ID) references employee(employee_ID);	
describe department;
-- 
ALTER TABLE departmentaddress
ADD FOREIGN KEY (department_ID) references department(departmentID);
describe departmentaddress;
-- 
ALTER TABLE projects
ADD FOREIGN KEY (department_ID) references department(departmentID) ;
describe projects;
-- 
ALTER TABLE assignment
ADD FOREIGN KEY (employee_ID) references employee(employee_ID);
ALTER TABLE assignment
ADD FOREIGN KEY (project_ID) references projects(project_ID);
describe assignment;
-- 
ALTER TABLE relative
ADD FOREIGN KEY (employee_ID) references employee(employee_ID) ;
describe relative;
