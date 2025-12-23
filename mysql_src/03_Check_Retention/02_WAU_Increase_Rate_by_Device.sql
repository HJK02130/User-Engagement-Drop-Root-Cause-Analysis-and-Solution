WITH period AS (
	SELECT pst_start, pst_end
	FROM rollup_periods
	WHERE period_id=1007 AND DATE_FORMAT(pst_start, '%Y-%m-%d')>='2014-04-25'
), events_device_type AS (
	SELECT *, (CASE WHEN device IN ('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635','htc one','samsung galaxy note','amazon fire phone') THEN 'phone'
					WHEN device IN ('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface','samsumg galaxy tablet') THEN 'tablet'
                    ELSE 'computer' END) device_type
	FROM events
)

SELECT *, (weekly_active_users-LAG(weekly_active_users) OVER())/LAG(weekly_active_users) OVER()*100.0 WAU_increase_percent,
		(computer-LAG(computer) OVER())/LAG(computer) OVER()*100.0 WAU_computer_increase_percent,
        (phone-LAG(phone) OVER())/LAG(phone) OVER()*100.0 WAU_phone_increase_percent,
        (tablet-LAG(tablet) OVER())/LAG(tablet) OVER()*100.0 WAU_tablet_increase_percent
FROM (
	SELECT DATE_FORMAT(period.pst_start, '%Y-%m-%d') date, 
			COUNT(DISTINCT events_device_type.user_id) weekly_active_users,
			COUNT(DISTINCT IF(device_type='computer', events_device_type.user_id, NULL)) AS computer,
			COUNT(DISTINCT IF(device_type='phone', events_device_type.user_id, NULL)) AS phone,
			COUNT(DISTINCT IF(device_type='tablet', events_device_type.user_id, NULL)) AS tablet
	FROM events_device_type INNER JOIN period ON (events_device_type.occurred_at BETWEEN pst_start AND pst_end)
				INNER JOIN users ON (events_device_type.user_id=users.user_id)
	WHERE event_type='engagement' AND users.state='active'
	GROUP BY period.pst_start
	HAVING period.pst_start BETWEEN '2014-04-25' AND '2014-08-31'
	   AND DAYOFWEEK(period.pst_start) =2
) temp