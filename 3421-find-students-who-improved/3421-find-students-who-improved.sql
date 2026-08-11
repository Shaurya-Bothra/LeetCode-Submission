# Write your MySQL query statement below
WITH scores_with_values AS (
    SELECT
        student_id,
        subject,
        exam_date,

        FIRST_VALUE(score) OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date
        ) AS first_score,

        FIRST_VALUE(score) OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date DESC
        ) AS latest_score
    FROM Scores
)
SELECT DISTINCT
    student_id,
    subject,
    first_score,
    latest_score
FROM scores_with_values
WHERE latest_score > first_score
ORDER BY student_id, subject;