SELECT DATE_FORMAT(DATE_SUB(occurred_at, INTERVAL WEEKDAY(occurred_at) DAY), '%Y-%m-%d') weekstart, action,
		COUNT(DISTINCT user_id) users_cnt
FROM emails
GROUP BY DATE_FORMAT(DATE_SUB(occurred_at, INTERVAL WEEKDAY(occurred_at) DAY), '%Y-%m-%d'), action
ORDER BY weekstart, action DESC