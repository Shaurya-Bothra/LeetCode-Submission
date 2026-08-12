# Write your MySQL query statement below
SELECT user_id, 
    Round(AVG(CASE WHEN  activity_type = "free_trial" then activity_duration end),2) as trial_avg_duration,
    Round(AVG(CASE WHEN  activity_type = "paid" then activity_duration end),2) as paid_avg_duration
FROM UserActivity
GROUP BY user_id
HAVING SUM(activity_type = "paid") != 0 AND SUM(activity_type = "free_trial") > 0
ORDER BY user_id;