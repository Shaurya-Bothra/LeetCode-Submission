# Write your MySQL query statement below
WITH nosales AS (
        SELECT o.sales_id as id
        FROM Orders o
        JOIN Company c
        ON o.com_id=c.com_id
        WHERE c.name = 'RED')

SELECT name
FROM Salesperson
WHERE sales_id NOT IN (SELECT id FROM nosales);