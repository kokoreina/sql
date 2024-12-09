CREATE DATABASE IF NOT EXISTS restaurant_app;
USE restaurant_app;

-- Bảng user
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    PRIMARY KEY (user_id)
);
INSERT INTO users (user_id, full_name, email, password)
VALUES
(1, 'Nguyen Van A', 'a@gmail.com', 'password1'),
(2, 'Le Thi B', 'b@gmail.com', 'password2'),
(3, 'Tran Van C', 'c@gmail.com', 'password3'),
(4, 'Pham Thi D', 'd@gmail.com', 'password4'),
(5, 'Hoang Van E', 'e@gmail.com', 'password5');
-- Bảng restaurant
CREATE TABLE restaurant (
    res_id INT AUTO_INCREMENT,
    res_name VARCHAR(255),
    image VARCHAR(255),
    `desc` VARCHAR(500),
    PRIMARY KEY (res_id)
);
INSERT INTO restaurant (res_id, res_name, image, `desc`)
VALUES
(1, 'Restaurant A', 'image_a.jpg', 'Delicious food'),
(2, 'Restaurant B', 'image_b.jpg', 'Best services'),
(3, 'Restaurant C', 'image_c.jpg', 'Affordable price'),
(4, 'Restaurant D', 'image_d.jpg', 'Great location');
-- Bảng food_type
CREATE TABLE food_type (
    type_id INT AUTO_INCREMENT,
    type_name VARCHAR(255),
    PRIMARY KEY (type_id)
);
INSERT INTO food_type (type_id, type_name)
VALUES
(1, 'Fast Food'),
(2, 'Vegetarian'),
(3, 'BBQ'),
(4, 'Seafood');
-- Bảng food
CREATE TABLE food (
    food_id INT AUTO_INCREMENT,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(500),
    type_id INT,
    PRIMARY KEY (food_id),
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);
INSERT INTO food (food_id, food_name, image, price, `desc`, type_id)
VALUES
(1, 'Burger', 'burger.jpg', 50.0, 'Tasty beef burger', 1),
(2, 'Salad', 'salad.jpg', 30.0, 'Fresh green salad', 2),
(3, 'Grilled Chicken', 'chicken.jpg', 70.0, 'Spicy grilled chicken', 3),
(4, 'Shrimp', 'shrimp.jpg', 100.0, 'Delicious shrimp', 4);
-- Bảng sub_food
CREATE TABLE sub_food (
    sub_id INT AUTO_INCREMENT,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    PRIMARY KEY (sub_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);
INSERT INTO sub_food (sub_id, sub_name, sub_price, food_id)
VALUES
(1, 'Extra Cheese', 10.0, 1),
(2, 'Extra Dressing', 5.0, 2),
(3, 'Extra Spices', 7.0, 3);
-- Bảng order
CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);
INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id)
VALUES
(1, 1, 2, 'ORD123', '1,2'),
(2, 3, 1, 'ORD124', '3'),
(3, 4, 1, 'ORD125', '2'),
(3, 2, 3, 'ORD126', '2');
-- Bảng rate_res
CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);
INSERT INTO like_res (user_id, res_id, date_like)
VALUES
(1, 1, '2024-01-01'),
(2, 1, '2024-01-02'),
(1, 2, '2024-01-03'),
(3, 2, '2024-01-04'),
(2, 3, '2024-01-05'),
(4, 4, '2024-01-06');
-- Bảng like_res
CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    PRIMARY KEY (user_id, res_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);
INSERT INTO rate_res (user_id, res_id, amount, date_rate)
VALUES
(1, 1, 5, '2024-01-01'),
(2, 2, 4, '2024-01-02'),
(3, 3, 3, '2024-01-03'),
(4, 4, 5, '2024-01-04');

-- Tìm 5 người like nhà hàng nhiều nhất 
SELECT `user`.*, COUNT(res_id) AS total_likes
FROM like_res
INNER JOIN `user` ON like_res.user_id=`user`.user_id
GROUP BY user_id
ORDER BY total_likes DESC
LIMIT 5;
-- Tìm 2 nhà hàng có lượt like nhiều nhất 
SELECT restaurant.*, COUNT(user_id) AS total_likes
FROM like_res
INNER JOIN restaurant ON like_res.res_id=restaurant.res_id
GROUP BY res_id
ORDER BY total_likes DESC
LIMIT 2;
-- Tìm người đã đặt hàng nhiều nhất 
SELECT `user`.*, COUNT(food_id) AS total_orders
FROM `order`
INNER JOIN `user` ON `order`.user_id=`user`.user_id
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 1;
-- Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng):
SELECT u.*
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res l ON u.user_id = l.user_id
LEFT JOIN rate_res r ON u.user_id = r.user_id
WHERE o.user_id IS NULL
  AND l.user_id IS NULL
  AND r.user_id IS NULL;