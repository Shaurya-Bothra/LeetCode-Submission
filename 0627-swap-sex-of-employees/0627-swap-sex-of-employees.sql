# Write your MySQL query statement below
UPDATE Salary
SET SEX = case
            when sex="m" then "f"
            when sex="f" then "m"
            end;