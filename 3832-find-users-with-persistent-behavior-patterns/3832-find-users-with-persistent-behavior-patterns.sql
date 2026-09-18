WITH daily AS (
    SELECT
        user_id,
        action_date,
        action
    FROM activity
    GROUP BY user_id, action_date
    HAVING COUNT(*) = 1
),

ranked AS (
    SELECT
        user_id,
        action,
        COUNT(*) AS streak_length,
        MIN(action_date) AS start_date,
        MAX(action_date) AS end_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM (
        SELECT
            user_id,
            action_date,
            action,
            DATE_SUB(
                action_date,
                INTERVAL ROW_NUMBER() OVER (
                    PARTITION BY user_id, action
                    ORDER BY action_date
                ) DAY
            ) AS grp
        FROM daily
    ) AS t
    GROUP BY user_id, action, grp
    HAVING COUNT(*) >= 5
)

SELECT
    user_id,
    action,
    streak_length,
    start_date,
    end_date
FROM ranked
WHERE rn = 1
ORDER BY streak_length DESC, user_id ASC;