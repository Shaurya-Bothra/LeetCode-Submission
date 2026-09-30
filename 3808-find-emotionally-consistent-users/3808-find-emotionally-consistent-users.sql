WITH eligible_users AS (
    SELECT user_id
    FROM reactions
    GROUP BY user_id
    HAVING COUNT(DISTINCT content_id) >= 5
),
ranks AS (
    SELECT
        user_id,
        reaction,
        DENSE_RANK() OVER (
            PARTITION BY user_id
            ORDER BY COUNT(reaction) DESC
        ) AS rn
    FROM reactions
    GROUP BY user_id, reaction
)
SELECT
    r.user_id,
    r.reaction AS dominant_reaction,
    ROUND(
        AVG(CASE WHEN x.reaction = r.reaction THEN 1 ELSE 0 END),
        2
    ) AS reaction_ratio
FROM ranks r
JOIN eligible_users e
    ON r.user_id = e.user_id
JOIN reactions x
    ON r.user_id = x.user_id
WHERE r.rn = 1
GROUP BY r.user_id, r.reaction
HAVING reaction_ratio >= 0.60
ORDER BY reaction_ratio DESC, user_id ASC;