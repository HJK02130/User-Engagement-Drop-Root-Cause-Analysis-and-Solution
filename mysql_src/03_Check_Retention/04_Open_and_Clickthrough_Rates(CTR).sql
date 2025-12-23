SELECT 
		STR_TO_DATE(weekstart, '%Y-%m-%d') weekstart, 
		#SUM(CASE WHEN action1='sent_weekly_digest' THEN 1 ELSE 0 END) sent_weekly_digest_all,
        #SUM(CASE WHEN action1='sent_weekly_digest' AND action2='email_clickthrough' THEN 1 ELSE 0 END) sent_weekly_digest_ct,
        (SUM(CASE WHEN action1='sent_weekly_digest' AND action2='email_clickthrough' THEN 1 ELSE 0 END))/(SUM(CASE WHEN action1='sent_weekly_digest' THEN 1 ELSE 0 END))*100.0 weekly_ctr,
        #SUM(CASE WHEN action1='sent_weekly_digest' AND action3='email_open' THEN 1 ELSE 0 END) sent_weekly_digest_opr,
        (SUM(CASE WHEN action1='sent_weekly_digest' AND action3='email_open' THEN 1 ELSE 0 END))/(SUM(CASE WHEN action1='sent_weekly_digest' THEN 1 ELSE 0 END))*100.0 weekly_open_rate,
        #SUM(CASE WHEN action1='sent_reengagement_email' THEN 1 ELSE 0 END) sent_retain_all,
        #SUM(CASE WHEN action1='sent_reengagement_email' AND action2='email_clickthrough' THEN 1 ELSE 0 END) sent_retain_ct,
        (SUM(CASE WHEN action1='sent_reengagement_email' AND action2='email_clickthrough' THEN 1 ELSE 0 END))/(SUM(CASE WHEN action1='sent_reengagement_email' THEN 1 ELSE 0 END))*100.0 retain_ctr,
        #SUM(CASE WHEN action1='sent_reengagement_email' AND action3='email_open' THEN 1 ELSE 0 END) sent_retain_opr,
        (SUM(CASE WHEN action1='sent_reengagement_email' AND action3='email_open' THEN 1 ELSE 0 END))/(SUM(CASE WHEN action1='sent_reengagement_email' THEN 1 ELSE 0 END))*100.0 retain_open_rate
FROM (
	SELECT e1.user_id user_id, e1.occurred_at occured_at1, e1.action action1, e2.occurred_at occurred_at2, e2.action action2, e3.occurred_at occurred_at3, e3.action action3, DATE_FORMAT((DATE_SUB(e1.occurred_at, INTERVAL WEEKDAY(e1.occurred_at) DAY)), '%Y-%m-%d') weekstart
	FROM emails e1 LEFT JOIN emails e2 ON (e1.occurred_at < e2.occurred_at AND 
											e2.occurred_at < DATE_ADD(e1.occurred_at, INTERVAL 5 MINUTE) AND
											e1.user_id = e2.user_id AND 
											(e2.action='email_clickthrough'))
					LEFT JOIN emails e3 ON (e1.occurred_at < e3.occurred_at AND
											e3.occurred_at < DATE_ADD(e1.occurred_at, INTERVAL 5 MINUTE) AND
											e1.user_id = e3.user_id AND
											(e3.action='email_open'))
	WHERE DATE_FORMAT(e1.occurred_at, '%Y-%m-%d')>='2014-05-01' AND DATE_FORMAT(e1.occurred_at, '%Y-%m-%d')<'2014-09-01' AND
			e1.action='sent_weekly_digest' OR e1.action='sent_reengagement_email'
) emails_reacts
GROUP BY STR_TO_DATE(weekstart, '%Y-%m-%d')