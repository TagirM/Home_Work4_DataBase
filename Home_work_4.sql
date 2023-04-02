-- Задача 1. Подсчитать количество групп, в которые вступил каждый пользователь.

USE vk;
SELECT
	id,
	CONCAT(firstname, ' ', lastname) AS owner,
	COUNT(*)
FROM users AS u
JOIN users_communities AS uc ON u.id = uc.user_id
GROUP BY u.id
ORDER BY id;


-- Задача 2. Подсчитать количество пользователей в каждом сообществе.

USE vk;
SELECT
	COUNT(*) AS count_users,
	communities.name
FROM users_communities 
JOIN communities ON users_communities.community_id = communities.id
GROUP BY communities.id;


/* Задача 3. Пусть задан некоторый пользователь. 
Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений). */

USE vk;
SELECT
	from_user_id, 
    CONCAT(u.firstname, ' ', u.lastname) AS user_name, 
    COUNT(*) AS messages_count
FROM messages AS m
JOIN users AS u ON u.id = m.from_user_id
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Задача 4*. Подсчитать общее количество лайков, которые получили пользователи младше 18 лет.

USE vk;
SELECT COUNT(*)
FROM likes
WHERE media_id IN (
	SELECT id 
	FROM media 
	WHERE user_id IN (
		SELECT 
			user_id		
		FROM profiles AS p
		WHERE YEAR(CURDATE()) - YEAR(birthday) < 18
	)
);


-- Задача 5*. Определить кто больше поставил лайков (всего): мужчины или женщины.

USE vk;
SELECT 
	gender, 
    COUNT(*)
FROM (
	SELECT 
		user_id AS user,
		(
			SELECT gender 
			FROM vk.profiles
			WHERE user_id = user
		) AS gender
	FROM likes
) AS t
GROUP BY gender
LIMIT 1;