WITH qualified_users AS (
    SELECT user_id
    FROM course_completions
    GROUP BY user_id
    HAVING AVG(course_rating) >= 4
       AND COUNT(*) >= 5
),

ranked AS (
    SELECT
        c.user_id,
        c.course_name,
        ROW_NUMBER() OVER (
            PARTITION BY c.user_id
            ORDER BY c.completion_date
        ) AS rn
    FROM course_completions c
    JOIN qualified_users q
        ON c.user_id = q.user_id
)

SELECT
    b.course_name AS first_course,
    a.course_name AS second_course,
    COUNT(*) AS transition_count
FROM ranked a
JOIN ranked b
    ON a.user_id = b.user_id
   AND a.rn = b.rn + 1
GROUP BY b.course_name, a.course_name
ORDER BY transition_count DESC, first_course ASC, second_course ASC;