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
