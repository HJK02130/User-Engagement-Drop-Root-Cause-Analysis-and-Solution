SELECT STR_TO_DATE(DATE_FORMAT(created_at,'%Y-%m-%d'),'%Y-%m-%d') date, COUNT(user_id) all_users
FROM users
WHERE (DATE_FORMAT(created_at,'%Y-%m-%d') BETWEEN '2014-06-01' AND '2014-08-31')
GROUP BY STR_TO_DATE(DATE_FORMAT(created_at,'%Y-%m-%d'),'%Y-%m-%d')