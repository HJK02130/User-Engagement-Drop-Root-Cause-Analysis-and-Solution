WITH period AS (
	SELECT pst_start, pst_end
	FROM rollup_periods
	WHERE period_id=1007 AND DATE_FORMAT(pst_start, '%Y-%m-%d')>='2014-04-25'
)

SELECT *, (weekly_active_users-LAG(weekly_active_users) OVER())/LAG(weekly_active_users) OVER()*100.0 WAU_increase_percent
FROM (
	SELECT DATE_FORMAT(period.pst_start, '%Y-%m-%d') date, 
			COUNT(DISTINCT events.user_id) weekly_active_users
	FROM events INNER JOIN period ON (events.occurred_at BETWEEN pst_start AND pst_end)
				INNER JOIN users ON (events.user_id=users.user_id)
	WHERE event_type='engagement' AND users.state='active'
	GROUP BY period.pst_start
	HAVING period.pst_start BETWEEN '2014-04-25' AND '2014-08-31'
	   AND DAYOFWEEK(period.pst_start) =2
) temp