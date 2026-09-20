# Write your MySQL query statement below
WITH output as (SELECT session_id, user_id,
                        TIMESTAMPDIFF(MINUTE,MIN(event_timestamp),MAX(event_timestamp)) as session_duration_minutes,
                        SUM(CASE WHEN event_type = "scroll" THEN 1 ELSE 0 END) as scroll_count,
                        SUM(CASE WHEN event_type = "click" THEN 1 ELSE 0 END) as click_count,
                        SUM(CASE WHEN event_type = "purchase" THEN event_value ELSE 0 END) AS purchase
                FROM app_events
                GROUP BY user_id,session_id
                HAVING TIMESTAMPDIFF(MINUTE,MIN(event_timestamp),MAX(event_timestamp)) >= 30
                        AND SUM(CASE WHEN event_type = "scroll" THEN 1 ELSE 0 END) >=5)

SELECT session_id, user_id, session_duration_minutes, scroll_count
FROM output
WHERE (click_count*1.00/scroll_count) < 0.20
        AND purchase = 0
ORDER BY scroll_count DESC, session_id ASC;