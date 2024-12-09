--NODE46
--MSQL sẽ không phân biệt chữ hoa chữ thường 
--Nhưng mình nên sử dụng chữ hoa 
--Dấu chấm phẩy ";" để kết thúc dòng 
--Đặt tên cho table nên tránh những từ trùng với lệnh mysqul 
--Nếu vẫn muốn sử dụng thì sẽ kẹp với backtic(``)
--thêm chữ "s" ngay sau tên table 
-- CSDL
-- tạo database 
CREATE DATABASE demo_database;
CREATE DATABASE IF NOT EXISTS demo_database
USE demo_database
--Table
CREATE TABLE IF NOT EXISTS users (
	users_id INT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	age INT,
	birth_day DATE,
	money DOUBLE,
	is_active BOOLEAN
)
--Đổi tên table
RENAME TABLE users to users_rename
--Xoá table 
DROP TABLE users_rename
DROP TABLE IF NOT EXISTS users_rename
--Ràng buộc 

--not null
CREATE TABLE not_null(
	id INT NOT NULL,
	age INT
)
-- Unique 
CREATE TABLE uniques (
	id INT UNIQUE
)
--Default 
CREATE TABLE defaults (
	id INT NOT NULL UNIQUE,
	role VARCHAR(255) DEFAULT 'ROLE_USER',
	create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
-- Khoá chính :Primary Key
-- định vị 1 dữ liệu,tránh việc bị trùng lặp 
CREATE TABLE primary_key (
	id BIGINT PRIMARY KEY AUTO_INCREMENT 
)
-- khoá phụ :foreign key 
-- tham chiếu tới khoá chính 
CREATE TABLE FOREIGN_KEY(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	
	foreign_key BIGINT,
	
	FOREIGN KEY( foreign_key ) REFERENCES primary_key(id)
)
-- thêm dữ liệu vào table 
 INSERT INTO users (users_id,full_name,email,age,birth_day,money,is_active ) VALUES
					(1,'huy 1','huy@gmail.com',19,'2005-06-04',150000,TRUE),
					(2,'huy 2','huy@gmail.com',19,'2005-06-04',50000,TRUE),
					(3,'huy 3','huy@gmail.com',19,'2005-06-04',250000,TRUE)
-- update dữ liệu 
UPDATE users 
SET money = 12345
WHERE users_id=1 
-- xoá dữ liệu 
DELETE FROM users
WHERE users_id=2
TRUNCATE users 
-- truy vấn



CREATE DATABASE db_app_food 

CREATE TABLE users (
	users_id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	pass_word VARCHAR(255)
)

INSERT INTO users(full_name,email,pass_word) VALUES
			('Nguyen Van A','a@gmail.com','1234'),
			('Nguyen Van B','a@gmail.com','1234'),
			('Nguyen Van C','a@gmail.com','1234'),
			('Nguyen Van D','a@gmail.com','1234'),
			('Nguyen Van E','a@gmail.com','1234')
			
SELECT * FROM users 
SELECT full_name AS 'Họ và tên',email 'email người dùng' FROM users 

--Limit :giới hạn số lượng kết quả trả về ( bắt đầu từ index 0)
SELECT * FROM users 
LIMIT 2 OFFSET 1

CREATE TABLE foods (
	food_id INT PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR (255),
	description VARCHAR (255)
)

INSERT INTO foods(food_name,description) VALUES
('su kem','bánh được làm từ kem'),
('gỏi gà ','bánh được làm từ gà'),
('gỏi vịt','bánh được làm từ vịt'),
('gỏi cá','bánh được làm từ cá'),
('gỏi heo','bánh được làm từ heo')

CREATE TABLE orders (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	users_id INT,
	food_id INT,
	FOREIGN KEY (users_id) REFERENCES users(users_id),
	FOREIGN KEY (food_id) REFERENCES foods(food_id)
)
INSERT INTO orders(users_id,food_id) VALUES
(1,2),
(3,4),
(2,5),
(1,3),
(3,2)

SELECT * FROM orders








-- mối quan hệ 1-1 [one to one]
-- mô tả : một hàng của bảng này chỉ liên kết với một hàng của bảng khác 
-- mối quan hệ 1-nhiều [one to many]
-- mô tả : một hàng của bảng A có thể liên kết tới nhiều hàng của bảng b 
-- mối quan hệ nhiều-nhiều [many to many]
-- mô tả : nhiều hàng của bảng A có thể liên kết tới nhiều hàng của bảng B

-- INNER JOIN 
-- trả về kết quả giống nhau của hai bảng 
SELECT * 
FROM orders 
INNER JOIN users ON users.users_id=orders.users_id
INNER JOIN users ON orders.users_id=users.users_id

-- Left join
-- trả về kết quả giống nhau của hai bảng và bao gồm tất cả dữ liệu bên trái 
SELECT *
FROM users
LEFT JOIN orders ON orders.users_id=users.users_id
-- right join
-- trả về kết quả giống nhau của hai bảng và bao gồm tất cả dữ liệu bên phải
SELECT *
FROM users
RIGHT JOIN orders ON orders.users_id=users.users_id
-- cross join 
SELECT *
FROM users
CROSS JOIN orders 
-- group by :nhóm những hàng có cùng giá trị lại với nhau 
-- thường dùng kết hợp với sum count max min 
SELECT users.users_id,users.full_name,users.pass_word, COUNT(users.users_id) AS 'Số lượng user'
FROM orders 
INNER JOIN users ON users.users_id=orders.users_id
GROUP BY users.users_id
-- order by :sắp xếp từ lớn tới bé hoặc từ bé tới lớn 
-- tăng dần :ASC
-- giảm dần :DESC
SELECT users.users_id,users.full_name,users.pass_word, COUNT(users.users_id) AS 'Số lượng user'
FROM orders 
INNER JOIN users ON users.users_id=orders.users_id
GROUP BY users.users_id
ORDER BY users.users_id DESC
-- tìm 5 người đã like nhà hàng nhiều nhất 
SELECT orders.users_id,users.*,COUNT(orders.users_id) AS 'Số lần mua'
FROM orders
INNER JOIN users ON orders.users_id=users.users_id
GROUP BY orders.users_id
ORDER BY `Số lần mua` DESC
LIMIT 5
-- tìm 2 nhà hàng có lượt like nhiều nhất 
SELECT COUNT(orders.food_id) AS'Số lần được mua nhiều nhất',orders.food_id,foods.*
FROM orders
INNER JOIN foods ON orders.food_id=foods.food_id
GROUP BY orders.food_id
ORDER BY `Số lần được mua nhiều nhất` DESC
LIMIT 2
-- tìm người dùng không đặt hàng trong hệ thống 
-- không đặt hàng,không like,không đánh giá nhà hàng 
SELECT * 
FROM orders
RIGHT JOIN users ON orders.users_id=users.users_id
WHERE orders.users_id IS NULL 


