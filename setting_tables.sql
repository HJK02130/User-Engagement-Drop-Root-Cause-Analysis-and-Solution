ALTER TABLE yammer.users MODIFY user_id integer;
ALTER TABLE yammer.users MODIFY created_at datetime;
ALTER TABLE yammer.users MODIFY company_id integer;
ALTER TABLE yammer.users MODIFY activated_at mediumtext;
ALTER TABLE yammer.users MODIFY activated_at datetime;

ALTER TABLE yammer.events MODIFY user_id integer;
ALTER TABLE yammer.events MODIFY occurred_at datetime;
ALTER TABLE yammer.events MODIFY user_type mediumtext;
ALTER TABLE yammer.events MODIFY user_type integer;

ALTER TABLE yammer.emails MODIFY user_id integer;
ALTER TABLE yammer.emails MODIFY occurred_at datetime;
ALTER TABLE yammer.emails MODIFY user_type integer;

ALTER TABLE yammer.rollup_periods MODIFY period_id integer;
ALTER TABLE yammer.rollup_periods MODIFY time_id datetime;
ALTER TABLE yammer.rollup_periods MODIFY pst_start datetime;
ALTER TABLE yammer.rollup_periods MODIFY pst_end datetime;
ALTER TABLE yammer.rollup_periods MODIFY utc_start datetime;
ALTER TABLE yammer.rollup_periods MODIFY utc_end datetime;