WITH test AS(
	SELECT DATE_FORMAT(engagement_date_start, '%Y-%m-%d') engagement_date_start, age, COUNT(DISTINCT user_id) engagement_active_user_cnt
	FROM (
		SELECT users.user_id user_id, users.created_at signup_date, events.occurred_at engagement_date, DATE_SUB(events.occurred_at, INTERVAL WEEKDAY(events.occurred_at) DAY) engagement_date_start,
			(CASE WHEN DATEDIFF('2014-09-01', users.created_at)>=70 THEN '10+ weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 63 AND 69 THEN '9 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 56 AND 62 THEN '8 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 49 AND 55 THEN '7 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 42 AND 48 THEN '6 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 35 AND 41 THEN '5 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 28 AND 34 THEN '4 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 21 AND 27 THEN '3 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 14 AND 20 THEN '2 weeks'
				 WHEN DATEDIFF('2014-09-01', users.created_at) BETWEEN 7 AND 13 THEN '1 weeks'
				 ELSE 'less than a week'
				 END) age
		FROM events INNER JOIN users ON (events.user_id=users.user_id)
		WHERE events.event_type='engagement' AND events.event_name='login' AND 
				events.occurred_at>=STR_TO_DATE('2014-05-01', '%Y-%m-%d') AND events.occurred_at<STR_TO_DATE('2014-09-01', '%Y-%m-%d') AND
				users.state='active'
	) temp
	GROUP BY DATE_FORMAT(engagement_date_start, '%Y-%m-%d'), age
	ORDER BY DATE_FORMAT(engagement_date_start, '%Y-%m-%d')
)

SELECT engagement_date_start,
		MAX(IF(age='10+ weeks', engagement_active_user_cnt,NULL)) '10+ weeks',
        MAX(IF(age='9 weeks', engagement_active_user_cnt,NULL)) '9 weeks',
        MAX(IF(age='8 weeks', engagement_active_user_cnt,NULL)) '8 weeks',
        MAX(IF(age='7 weeks', engagement_active_user_cnt,NULL)) '7 weeks',
        MAX(IF(age='6 weeks', engagement_active_user_cnt,NULL)) '6 weeks',
        MAX(IF(age='5 weeks', engagement_active_user_cnt,NULL)) '5 weeks',
        MAX(IF(age='4 weeks', engagement_active_user_cnt,NULL)) '4 weeks',
        MAX(IF(age='3 weeks', engagement_active_user_cnt,NULL)) '3 weeks',
        MAX(IF(age='2 weeks', engagement_active_user_cnt,NULL)) '2 weeks',
        MAX(IF(age='1 weeks', engagement_active_user_cnt,NULL)) '1 weeks',
        MAX(IF(age='less than a week', engagement_active_user_cnt,NULL)) 'less than a week'
FROM test
GROUP BY engagement_date_start
